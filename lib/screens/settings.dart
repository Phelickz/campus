import 'package:campus/screens/feedss.dart';
import 'package:campus/services/theme_notifier.dart';
import 'package:campus/state/authstate.dart';
import 'package:campus/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    return SafeArea(
      child: Scaffold(
        backgroundColor: _darkTheme ? Colors.black : Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: _darkTheme ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                    duration: Duration(seconds: 3),
                    child: Feedss(),
                    type: PageTransitionType.fade),
              );
            },
          ),
          backgroundColor: _darkTheme ? Colors.black : Colors.grey[300],
          elevation: 0,
          centerTitle: true,
          title: Text(
            'SETTINGS',
            style: TextStyle(
              color: _darkTheme ? Colors.white : Colors.brown[900],
              fontFamily: 'WorkSansBold',
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black
                      ),
                    ),
                    // DayNightSwitch(

                    //   value: _darkTheme,
                    //   onChanged: (val) {
                    //     setState(() {
                    //       _darkTheme = val;
                    //     });
                    //     onThemeChanged(val, themeNotifier);
                    //   },
                    // ),
                    Switch(
                      activeTrackColor: Colors.blue,
                      inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.grey[300],
                      activeColor: Colors.blue,
                      value: _darkTheme,
                      onChanged: (val) {
                        setState(() {
                          _darkTheme = val;
                        });
                        onThemeChanged(val, themeNotifier);
                      },
                    )
                  ],
                ),
                SizedBox(height: 23),
                Text(
                  'NOTIFICATIONS',
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'WorkSansSemiBold',
                        color: _darkTheme ? Colors.white : Colors.black),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Messages',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    Switch(
                      activeTrackColor: Colors.blue,
                      inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.grey[300],
                      activeColor: Colors.blue,
                      value: true,
                      onChanged: (value) {
                        setState(() {
                          value = false;
                        });
                      },
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'New Follows',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    Switch(
                      activeTrackColor: Colors.blue,
                      inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.grey[300],
                      activeColor: Colors.blue,
                      value: true,
                      onChanged: (value) {
                        setState(() {
                          value = true;
                        });
                      },
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'App Vibrations',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    Switch(
                      activeTrackColor: Colors.blue,
                      inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.grey[300],
                      activeColor: Colors.blue,
                      value: false,
                      onChanged: (value) {
                        setState(() {
                          value = true;
                        });
                      },
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'App Sounds',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    Switch(
                      activeTrackColor: Colors.blue,
                      inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.grey[300],
                      activeColor: Colors.blue,
                      value: true,
                      onChanged: (value) {
                        setState(() {
                          value = true;
                        });
                      },
                    )
                  ],
                ),
                Divider(),
                SizedBox(height: 20),
                Text(
                  'LEGAL',
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'WorkSansSemiBold',
                        color: _darkTheme ? Colors.white : Colors.black),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Terms of Service',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_right,
                        color: _darkTheme ? Colors.white : Colors.black
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Privacy Policy',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_right,
                        color: _darkTheme ? Colors.white : Colors.black
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'App Licenses',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_right,
                        
                        color: _darkTheme ? Colors.white : Colors.black,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'CONTACT US',
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'WorkSansSemiBold',
                        color: _darkTheme ? Colors.white : Colors.black),
                ),
                Divider(),
                Text(
                  'Rate Us',
                  style: TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Help and Support',
                  style: TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Share This App',
                  style: TextStyle(fontSize: 20, fontFamily: 'WorkSansMedium',
                        color: _darkTheme ? Colors.white : Colors.black),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: () async {
                      final _auth = Provider.of<AuthenticationState>(context,
                          listen: false);
                      await _auth.logout();
                      gotoLoginScreen(context);
                    },
                    child: Text(
                      'SIGN OUT',
                      style:
                          TextStyle(fontSize: 23, fontFamily: 'WorkSansBold',
                        color: _darkTheme ? Colors.red : Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'DELETE MY ACCOUNT',
                    style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'WorkSansBold',
                        color: Colors.red),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
