import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserServices() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  // get user phone number from users table by uid

  Future<String> getUserPhone(String uid) async {
    print("Fetching phone for UID: $uid");
    var _doc = await _firestore.collection("users").doc(uid).get();

    if (!_doc.exists) {
      throw Exception("User not found!");
    }

    var phone = _doc.data()?["phone"];
    print("Phone number retrieved: $phone"); // Debug output

    return phone;
  }

  Future createAccount(
      {required name,
      required String phone,
      required image_url,
      required token,
      required email,
      required String code,
      required String password,
      uid}) async {
    var newphone = phone;

    if (phone.length == 11) {
      newphone = phone.substring(1);
    }

    await _firestore.collection("users").doc(uid).get().then((value) {
      if (!value.exists) {
        _firestore.collection("users").doc(uid).set({
          "full_name": name,
          "phone": code + newphone,
          "profile_image": image_url,
          "token": token,
          "email": email,
          "isAdmin": false,
          "password": password,
        });
      } else {
        return true;
      }
    });
    return true;
  }

  Future<UserModel> getUser() async {
    try {
      var _doc = await _firestore
          .collection("users")
          .where("phone",
              isEqualTo:
                  await getUserPhone(FirebaseAuth.instance.currentUser!.uid))
          .get();
      // print(_doc.data());
      if (_doc.size > 0) {
        return UserModel.fromDocumentSnapshot(documentSnapshot: _doc.docs[0]);
      } else
        return UserModel();
    } catch (e) {
      return UserModel();
    }
  }

  Future checkUserCoursesNullToken() async {
    try {
      var _doc = await _firestore
          .collection("players")
          .where("phone",
              isEqualTo:
                  await getUserPhone(FirebaseAuth.instance.currentUser!.uid))
          .get();
      _doc.docs.forEach((element) async {
        if (element.data()["token"] == null || element.data()["token"] == "") {
          await _firestore
              .collection("players")
              .doc(element.id)
              .update({"token": FirebaseAuth.instance.currentUser!.uid});
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkAdmin(String phone) async {
    try {
      var querySnapshot = await _firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .where("isAdmin", isEqualTo: true)
          .get();

      print(
          "Admin Check for $phone: Found ${querySnapshot.docs.length} records");

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  Future<bool> checkRegister(String phone) async {
    try {
      print("Checking registration for phone: $phone");

      var querySnapshot = await _firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();

      print(
          "Registration Check for $phone: Found ${querySnapshot.docs.length} records");

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking registration: $e");
      return false;
    }
  }
}
