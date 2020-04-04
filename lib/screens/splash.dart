import 'dart:async';

import 'package:flutter/material.dart';

import 'launch.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), () {
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Launch()));
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange[900]
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/arqcoaster_2x.png'),
                        
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text(
                        'Tryber',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold
                        ),)
                    ],)
                )
              ),
               Expanded(
                 flex: 1,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     CircularProgressIndicator(),
                     Padding(padding: EdgeInsets.only(top: 20.0)),
                     Text('Meet. Connect. \n          Love',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),)
                   ],
                 ))
            ],
          )
        ],
      ),
    );
  }
}
