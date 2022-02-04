import 'package:flutter/material.dart';
import 'package:flutter_weather_app/pages/place_selected_page.dart';

import 'city_selection_page.dart';




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
    
    SelectCity(),
    PlaceSelected(
       title: 'Place',
    ),
    
    Text('pepo')
    
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined,),
            label: 'City',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_tilt_shift_sharp),
            label: 'Mars',
          ),
        ],
       currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}