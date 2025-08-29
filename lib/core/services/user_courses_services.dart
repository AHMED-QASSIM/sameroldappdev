import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smaergym/core/models/add_bronze_model.dart';
import 'package:smaergym/core/models/add_gold_model.dart';
import 'package:smaergym/core/models/add_silver_model.dart';
import 'package:smaergym/core/models/sections_model.dart';

import '../models/notifications_model.dart';

class UserCoursesServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserCoursesServices() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  Future<Stream<List<NotificationModel>>> getNotifications() async{
    var token = await FirebaseMessaging.instance.getToken();
    print(token);
    var _doc =  _firestore
        .collection("notifications")
        .where("tokens", arrayContains: token)
        .orderBy("date", descending: true)
        .snapshots();

        return _doc.map((event) => event.docs
        .map((e) => NotificationModel.fromDocumentSnapshot(documentSnapshot: e))
        .toList());
  }


    Future<List> getPrevCourses(String phone) async {
    var _doc = await _firestore.collection("players").where("phone",isEqualTo: phone).orderBy("date",descending: true).get();
    if(_doc.size > 0){
    return _doc.docs.map((e) => e.data()).toList();
    }else {
      return [];
    }
  }

  Future getCourses(String phone) async {
    var _doc = await _firestore.collection("players").where("phone",isEqualTo: phone).orderBy("date",descending: true).get();
    if(_doc.size > 0){
    return _doc.docs[0];
    }else {
      return null;
    }
  }

  Future getExecirses(courseId) async {
    var _doc = await _firestore.collection("courses").doc(courseId).get();
    return _doc.data();
  }

  Future updateGoldInfo(docid,AddGoldMode goldMode) async{
   try {
    var doc = await _firestore.collection("players").doc(docid).update(await goldMode.toJson());
   }catch(e){
    print(e);
   }
  }

    Future updateSilverInfo(docid,AddSilverModel goldMode) async{
   try {
    var doc = await _firestore.collection("players").doc(docid).update(await goldMode.toJson());
   }catch(e){
    print(e);
   }
  }



    Future updateBronzeInfo(docid,AddBronzeModel goldMode) async{
   try {
    var doc = await _firestore.collection("players").doc(docid).update(await goldMode.toJson());
   }catch(e){
    print(e);
   }
  }


}
