import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/city_model.dart';

import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

late Future<List<WeatherModel>> items;

late String citiSelect = "";

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.blue,
    ),
    home: const PlaceSelected(title: 'Flutter Demo Home Page'),
  );
}

class PlaceSelected extends StatefulWidget {
  const PlaceSelected({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PlaceSelected> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<PlaceSelected> {
  late Future<WeatherModel> items;

  @override
  void initState() {
    items = fetchPlanets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (citiSelect=="") {
      return MaterialApp(
        home: Scaffold(body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text('No hay nada selecciondo'),
        ),),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/earth.png",
                    ),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  FutureBuilder<WeatherModel>(
                    future: items,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return name(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<WeatherModel> fetchPlanets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt('indexCity');
    citiSelect = coord[index!].city;
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${citiSelect}&appid=b67e3a6f41956f3d2f21725d8148ee93'));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load planets');
    }
  }

  /* Widget _planetItem(Current planet) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: 150,
        child: Card(
          child: InkWell(
            splashColor: Colors.red.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: SizedBox(
              width: 30,
              height: 400,
              child: Column(
                children: [
                  Text(planet.visibility.toString()),
                  
                ],
              ),
            ),
          ),
        ));
  }*/

  Widget name(WeatherModel response) {
    return Text(
      response.name,
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
