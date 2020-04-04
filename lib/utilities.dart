import 'package:campus/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus/state/authstate.dart';

import 'screens/feedss.dart';


void gotoHomeScreen(BuildContext context) {
    
  //  print(user['kUID']);
  Future.microtask((){
    // var user = Provider.of<AuthenticationState>(context, listen: false).exposeUser();
    if (Provider.of<AuthenticationState>(context, listen: false).authStatus ==
      kAuthSuccess){
        // var user = Provider.of<AuthenticationState>(context, listen: false).exposeUser();
        Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Feedss()));
      }
  });
}


void gotoLoginScreen(BuildContext context) {
  Future.microtask((){
    if (Provider.of<AuthenticationState>(context, listen: false).authStatus ==
      null){
        Navigator.push(context, 
              MaterialPageRoute(builder: (context) => LoginPage()));
      }
  });
}