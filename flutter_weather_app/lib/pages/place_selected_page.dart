import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_weather_app/models/one_call_model.dart';
import 'package:http/http.dart' as http;

late Future<List<Current>> items;




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
    home: const Mangas(title: 'Flutter Demo Home Page'),
  );
}

class Mangas extends StatefulWidget {
  const Mangas({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Mangas> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<Mangas> {
  late Future<Current> items;
  

  @override
  void initState() {
    items = fetchPlanets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<Current>(
            future: items,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _planetItem(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

 

  Future<Current> fetchPlanets() async {
    final response = await http.get(Uri.parse('https://api.jikan.moe/v4/manga?type=manga&order_by=mal_id&sort=desc&q=JoJo no '));
    if (response.statusCode == 200) {
      return OneCallModel.fromJson(jsonDecode(response.body)).current;
    } else {
      throw Exception('Failed to load planets');
    }
  }

  

  Widget _planetItem(Current planet) {
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
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}