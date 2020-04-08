import 'package:campus/screens/feedss.dart';
import 'package:campus/screens/launch.dart';
import 'package:campus/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:campus/state/authstate.dart';
import 'package:provider/provider.dart';
import 'utilities.dart';
import 'package:campus/services/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  //  final user = AuthenticationState().getCurrentUser();
    // final user = Provider.of<AuthenticationState>(context).getCurrentUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationState())
      ],
      
        child: MaterialApp(
          
        theme: ThemeData(
            primarySwatch: Colors.blue,
        ),
        home: SplashScreen()
      )
          
    );
  }
}
