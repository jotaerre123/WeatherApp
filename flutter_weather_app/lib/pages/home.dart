import 'package:flutter/material.dart';
import 'package:flutter_weather_app/pages/place_selected_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'city_selection_page.dart';
import 'map.dart';
import 'mars_page.dart';




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    PlaceSelected2(
       title: 'Place',
    ),

    MapClickPage(),


    Mars()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/earth.png",
                ),
                fit: BoxFit.cover)),
        
      ),

      bottomNavigationBar: CurvedNavigationBar(

        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.easeIn,
        color: Colors.black,
        buttonBackgroundColor: Colors.amberAccent,
        index: _selectedIndex,
        height: 60,
        
        items:  <Widget>[
           Image.asset('assets/images/iconearth.png'),
           Image.asset('assets/images/iconmap.png'),
           Image.asset('assets/images/destinyIcon.png', width: 55,),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}