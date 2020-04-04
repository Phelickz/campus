

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
         color: Colors.black,
         onPressed: null)
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          
          children: <Widget>[
            Icon(FontAwesomeIcons.connectdevelop,
              color: Colors.red,
              size: 100,),
            SizedBox(height: 30),
            
            Text('Login', 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "WorkSansSemiBold"
              ),)
          ],
        ),
      ),
    );
  }
}