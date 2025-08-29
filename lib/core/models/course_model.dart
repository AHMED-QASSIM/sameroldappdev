import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {

  String? docid;
  String? reason;
  String? unWantedFood;
  String? injuries;
  String? notes;
  String? age;
  String? hight;
  String? weight;
  String? workHours;
  String? sleeping;

  CourseModel({this.docid});

  CourseModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
   
    docid = documentSnapshot.id;
  }
}
