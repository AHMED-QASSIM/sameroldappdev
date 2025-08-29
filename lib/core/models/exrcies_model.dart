import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  String? name;
  String? description;
  String? youtubeLink;
    String? youtubeLink2;

  String? image;
  String? docid;
  dynamic? categeoryId;

  ExerciseModel({this.description,this.docid,this.image,this.name,this.youtubeLink , this.youtubeLink2});

  ExerciseModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
    name = d["name"];
     description = d["description"];
     youtubeLink = d["youtubeLink"];
          youtubeLink2 = d["youtubeLink2"];

     image = d["image"];
     categeoryId = d["categeoryId"];
    docid = documentSnapshot.id;
  }
}
