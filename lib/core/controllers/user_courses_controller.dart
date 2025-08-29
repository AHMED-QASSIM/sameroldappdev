import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:smaergym/core/controllers/user_controller.dart';
import 'package:smaergym/core/models/add_bronze_model.dart';
import 'package:smaergym/core/models/add_gold_model.dart';
import 'package:smaergym/core/models/add_silver_model.dart';
import 'package:smaergym/core/services/user_courses_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class UserCoursesController extends GetxController {

 var loading = true.obs;
 var loadPrevois = true.obs;
 RxList previosCourses = RxList();

 Rx currentCourse = Rx(null);
 Rx courseExercises = Rx(null);
 Rx viewCourseExe = Rx(null);
 Rx loadCourseExe = Rx(false);
 var loadbtn = false.obs;



getCourseExe(id) async{
  loadCourseExe.value = true;
  var response = await UserCoursesServices().getExecirses(id);
  viewCourseExe.value = response;
  print(response);
print(id);
  loadCourseExe.value = false;
}

getPreviosCourses() async {
  loadPrevois.value = true;
  var response = await UserCoursesServices().getPrevCourses(Get.find<UserController>().user.value.phone ?? "+964771087733");
  previosCourses.clear();
  previosCourses.addAll(response.skip(1));
  loadPrevois.value = false;
}
  
  getCurrentCourse() async{
    loading = true.obs;
    
    var response = await UserCoursesServices().getCourses(Get.find<UserController>().user.value.phone ?? "");

    if(response != null){
if(response.data()["status"] > 2){
  if(response.data()["courseId"] != ""){
   var getExe = await UserCoursesServices().getExecirses(response.data()["courseId"]);
      courseExercises.value = getExe;
    loading.value = false;
  }
   
    }else {
    loading.value = false;
    
    }
    }
    loading.value = false;
    
    currentCourse.value = response;
    
  }


  addGoldInfo({required AddGoldMode goldMode,required List images,required List testes,required String docid}) async{

  loadbtn.value = true;

  goldMode.images = await uploadFiles(images);
  goldMode.tests = await uploadFiles(testes);
  goldMode.name = Get.find<UserController>().user.value.name;
  goldMode.playerPhoto = Get.find<UserController>().user.value.image;


  var response = await UserCoursesServices().updateGoldInfo(docid, goldMode);

  loadbtn.value = false;

  Get.back();
   AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'تم ارسال معلوماتك',
        btnCancelOnPress: () {},
          desc: "سيقوم الكابتن بكتابة نظامك التدريبي بأسرع وقت",
        btnCancel: Container(),
        btnOk: Container(),
        btnOkOnPress: () {},
      )..show();
  getCurrentCourse();


    
  }


    addSilverInfo({required AddSilverModel silverModel,required List images,required String docid}) async{

  loadbtn.value = true;

  silverModel.images = await uploadFiles(images);
  silverModel.name = Get.find<UserController>().user.value.name;
  silverModel.playerPhoto = Get.find<UserController>().user.value.image;


  var response = await UserCoursesServices().updateSilverInfo(docid, silverModel);

  loadbtn.value = false;

  Get.back();
   AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'تم ارسال معلوماتك',
        btnCancelOnPress: () {},
          desc: "سيقوم الكابتن بكتابة نظامك التدريبي بأسرع وقت",
        btnCancel: Container(),
        btnOk: Container(),
        btnOkOnPress: () {},
      )..show();
  getCurrentCourse();


    
  }



    addBronzeInfo({required AddBronzeModel addBronzeModel,required List images,required String docid}) async{

  loadbtn.value = true;

  addBronzeModel.images = await uploadFiles(images);
  addBronzeModel.name = Get.find<UserController>().user.value.name;
  addBronzeModel.playerPhoto = Get.find<UserController>().user.value.image;


  var response = await UserCoursesServices().updateBronzeInfo(docid, addBronzeModel);

  loadbtn.value = false;

  Get.back();
   AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'تم ارسال معلوماتك',
        btnCancelOnPress: () {},
          desc: "سيقوم الكابتن بكتابة نظامك التدريبي بأسرع وقت",
        btnCancel: Container(),
        btnOk: Container(),
        btnOkOnPress: () {},
      )..show();
  getCurrentCourse();


    
  }

    Future<List<String>> uploadFiles(List images) async {
    var imageUrls = await Future.wait(images.map((e) => uploadImage(e)));
    return imageUrls;
  }

    Future<String> uploadImage(image) async{
     File file = File(image["imageFile"].path);
     
        firebase_storage.Reference ref =  firebase_storage.FirebaseStorage.instance
          .ref('players')
          .child(DateTime.now().toString() + "." + image["imageType"]);

          firebase_storage.UploadTask uploadTask = ref.putFile(file);
          var im = await (await uploadTask).ref.getDownloadURL();
          return im;
  }


  @override
  void onInit() {
    // TODO: implement onInit
   getCurrentCourse(); 
   getPreviosCourses();
    super.onInit();
  }

}