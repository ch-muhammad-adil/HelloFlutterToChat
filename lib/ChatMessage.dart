import 'package:flutter/material.dart';
import 'models/Message.dart';

class ChatMessage extends StatelessWidget {
  final Message message;
  final BuildContext context;
  final AnimationController animationController;
  ChatMessage(
      {this.message, this.context, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        //new
        sizeFactor: new CurvedAnimation(
            //new
            parent: animationController,
            curve: Curves.easeOut), //new
        axisAlignment: 0.0, //new
        child: new Container(
          //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(backgroundImage: new NetworkImage(message.userProfileUrl)),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(message.userName, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(message.message),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) //new
        );
  }
}
