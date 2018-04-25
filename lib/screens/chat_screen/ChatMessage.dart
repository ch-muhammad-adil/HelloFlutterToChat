import 'package:flutter/material.dart';
import 'package:hello_flutter/models/Message.dart';


class ChatMessage extends StatelessWidget {
  final Message message;
  final BuildContext context;
  final AnimationController animationController;
  ChatMessage({this.message, this.context, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                    backgroundImage: new NetworkImage(message.userProfileUrl)),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(message.userName,
                        style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: (message.mediaFileUrl != null && !message.mediaFileUrl.isEmpty)
                          ? new Image.network(
                              message.mediaFileUrl,
                              width: 250.0,
                            )
                          : new Text(message.message),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(message.dateTime.toString()),
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
