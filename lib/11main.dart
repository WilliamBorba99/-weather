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
  String cidade;
  String pais;
  var temperatura;
  var tempoDescricao;
  var tempoAgora;
  var umidadeAr;
  var vento;

  Future getWeather() async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$cidade&$pais&appid=6f98272e660fdf50246f7e35d1e83208");
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
          title: new Text('Previsão do tempo'),
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
          decoration: new InputDecoration(hintText: 'Cidade'),
          maxLength: 40,
          validator: _validarCidade,
          onSaved: (String val) {
            cidade = val;
          },
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'País'),
          maxLength: 40,
          validator: _validarPais,
          onSaved: (String val) {
            pais = val;
          },
        ),
        new SizedBox(height: 15.0),
        new RaisedButton(
          color: Colors.white,
          onPressed: _sendForm,
          child: new Text('Enviar'),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 4.0),
          child: Text(
              tempoDescricao.toString() != null
                  ? 'Clima: ' + tempoDescricao.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              )),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 4.0),
          child: Text(
              temperatura.toString().isNotEmpty != null
                  ? 'Temperatura ' + temperatura.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              )),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 4.0),
          child: Text(
              umidadeAr.toString() != null
                  ? 'Umidade Ar ' + umidadeAr.toString()
                  : "",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  String _validarCidade(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe a cidade";
    } else if (!regExp.hasMatch(value)) {
      return "A cidade deve apenas caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarPais(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe a Pais";
    } else if (!regExp.hasMatch(value)) {
      return "O país deve apenas caracteres de a-z ou A-Z";
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
