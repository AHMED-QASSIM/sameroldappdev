import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? title;
  String? body;
  Timestamp? dateTime;

  NotificationModel({
    this.title,
    this.body,
    this.dateTime,
  });

  NotificationModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
    title = d["title"];
    body = d["body"];
    dateTime = d["date"];
  }
}
