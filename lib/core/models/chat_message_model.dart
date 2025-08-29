import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class ChatMessage{
    int? date;

  String? message;
  String? sender;
  String? reciver;
  String? type;
  String? fileName;
  String? id;

  ChatMessage({ this.message,this.reciver,this.sender,this.fileName , this.date});


  ChatMessage.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}){
    dynamic d = documentSnapshot.data();
    id = documentSnapshot.id;
        date = d["date"];

    message = d["message"];
    sender = d["sender"];
    reciver = d["reciver"];
    type = d["type"] != null ? d["type"] : "text";
    fileName = d["fileName"] != null ? d["fileName"] : "لا يوحد اسم";
  }

}