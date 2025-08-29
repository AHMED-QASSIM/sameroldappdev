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


class CoursesDetailsController extends GetxController {

 var loading = true.obs;
 var loadPrevois = true.obs;
 RxList previosCourses = RxList();

 Rx currentCourse = Rx(null);
 Rx courseExercises = Rx(null);
 var loadbtn = false.obs;


  
  getCurrentCourse(user_phone) async{
    loading = true.obs;
    var response = await UserCoursesServices().getCourses(user_phone);

    if(response != null){
if(response.data()["status"] > 2){
      var getExe = await UserCoursesServices().getExecirses(response.data()["courseId"]);
      courseExercises.value = getExe;
    loading.value = false;
    }else {
    loading.value = false;
    
    }
    }
    loading.value = false;
    
    currentCourse.value = response;
  }




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}