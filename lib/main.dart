import 'package:bot_toast/bot_toast.dart';
import 'package:campus/screens/splash.dart';
import 'package:campus/state/userState.dart';
import 'package:flutter/material.dart';
import 'package:campus/state/authstate.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/theme_notifier.dart';
import 'utils/theme.dart';


// void main() => runApp(MyApp());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationState()),
          ChangeNotifierProvider(create: (_) => UserNotifier()),
        ],
        child: MaterialApp(
          builder: BotToastInit(),
            theme: themeNotifier.getTheme(),
            home: SplashScreen()));
  }
}
