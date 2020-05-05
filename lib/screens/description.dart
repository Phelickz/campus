import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import '../screens/addTopic.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import '../utils/theme.dart';

class Description extends StatefulWidget {
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  var _darkTheme;
  
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      backgroundColor: _darkTheme ? Colors.grey[800] : Colors.grey[200],
      appBar: AppBar(
      backgroundColor: _darkTheme ? Colors.grey[800] : Colors.grey[200],

        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.87,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Card(
                color: _darkTheme ? Colors.grey[800] : Colors.white,
                elevation: 10,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 10, right: 10),
                  child: Text(
                    'Start Trends. Connect with People. Share Ideas. Start a conversation, hold a meeting, discuss a topic, Argue a position. Do all that here with the active Student community. Ask Questions and let people share their ideas. Gain knowledge. Meet. Connect. Love',
                    style: TextStyle(
                        fontFamily: 'WorkSansMedium',
                        fontSize: 28,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 25,
              left: MediaQuery.of(context).size.width * 0.87 / 2,
              child: CircleAvatar(
                child: Icon(FontAwesomeIcons.peopleCarry),
                backgroundColor:_darkTheme? Colors.grey[800] : Colors.white,
                radius: 35,
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton(
              child: Icon(Icons.arrow_right),
              elevation: 0,
              color: _darkTheme? Colors.grey[800] : Colors.grey[200],
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => AddTopic()));
              },
            ),
          )
        ],
      ),
    );
  }
}
