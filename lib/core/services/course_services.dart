import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smaergym/core/models/add_course_model.dart';
import 'package:smaergym/core/models/sections_model.dart';
import 'package:smaergym/core/models/sets_model.dart';

class CourseServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CourseServices() {
    _firestore.settings = Settings(persistenceEnabled: true);
  }

  Future addCourse(AddCourseModel courseModel) async {
    var _doc = await _firestore.collection("courses").add(courseModel.toJson());
    return true;
  }

    Future<bool> deleteCourse(docid) async{
    var doc = await _firestore.collection("courses").doc(docid).delete();
    return true;
  }

 Future<List> getCourses(String? sectionId) async {
    var _doc = await _firestore.collection("courses").orderBy("date",descending: true);
    if(sectionId != null){
     _doc = _doc.where("section",isEqualTo: sectionId);
    }
    var getData = await _doc.get();
    return getData.docs.map((e) => e).toList();
  }

  Future<List<SetModel>> getSets() async {
    var _doc = await _firestore.collection("sets").get();
    return _doc.docs.map((e) => SetModel.fromDocumentSnapshot(documentSnapshot: e)).toList();
  }
}
