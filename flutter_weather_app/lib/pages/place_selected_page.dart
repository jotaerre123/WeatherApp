import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/city_model.dart';
import 'package:flutter_weather_app/models/one_call_model.dart';

import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';

late Future<List<WeatherModel>> items;

late String citiSelect = "";
late double latSelected = 0;
late double lngSelected = 0;
late LatLng? _lastTap = null;

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
  final String title;

  @override
  State<PlaceSelected> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<PlaceSelected> {
  late Future<WeatherModel> currentWeather;
  late Future<List<Hourly>> hourlyWeather;
  late Future<List<Daily>> dailyWeather;

  @override
  void initState() {
    currentWeather = fetchWeather();
    dailyWeather = fetchDaily();
    hourlyWeather = fetchHourly();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*if (citiSelect=="") {
      return MaterialApp(
        home: Scaffold(body: Container(
          height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/earth.png",
                ),
                fit: BoxFit.cover)),
          child: const Center(
            child: Text('No hay nada selecciondo', style: TextStyle(color: Colors.white),),
          ),
        ),),
      );
    } else {*/
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
                  future: currentWeather,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 170, bottom: 50),
                            child: name(snapshot.data!),
                          ),
                          _dataInBox(snapshot.data!),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                  child: FutureBuilder<List<Daily>>(
                      future: dailyWeather,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _dailyList(snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.white),
                          );
                        }

                        return const Center(child: CircularProgressIndicator());
                      }),
                ),
                    FutureBuilder<List<Hourly>>(
                    future: hourlyWeather,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _hourlyList(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text(
                          '${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    })

              ],
            ),
          ),
        ),
      ),
    );
  }
  //}

  Future<WeatherModel> fetchWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt('indexCity');
    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');
    citiSelect = coord[index!].city;
    latSelected = lat!;
    lngSelected = lng!;
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${latSelected}&lon=${lngSelected}&appid=b67e3a6f41956f3d2f21725d8148ee93'));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Future<List<Daily>> fetchDaily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt('indexCity');
    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');
    citiSelect = coord[index!].city;
    latSelected = lat!;
    lngSelected = lng!;
   

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${latSelected}&lon=${lngSelected}&exclude=minutely&appid=b67e3a6f41956f3d2f21725d8148ee93&units=metric'));
    if (response.statusCode == 200) {
      return OneCallModel.fromJson(jsonDecode(response.body)).daily;
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Future<List<Hourly>> fetchHourly() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt('indexCity');
    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');
    citiSelect = coord[index!].city;
    latSelected = lat!;
    lngSelected = lng!;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${latSelected}&lon=${lngSelected}&exclude=minutely&appid=b67e3a6f41956f3d2f21725d8148ee93&units=metric'));
    if (response.statusCode == 200) {
      return OneCallModel.fromJson(jsonDecode(response.body)).hourly;
    } else {
      throw Exception('Failed to load planets');
    }
  }

  Widget name(WeatherModel response) {
    return Column(
      children: [
        Text(
          response.name,
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text('Current Location',
              style: TextStyle(color: Colors.white, fontSize: 13)),
        )
      ],
    );
  }

  Widget _dataInBox(WeatherModel response) {
    String _selectedDateTime = formatDate(
        DateTime.now(), [DD, ", ", dd, " ", MM, " ", yyyy],
        locale: const SpanishDateLocale());

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.8),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 10,
              child: Text(_selectedDateTime,
                  style: const TextStyle(color: Colors.white, fontSize: 16))),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Positioned(
                      child: Text((response.main.temp - 273).toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 65,
                              fontWeight: FontWeight.bold))),
                ),
                const Positioned(
                    child: Text("ºC",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Positioned(
              bottom: 10,
              child: Wrap(
                spacing: 50,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward_sharp,
                        color: Colors.white,
                      ),
                      Text((response.main.tempMin - 273).toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_sharp,
                        color: Colors.white,
                      ),
                      Text((response.main.tempMax - 273).toStringAsFixed(1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget _hourlyList(List<Hourly> hourlyResponse){

    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        
        scrollDirection: Axis.horizontal,
        itemCount: hourlyResponse.length,
        itemBuilder: (context, index){
           return _hourlyItem(hourlyResponse.elementAt(index), index);
        }
      ),
    );

  }

  Widget _hourlyItem(Hourly hour, int index){
    return Container(
      width: 100,
        decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.8),
       
      ),
      child: Column(children: [
        Text(hour.pressure.toString(),)
      ],),
    );
  }

   Widget _dailyList(List<Daily> dailyResponse){

    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        
        scrollDirection: Axis.horizontal,
        itemCount: dailyResponse.length,
        itemBuilder: (context, index){
           return _dailyItem(dailyResponse.elementAt(index), index);
        }
      ),
    );

  }

  Widget _dailyItem(Daily daily, int index){
    return Container(
      width: 100,
        decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.8),
      ),
      child: Column(children: [
        Text(daily.pressure.toString(),),
        Image.network('http://openweathermap.org/img/wn/' +daily.weather[0].icon +'.png'),
        Text(daily.temp.day.toString()),
      ],),
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
