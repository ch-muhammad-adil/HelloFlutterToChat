import 'package:flutter/material.dart';
import 'package:hello_flutter/screens/chat_screen/ChatScreen.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text('Login Using Google Account'),
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new HomeScreen()),
            );
          },
        ),
      ),
    );
  }
}
