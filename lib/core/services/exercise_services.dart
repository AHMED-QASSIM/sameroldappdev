
import 'dart:io'; 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smaergym/core/models/exrcies_model.dart';
import 'package:smaergym/core/models/sections_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ExerciseServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ExerciseServices() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  Future<List<ExerciseModel>> getExercieses(int? categeoryId) async {
    var _doc = await _firestore.collection("exerciese").orderBy("date",descending: true);
    if(categeoryId != null){
     _doc = _doc.where("categeoryId",isEqualTo: categeoryId);
    }
    var getData = await _doc.get();
    return getData.docs.map((e) => ExerciseModel.fromDocumentSnapshot(documentSnapshot: e)).toList();
  }

    Future<ExerciseModel> getExercieseById(String? id) async {
    var _doc = await _firestore.collection("exerciese").doc(id).get();
    return ExerciseModel.fromDocumentSnapshot(documentSnapshot: _doc);
  }

  Future<bool> deleteExe(docid) async{
    var doc = await _firestore.collection("exerciese").doc(docid).delete();
    return true;
  }

  Future<bool> addExercise({required String name,required String youtubeLink,required String youtubeLink2,required description,required categeoryId,required image}) async{
   await _firestore.collection("exerciese").add({
      "name" : name,
      "description" : description,
      "youtubeLink" : youtubeLink,
      "youtubeLink2" : youtubeLink2,
      "image" : image,
      "categeoryId" : categeoryId,
      "date" : DateTime.now()
    });
     return true;
  }

  final _storage = firebase_storage.FirebaseStorage.instance;
Future<bool> edit({
  required String docid,
  String? name,
  String? youtubeLink,
    String? youtubeLink2,

  String? description,
  int? categeoryId,
  File? newImage, 
}) async {
  Map<String, dynamic> data = {
    "date": DateTime.now(),
  };

  if (name != null && name.isNotEmpty) data["name"] = name;
  if (description != null && description.isNotEmpty) data["description"] = description;
  if (youtubeLink != null && youtubeLink.isNotEmpty) data["youtubeLink"] = youtubeLink;
    if (youtubeLink != null && youtubeLink.isNotEmpty) data["youtubeLink2"] = youtubeLink2;

if (categeoryId != null) data["categeoryId"] = categeoryId;

  // Upload new image if exists
  if (newImage != null) {
    final ref = FirebaseStorage.instance.ref().child("exercises/$docid.jpg");
    await ref.putFile(newImage);
    final imageUrl = await ref.getDownloadURL();
    data["image"] = imageUrl;
  }

  await FirebaseFirestore.instance.collection("exerciese").doc(docid).update(data);
  return true;
}


}
