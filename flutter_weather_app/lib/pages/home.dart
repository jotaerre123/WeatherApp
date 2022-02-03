import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:
        
         Container(
           decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/fondo.png",
                    ),
                    fit: BoxFit.cover)),
           child: Center(
             
            child: Column(
              children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70, left: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 60),
                          child: Text('Sevilla'),
                        ),
                        Text('Current Location')
                      ],
                    ),
                  ),
                  Icon(Icons.wb_sunny_outlined)
                ],
              )
            ],),
        ),
         ),
      );
  }
}