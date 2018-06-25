import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/screens/chat_screen/ChatScreen.dart';
import 'package:hello_flutter/utils/AuthenticationUtils.dart';
class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }


}
class LoginScreenState extends State<LoginScreen> {


  @override
  void initState() {
    firebaseAuth.onAuthStateChanged.firstWhere((user) => user!=null).then((user) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new ChatScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text('Login Using Google Account'),
          onPressed: () {
            new Future.delayed(new Duration(seconds: 1))
                .then((user) => ensureLoggedIn().then((user){
                  print(user);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new ChatScreen()),
                  );
            }));
          },
        ),
      ),
    );
  }


}