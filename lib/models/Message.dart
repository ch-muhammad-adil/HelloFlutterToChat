import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class Message {
  final String message;
  final String userName;
  final String userProfileUrl;
  final String key;
  final String userKey;
  final DateTime dateTime;

  Message(this.userKey,this.message, this.userName, this.userProfileUrl,this.dateTime);

  Message.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        userName = snapshot.value["userName"],
        userProfileUrl = snapshot.value["userProfileUrl"],
        userKey = snapshot.value["userKey"],
        message = snapshot.value["message"];


  Message.fromMap(Map map, String key) :
        key = key,
        dateTime = new DateTime.fromMillisecondsSinceEpoch(map["date"]),
        userName = map["userName"],
        userProfileUrl = map["userProfileUrl"],
        userKey = map["userKey"],
        message = map["message"];

   toJson() {
    return {
      "userKey":userKey,
      "message": message,
      "userName": userName,
      "userProfileUrl": userProfileUrl,
      "date":dateTime.millisecondsSinceEpoch
    };
  }

}