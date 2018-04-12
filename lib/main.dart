import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'HomeScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hello Flutter',
      theme: defaultTargetPlatform == TargetPlatform.iOS         //new
          ? kIOSTheme                                              //new
          : kDefaultTheme,
      home: new HomeScreen(),
    );
  }
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.red,
  accentColor: Colors.orangeAccent[400],
);



