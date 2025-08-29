import 'dart:ffi';
import 'dart:io'; 
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/services/exercise_services.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/exrcies_model.dart';

class ExerciseController extends GetxController {

var load = true.obs;
var loadadd = false.obs;
var loadExe = true.obs;
Rx<ExerciseModel> exe = Rx<ExerciseModel>(ExerciseModel());

RxList<ExerciseModel> exercises = RxList<ExerciseModel>();
var loadDelete = false.obs;
  
  getExeById(String id) async {
    loadExe.value = true;
    var respone = await ExerciseServices().getExercieseById(id);
    exe.value = respone;
    loadExe.value = false;
  }

  getExercises(int? categeoryId) async{
    exercises.clear();
    load.value = true;
    var respone = await ExerciseServices().getExercieses(categeoryId);
    exercises.addAll(respone);
    load.value = false;
  }

  addExercise({required String name,required String youtubeLink, required String youtubeLink2,required description,required categoryId,required imageType,required imageFile}) async{
   loadadd.value = true;
    firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('exercisees')
                    .child(DateTime.now().toString() + "." + imageType);

       await ref.putFile(imageFile).then((p0) {
                  ref.getDownloadURL().then((value) async{
   var respone = await ExerciseServices().addExercise(name: name, youtubeLink: youtubeLink,youtubeLink2: youtubeLink2, description: description, categeoryId: categoryId,image: value);
   getExercises(categoryId);
   loadadd.value = false;
   Get.back();
   Get.snackbar("اضافه تمرين", "تم اضافه تمرين جديد",snackPosition: SnackPosition.BOTTOM);
                  });
       });


  }


  deleteExersise(categoryId,docid){
          AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'حذف تمرين',
        titleTextStyle: TextStyle(fontSize: 18.sp,height: 1.5,fontWeight: FontWeight.bold),
        descTextStyle: TextStyle(fontSize: 14.sp,height: 1),
       desc: "هل انت متأكد من حذف التمرين ؟",
        btnCancelOnPress: () {},
        btnCancel: Obx(()=>  Container(
          height: 45.sp,
          child: CustomButton(
            loading: loadDelete.value,
            onPressed: () async{
            loadDelete.value = true;
            var response = await ExerciseServices().deleteExe(docid);
            loadDelete.value = false;
            Get.back();
            getExercises(categoryId);
            Get.snackbar("حذف تمرين", "تم حذف التمرين");
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


Future<void> editExercise({
  required String docid,
  required String name,
  required String youtubeLink,
    required String youtubeLink2,

  required String description,
  required int categoryId,
  File? newImageFile, // optional
}) async {
  try {
    loadadd.value = true;

    await ExerciseServices().edit(
      docid: docid,
      name: name,
      youtubeLink: youtubeLink,
      youtubeLink2: youtubeLink2,
      description: description,
      categeoryId: categoryId,
      newImage: newImageFile, // pass file if user picked one
    );

    await getExercises(categoryId);
    loadadd.value = false;
    Get.back();
    Get.snackbar("تعديل تمرين", "تم تعديل التمرين بنجاح",
        snackPosition: SnackPosition.BOTTOM);
  } catch (e) {
    loadadd.value = false;
    Get.snackbar("خطأ", e.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}


}