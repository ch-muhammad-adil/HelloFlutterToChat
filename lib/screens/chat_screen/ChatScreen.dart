import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_flutter/models/Message.dart';

import 'dart:async';
import 'package:hello_flutter/screens/chat_screen/ChatMessage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hello_flutter/utils/AuthenticationUtils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final TextEditingController _textController = new TextEditingController();
  static final List<ChatMessage> _messages = <ChatMessage>[];
  final reference = FirebaseDatabase.instance.reference().child('messages');
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.all(3.0),
            child: new Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(Icons.photo_camera),
                      onPressed: () async {
                        File imageFile = await ImagePicker.pickImage(
                            source: ImageSource.gallery);

                        int random = new Random().nextInt(100000);                         //new
                        StorageReference ref =                                             //new
                        FirebaseStorage.instance.ref().child("chat-images/image_$random.jpg");         //new
                        StorageUploadTask uploadTask = ref.put(imageFile);                 //new
                        Uri downloadUrl = (await uploadTask.future).downloadUrl;

                        Message message = new Message(
                            firebaseUser.uid,
                            "",
                            googleSignIn.currentUser.displayName,
                            googleSignIn.currentUser.photoUrl,
                            new DateTime.now(),downloadUrl.toString());
                        _sendMessage(message: message);

                      }),
                ),
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
    Message message = new Message(
        firebaseUser.uid,
        text,
        googleSignIn.currentUser.displayName,
        googleSignIn.currentUser.photoUrl,
        new DateTime.now(),"");
    _sendMessage(message: message);
  }

  void _sendMessage({Message message}) {
    ChatMessage chatMessage = new ChatMessage(
      message: message,
      context: context,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 500)),
    );
    reference.push().set(message.toJson());
    setState(() {
      _messages.insert(0, chatMessage);
    });
    chatMessage.animationController.forward();
  }



  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }


  bool _load = true;
  @override
  void initState() {
    super.initState();

    firebaseAuth.currentUser().then((user) {
      firebaseUser = user;
      return user;
    });

    // fetching list of data..

    reference.orderByChild("date").once().then((snapshot) {
      Map data = snapshot.value;
      final messagesList = [];
      data.forEach((key, snap) {
        messagesList.add(new Message.fromMap(snap, key));
      });
      messagesList.sort((a,b) {
        return a.dateTime.compareTo(b.dateTime);
      });
      for (final message in messagesList) {
        ChatMessage chatMessage = new ChatMessage(
          message: message,
          context: context,
          animationController: new AnimationController(
              vsync: this, duration: new Duration(milliseconds: 200)),
        );
        setState(() {
          _messages.insert(0, chatMessage);
        });
        chatMessage.animationController.forward();
      }
      setState(() {
        _load = false;
      });
    }, onError: () {
      print("error");
      setState(() {
        _load = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        _load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: new Padding(
                padding: const EdgeInsets.all(0.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat App"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
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
                  decoration:
                      new BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                )
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? new BoxDecoration(
                    border: new Border(
                        top: new BorderSide(color: Colors.grey[200])))
                : null,
          ),
          loadingIndicator
        ],
      ),
    );
  }
}
