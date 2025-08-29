import 'package:cloud_firestore/cloud_firestore.dart';
class ChatModel {
  String? user_name;
  String? user_image;
  String? sender;
  Timestamp? date;
  String? last_message;
  String? id;
  String? user;
  String? user_phone;
  dynamic? pinned;
  dynamic? subscription;
  bool? isRead;

  ChatModel({
   this.date,
   this.last_message,
   this.sender,
   this.user_image,
   this.user_name,
   this.id,
   this.user,
   this.user_phone,
   this.pinned,
    this.subscription,
    this.isRead
  });

  ChatModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}){
    dynamic d = documentSnapshot.data();
    id = documentSnapshot.id;
    user_image = d["user_photo"];
    user_name = d["user_name"];
    date = d["date"];
    user = d["user"];
    user_phone = d["user_phone"];
    last_message = d["last_message"];
    pinned = d["pinned"];
    sender = d["sender"];
    subscription = d["subscription"];
    isRead = d["isRead"] != null ? d["isRead"] : false;
  }
}
