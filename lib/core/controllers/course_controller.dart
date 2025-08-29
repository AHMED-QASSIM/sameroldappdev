import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smaergym/core/models/add_course_model.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/models/exrcies_model.dart';
import 'package:smaergym/core/models/sets_model.dart';
import 'package:smaergym/core/services/course_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../widgets/custom_button.dart';
class CourseController extends GetxController {

Rx<AddCourseModel> addCourseModel = Rx<AddCourseModel>(AddCourseModel(
  title: "",
  date: DateTime.now(),
  section: "",
  days: [
  ],

));
Rx<File> image = Rx<File>(File(""));
Rx<dynamic> selected = Rx<dynamic>("");
Rx<ExerciseModel> selectedExe = Rx<ExerciseModel>(ExerciseModel());
Rx<dynamic> secondselected = Rx<dynamic>("");
Rx<bool> isSuper = Rx<bool>(false);
RxList<Super> secondExe = RxList<Super>([]);
var addCourseLoad = false.obs;
var loadCourses = true.obs;
RxList courses = RxList();
var loadDelete = false.obs;
RxList<SetModel> sets = RxList<SetModel>();
var loadAddDaySet = false.obs;

  getCourses(String? sectionId) async{
    courses.clear();
    loadCourses.value = true;
    var respone = await CourseServices().getCourses(sectionId);
    courses.value = respone;
    loadCourses.value = false;
  }

checkTmreenExists(docid,day) {
var list = addCourseModel.value.days![day].exercises;
var check = list!.where((element) => element.id == docid).toList();
if(check.length == 0){
  // check super

  var superlist = list.where((element) => element.exerciseSuper!.where((element) => element.id == docid).toList().length > 0).toList(); 
  
  return superlist.length;
}
return check.length;
}

addTamreenToCourse(day){
  print(secondExe.toJson());
addCourseModel.value.days![day].exercises!.add(Exercise(
id: selectedExe.value.docid,
sets: selected.value,
name: selectedExe.value.name,
exerciseSuper:secondExe.toList(),
));
selectedExe.value = ExerciseModel();
selected.value = Rx<dynamic>("");
isSuper.value = false;
secondExe.clear();
Get.back();
update();
}

  addDayImage({required day,required imageType}) async{
   loadAddDaySet.value = true;
    firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('daymucels')
                    .child(DateTime.now().toString() + "." + imageType);

       await ref.putFile(image.value).then((p0) {
                  ref.getDownloadURL().then((value) async{
                    addCourseModel.value.days![day].image = value;
                    loadAddDaySet.value = false;
                    image.value = File("");
                    Get.back();
                    update();
                  });
       });


  }

deleteCourse(docid,selectedSection){
   AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'حذف كورس',
        titleTextStyle: TextStyle(fontSize: 18.sp,height: 1.5,fontWeight: FontWeight.bold),
        descTextStyle: TextStyle(fontSize: 14.sp,height: 1),
       desc: "هل انت متأكد من حذف الكورس ؟",
        btnCancelOnPress: () {},
        btnCancel: Obx(()=>  Container(
          height: 45.sp,
          child: CustomButton(
            loading: loadDelete.value,
            onPressed: () async{
            loadDelete.value = true;
            var response = await CourseServices().deleteCourse(docid);
            loadDelete.value = false;
            Get.back();
            Get.back();

            getCourses(selectedSection);
            Get.snackbar("حذف كورس", "تم حذف الكورس");
          },text: "حذف",backgroundColor:Color.fromARGB(255, 204, 51, 51),),
        )),
        btnOk: Container(
          height: 45.sp,
          child: CustomButton(onPressed: (){
            Get.back();
          },text: "الغاء",backgroundColor:Colors.grey,),
        ),
        btnOkOnPress: () {},
      )..show();
}

createCourse() async{
  addCourseLoad.value = true;
  var respone = await CourseServices().addCourse(addCourseModel.value);
  addCourseLoad.value = false;
  Get.back();
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'تم اضافة كورس جديد',
        btnCancelOnPress: () {},
        btnCancel: Container(),
        btnOk: Container(),
        btnOkOnPress: () {},
      )..show();
      
       getCourses(addCourseModel.value.section);

      addCourseModel.value = AddCourseModel(
  title: "",
  date: DateTime.now(),
  section: "",
  days: [
  ],

);
}

getSets()async{ 
var respone = await CourseServices().getSets();
sets.addAll(respone);
}

@override
  void onInit() {
    // TODO: implement onInit
     getCourses(null);
     getSets();
    super.onInit();
  }
}