import 'package:campus/screens/feedss.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Notification.dart';
import 'profile.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(          
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.home), 
                onPressed: (){
              // Navigator.push(context, 
              // MaterialPageRoute(builder: (context) => Feedss()));
            }),
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => Search()));
                }),
              IconButton(
                icon: Icon(Icons.favorite_border), 
                onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Notifications()));
            }),
              IconButton(
                icon: Icon(FontAwesomeIcons.userEdit), 
                onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Profile()));
            }),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.red,
          child: Icon(Icons.add),),

      body: SafeArea(
              child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0
                      )
                    ]
                  ),
                  height: 50,
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.pink[400],
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.pink[400],),
                      hintText: 'Search User',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                      ),
                      // border: OutlineInputBorder(
                        
                      //   borderRadius: BorderRadius.circular(25),
                      //   borderSide: BorderSide()
                      // )
                    ),
                  ),
                ),
              )
            ],
          ),),
      ),
    );
  }
}