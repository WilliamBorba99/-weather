import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String cep;
  String cidade;
  String pais;
  var logradouro;
  var bairro;
  var localidade;
  var temperatura;
  var tempoDescricao;
  var tempoAgora;
  var umidadeAr;
  var vento;

  Future getWeather() async {
    http.Response responseLocalizacao =
        await http.get("https://viacep.com.br/ws/$cep/json/");
    var resultsLocalizacao = jsonDecode(responseLocalizacao.body);

    setState(() {
      this.logradouro = resultsLocalizacao['logradouro'];
      this.bairro = resultsLocalizacao['bairro'];
      this.localidade = resultsLocalizacao['localidade'];
    });

    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$localidade&Brazil&appid=6f98272e660fdf50246f7e35d1e83208");
    var results = jsonDecode(response.body);

    setState(() {
      this.temperatura = results['main']['temp'];
      this.tempoDescricao = results['weather'][0]['description'];
      this.tempoAgora = results['weather'][0]['main'];
      this.umidadeAr = results['main']['humidity'];
      this.vento = results['wind']['speed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        backgroundColor: Colors.blue,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text('Busca Localização'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: _formUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Cep'),
          maxLength: 40,
          validator: _validarCep,
          onSaved: (String val) {
            cep = val;
          },
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar'),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Logradouro: ' + logradouro.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Bairro: ' + bairro.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Localidade: ' + localidade.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Clima: ' + tempoDescricao.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Temperatura: ' + temperatura.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          child: Text(
            'Umidade do Ar: ' + umidadeAr.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _validarCep(String value) {
    String patttern = r'(^\d{5}-\d{3}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o cep";
    } else if (!regExp.hasMatch(value)) {
      return "Por favor, insira um cep valido";
    }
    return null;
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      this.getWeather();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
