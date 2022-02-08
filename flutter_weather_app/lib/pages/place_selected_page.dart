import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_weather_app/models/days&hours.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/one_call_model.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Future<List<WeatherModel>> items;

late String citiSelect = "";
late double latSelected = 0;
late double lngSelected = 0;

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const PlaceSelected2(title: 'Flutter Demo Home Page'),
  );
}

class PlaceSelected2 extends StatefulWidget {
  const PlaceSelected2({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PlaceSelected2> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<PlaceSelected2> {
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
    Size size = MediaQuery.of(context).size;
    if (latSelected == 0) {
      return Scaffold(
        body: Container(
          width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/earth.png",
                      ),
                      fit: BoxFit.cover),

        ),
        child: Center(
          child: Text(
                'NO HAY CIUDAD SELECCIONADA',
                style: TextStyle(color: Colors.white),
          ),
        ),));
    }
    return Scaffold(
        body: Center(
            child: Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/earth.png",
                      ),
                      fit: BoxFit.cover),
                ),
                child: SafeArea(
                  child: Stack(children: [
                    SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.03,
                          ),
                          child: Align(
                            child: FutureBuilder<WeatherModel>(
                              future: currentWeather,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return name(snapshot.data!);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.005,
                          ),
                          child: const Align(
                            child: Text('Current Location',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 20)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.03,
                          ),
                          child: Align(
                            child: FutureBuilder<WeatherModel>(
                              future: currentWeather,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return _temperature(snapshot.data!);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.25),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.03,
                            bottom: size.height * 0.01,
                          ),
                          child: FutureBuilder<WeatherModel>(
                            future: currentWeather,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return _minMaxTemperature(snapshot.data!);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.05)),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height * 0.01,
                                      left: size.width * 0.03,
                                    ),
                                    child: Text(
                                      'Forecast for today',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.width * 0.005),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: FutureBuilder<List<Hourly>>(
                                          future: hourlyWeather,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return _hourlyList(
                                                  snapshot.data!);
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                '${snapshot.error}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          })),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05,
                                    vertical: size.height * 0.02,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: size.height * 0.02,
                                              left: size.width * 0.03,
                                            ),
                                            child: Text(
                                              '7-day forecast',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height * 0.025,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
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
                      })
                              ),
                            ],
                          ),
                        ),
                      ),
                              ],
                            ),
                          ),
                        
                      ],
                    )),
                  ),
                ));
  }

  Widget name(WeatherModel response) {
    return Text(
      response.name,
      style: const TextStyle(color: Colors.white, fontSize: 60),
    );
  }

  Widget _temperature(WeatherModel response) {
    Size size = MediaQuery.of(context).size;
    String _selectedDateTime = formatDate(
        DateTime.now(), [DD, ", ", dd, " ", MM, " ", yyyy],
        locale: const SpanishDateLocale());

    double temperature = (response.main.temp) - 273;

    return Text(
      temperature.toStringAsFixed(1) + '˚C', //curent temperature
      style: TextStyle(
        color: temperature <= 0
            ? Colors.blue
            : temperature > 0 && temperature <= 15
                ? Colors.indigo
                : temperature > 15 && temperature < 30
                    ? Colors.deepPurple
                    : Colors.pink,
        fontSize: size.height * 0.13,
      ),
    );
  }

  Widget _minMaxTemperature(WeatherModel response) {
    Size size = MediaQuery.of(context).size;

    double min = (response.main.tempMin) - 273;
    double max = (response.main.tempMax) - 273;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          min.toStringAsFixed(1) + '˚C',
          style: TextStyle(
            color: min <= 0
                ? Colors.blue
                : min > 0 && min <= 15
                    ? Colors.indigo
                    : min > 15 && min < 30
                        ? Colors.deepPurple
                        : Colors.pink,
            fontSize: size.height * 0.03,
          ),
        ),
        Text(
          '/',
          style: TextStyle(
            color: Colors.white54,
            fontSize: size.height * 0.03,
          ),
        ),
        Text(
          max.toStringAsFixed(1) + '˚C',
          style: TextStyle(
            color: max <= 0
                ? Colors.blue
                : max > 0 && max <= 15
                    ? Colors.indigo
                    : max > 15 && max < 30
                        ? Colors.deepPurple
                        : Colors.pink,
            fontSize: size.height * 0.03,
          ),
        ),
      ],
    );
  }

  Widget _hourlyList(List<Hourly> hourlyResponse) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 24,
          itemBuilder: (context, index) {
            return _hourlyItem(hourlyResponse.elementAt(index), index);
          }),
    );
  }

  Widget _hourlyItem(Hourly hour, int index) {
    Size size = MediaQuery.of(context).size;
    dynamic temp = (hour.temp);
    double wind = (hour.windSpeed);
    int rain = hour.humidity;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            formatDate(listaHoras[index].hora, [HH, ":00 h"]),
            style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: Image.asset(
                  'assets/images/${hour.weather[0].icon}.png',
                  height: size.height * 0.06,
                ),
              ),
            ],
          ),
          Text(
            temp.toStringAsFixed(1) + '˚C',
            style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.025,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: Image.asset(
                  'assets/images/wind.png',
                  color: Colors.grey,
                  height: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            wind.toString() + 'km/h',
            style: TextStyle(
              color: Colors.grey,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: Icon(
                  Icons.umbrella_rounded,
                  color: Colors.blue,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            rain.toString() + '%',
            style: TextStyle(
              color: Colors.blue,
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }
  Widget _dailyList(List<Daily> dailyResponse){

    return SizedBox(
      height: 330,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        
        scrollDirection: Axis.vertical,
        itemCount: 7,
        itemBuilder: (context, index){
           return _dailyItem(dailyResponse.elementAt(index), index);
        }
      ),
    );

  }

  Widget _dailyItem(Daily daily, int index){
    Size size = MediaQuery.of(context).size;
    double min = (daily.temp.min);
    double max = (daily.temp.max);
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  formatDate(listaDias[index].day, [DD], locale: const SpanishDateLocale()),
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: Image.asset(
                  'assets/images/${daily.weather[0].icon}.png',
                  height: size.height * 0.06,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    min.toStringAsFixed(1)+'˚C',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    max.toStringAsFixed(1)+'˚C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color:Colors.white,
          ),
        ],
      ),
    );
  }

  Future<WeatherModel> fetchWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');

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

    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');

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

    var lat = prefs.getDouble('lat');
    var lng = prefs.getDouble('lng');

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
}
