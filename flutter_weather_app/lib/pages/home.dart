import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

/*final int _selectedIndex = 0;
static const List<Widget> _widgetOptions = <Widget>[
    PlaceSelected(title: 'PlaceSelected',
    ),
    Mangas(title: 'Mangas',

    ),
    Personajes(title: 'Personajes',
      
    ),
    
  ];*/


  /*void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/earth.png",
                ),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            //aqui van los datos
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined,),
            label: 'Anime',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Manga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_tilt_shift_sharp),
            label: 'Characters',
          ),
        ],
       /* currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,*/
      ),
    );
  }
}
