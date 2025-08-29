import 'package:cloud_firestore/cloud_firestore.dart';

class SectionModel {
  String? title;
  String? id;
  bool? selected;
  String? docid;

  SectionModel({ this.id,this.selected,this.title});

  SectionModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
    title = d["title"];
    id = d["id"];
    docid = documentSnapshot.id;
    selected = false;
  }
}
