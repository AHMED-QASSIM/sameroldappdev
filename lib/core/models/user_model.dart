import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? image;
  String? phone;
  String? id;
  bool? admin;
  String? email;

  UserModel({ this.name, this.id,this.image,this.phone,this.admin});

  UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    dynamic d = documentSnapshot.data();
    image = d["profile_image"];
    name = d["full_name"];
    phone = d["phone"];
    email = d["email"];
    admin = d["isAdmin"] ?? false;
    id = documentSnapshot.id;
  }
}
