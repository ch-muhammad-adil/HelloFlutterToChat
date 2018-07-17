import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.chat,
                          size: 50.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Flutchat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Stack(fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            "Let's Chat",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ],))
            ],
          )
        ],
      ),
    );
  }
}
