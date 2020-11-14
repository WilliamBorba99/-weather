import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      title: "Sr do Tempo",
      home: PaginaInicial(),
    ));

class PaginaInicial extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<PaginaInicial> {
  var temp;
  var deion;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather() async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=Blumenau&Brazil&appid=e8962427977895dc7b82576019a60ef1");
    var results = jsonDecode(response.body);

    setState(() {
      this.temp = results['main']['temp'];
      this.deion = results['weather'][0]['deion'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  void initState() {
    super.initState();
    this.getWeather();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "tempo agora",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(temp != null ? temp.toString() + "\u00B0" : "Loading",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Rain",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              )
            ]),
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperatura"),
                    trailing: Text(
                        temp != null ? temp.toString() + "\u00B0" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Clima"),
                    trailing:
                        Text(deion != null ? deion.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("umidade"),
                    trailing: Text(
                        humidity != null ? humidity.toString() : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Velocidade do Vento"),
                    trailing: Text(
                        windSpeed != null ? windSpeed.toString() : "Loading"),
                  )
                ],
              )))
    ]));
  }
}
