import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'models/Message.dart';
import 'dart:async';
import 'ChatMessage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _googleSignIn = new GoogleSignIn(scopes: ['email']);
  final String userName = "Adil";
  final TextEditingController _textController = new TextEditingController();
  static final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;
  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.all(3.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      //new
                      setState(() {
                        //new
                        _isComposing = text.length > 0; //new
                      }); //new
                    },
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(
                        hintText: "Enter Message"),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 0.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Send"),
                          onPressed: _isComposing
                              ? () =>
                                  _handleSubmitted(_textController.text) //new
                              : null,
                        )
                      : new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: _isComposing
                              ? () => _handleSubmitted(
                                  _textController.text) //modified
                              : null),
                )
              ],
            )));
  }

  Future _handleSubmitted(String text) async {
    _textController.clear();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _isComposing = false;
    });
    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({ String text }) {
    ChatMessage message = new ChatMessage(
      message: new Message(text, _googleSignIn.currentUser.displayName, _googleSignIn.currentUser.photoUrl),
      context: context,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 500)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }


  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null)
      user = await _googleSignIn.signInSilently();
    if (user == null) {
      try {
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    }
  }
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat App"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              reverse: true,
              padding: const EdgeInsets.all(5.0),
              itemCount: _messages.length,
            )),
            new Divider(
              height: 1.0,
            ),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ?
          new BoxDecoration(border: new Border(top: new BorderSide(color: Colors.grey[200]))):null,
      ),
    );
  }
}
