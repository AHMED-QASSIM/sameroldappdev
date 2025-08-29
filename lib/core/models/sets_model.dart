import 'package:cloud_firestore/cloud_firestore.dart';

class SetModel {
  String? name;
  String? docid;
  bool? selected;

  SetModel({this.name,this.selected});

  SetModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
    name = d["name"];
    selected = false;
    docid = documentSnapshot.id;
  }
}
