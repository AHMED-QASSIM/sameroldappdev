import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smaergym/core/controllers/course_controller.dart';
import 'package:smaergym/core/models/add_course_model.dart';
import 'package:smaergym/core/models/sections_model.dart';
import 'package:smaergym/core/validator/validators.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/custom_text_form_field.dart';
import 'package:smaergym/core/widgets/dropdown_widget.dart';
import 'package:smaergym/screens/admin/courses/select_muscle_screen.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../../core/controllers/sections_controller.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var selectedValue;
  SectionsController sectionsController = Get.find();
  CourseController courseController = Get.find();
  TextEditingController title = TextEditingController();
  final ImagePicker _picker = ImagePicker();
   File imageFile = File("");
  convNumToText(int number){
    switch(number){
      case 0 : return "الاول";
      case 1 : return "الثاني";
      case 2 : return "الثالث";
      case 3 : return "الرابع";
      case 4 : return "الخامس";
      case 5 : return "السادس";
      case 6 : return "السابع";
      case 7 : return "الثامن";
      case 8 : return "التاسع";


    }
  }

    var baseImage;
   var imageTypes;

   Future pickImage() async {
    var uploadimage = await _picker.pickImage(source: ImageSource.gallery);

    if (uploadimage != null) {
      final dir = await path_provider.getTemporaryDirectory();
      final timeStamp = DateTime.now().millisecond;
      final targetPath = dir.absolute.path + "/temp$timeStamp.jpg";

      testCompressAndGetFile(File(uploadimage.path), targetPath).then((value) {
    
       setState(() {
        courseController.image.value = value!;
        Uint8List bytes = value.readAsBytesSync();
        String base64Image = base64Encode(bytes);
        baseImage = base64Image;
        var imageType = p.extension(value.path);
        imageType = imageType.replaceAll('.', '');
        imageTypes = imageType;
       });
         return true;
      });
    }


 
  }



  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 88, minWidth: 1024, minHeight: 1000);
    return result;
  }

 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("انشاء كورس جديد"),
      ),
      body: SingleChildScrollView(child: Obx(()=> Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
              children: [
                CustomTextFormField(validators: [
                  IsRequiredRule()
                ],
                onChanged: (v){
                  courseController.addCourseModel.value.title = v;
                },
                isRtl: true,
                hint: "اكتب اسم الكورس",
                bottomSpace: 2,
                label: "الاسم",),

                Obx(()=> DropdownWidget(
                  
                  hint: "اختر قسم للكورس",
                  label: " القسم",
                  items: sectionsController.sections.value.skip(1).toList(), onChange: (v){
                  courseController.addCourseModel.value.section = v.docid;
                  setState(() {
                    selectedValue = v;
                  });
                },selectedValue: selectedValue,)),
SizedBox(height: 25,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor ,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("الايام",style: TextStyle(fontSize: 16.sp,color: Colors.white,fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: (){
                          courseController.addCourseModel.value.days!.add(Day(
                            exercises: [],
                            image: "",
                            name: null
                          ));
                          setState(() {
                            
                          });
                      }, child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(CupertinoIcons.add,size: 20.sp,)))
                    ],
                  ),
                ),

                SizedBox(height: 20,),
                if(courseController.addCourseModel.value.days != null)
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: courseController.addCourseModel.value.days!.length,
                  itemBuilder: (context,pos){
                    List<Exercise> exercise = courseController.addCourseModel.value.days![pos].exercises!;
                  return Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                             
                             Obx(() => Expanded(child: Text( courseController.addCourseModel.value.days![pos].name ?? "اليوم ${convNumToText(pos)}",style: TextStyle(fontSize: 16.sp,color: Theme.of(context).primaryColor),))),
                           
                                GestureDetector(
                              onTap: (){
                               Get.bottomSheet(StatefulBuilder(builder: (context,setState){
                                return Obx(() => Container(
                                padding: EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFormField(
                                        validators: [IsRequiredRule()], onChanged: (v){
                                        courseController.addCourseModel.value.days![pos].name = v;
                                      }, isRtl: true, hint: "اكتب اسم اليوم", bottomSpace: 2, label: "الاسم",),
                                    
                                          GestureDetector(
                                                  onTap: ()async{
                                                  await  pickImage().then((value){
                                                      setState((){});
                                                    });
                                                      setState((){});
                                                  },
                                                  child: Container(
                                                    width: 60.sp,
                                                    height: 60.sp,
                                                    child: Icon(CupertinoIcons.photo),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Theme.of(context).primaryColor),
                                                      image: courseController.image.value !=
                                                    ""
                                                ? DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(courseController.image.value))
                                                : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                Text("صورة العضلة",style: TextStyle(fontSize: 16.sp),),
                                     Obx(() => CustomButton(
                                      topSpace: 2,
                                      loading: courseController.loadAddDaySet.value,
                                      onPressed: (){
                                      
                                      if(courseController.image.value.path != "" && courseController.addCourseModel.value.days![pos].name!.trim() != ""){
                                       courseController.addDayImage(day:pos, imageType: imageTypes);
                                      }else {
                                        Get.snackbar("خطأ", "املا جميع الحقول",colorText: Colors.white,backgroundColor: Colors.black,snackPosition: SnackPosition.BOTTOM,margin: EdgeInsets.all(20));
                                      }
                                    }, text: "حفظ",backgroundColor: Theme.of(context).primaryColor,))
                                    ],
                                  ),
                                ),
                                height: 350.sp,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                                color: Get.theme.scaffoldBackgroundColor,
                                ),
                               ));
                               }));
                              },
                               child: Container(
                                width: 30.sp,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                height: 30.sp,
                                 child: Icon(CupertinoIcons.settings,color: Colors.white)
                               ),
                             ),
                             SizedBox(width: 10,),

                             GestureDetector(
                              onTap: (){
                               
                                Get.to(SelectMuscle(day: pos))!.then((value){
                                  setState(() {
                                    
                                  });
                                });
                              },
                               child: Container(
                                width: 30.sp,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                height: 30.sp,
                                 child: Icon(CupertinoIcons.add,color: Colors.white,)
                               ),
                             ),
                             SizedBox(width: 10,),
                             GestureDetector(
                              onTap: (){
                                courseController.addCourseModel.value.days!.removeAt(pos);
                                setState(() {
                                  
                                });
                              },
                               child: Container(
                                width: 30.sp,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(143, 183, 66, 58),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                height: 30.sp,
                                 child: Icon(CupertinoIcons.delete,color: Colors.white,size: 17.sp,)
                               ),
                             )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(),
                        SizedBox(height: 5,),

                        Obx(()=> courseController.addCourseModel.value.days![pos].exercises!.length == 0 ? Text("لا يوجد تمارين",style: TextStyle(fontSize: 14.sp),) : Column(
                          children: courseController.addCourseModel.value.days![pos].exercises!.map((e){
                            print(e.toJson());
                            return e.exerciseSuper!.length > 0? Container(
                              child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10)
                              ),                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    width: 70.sp,
                                    padding: EdgeInsets.all(7),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("سوبر",style: TextStyle(fontSize: 14.sp,color: Colors.white,height: 1.2),),
                                        SizedBox(width: 5,),
                                        Icon(CupertinoIcons.star,color: Colors.white,size: 15.sp,)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                   Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.name!,style: TextStyle(fontSize: 14.sp),),
                                  Text(e.sets!,style: TextStyle(fontSize: 14.sp),),

                                ],
                              ),
                              SizedBox(height: 5,),
                              Divider(),
                                Column(
                                  children:  e.exerciseSuper!.map((s){
                                    return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(s.name ?? "ماكو",style: TextStyle(fontSize: 14.sp),),
                                      Text(s.sets ?? "ماكو",style: TextStyle(fontSize: 14.sp),),

                                    ],
                              );
                                  }).toList(),
                                ),

                                ],
                              )
                            ),
                            ) : Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10)
                              ),                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.name ?? "no",style: TextStyle(fontSize: 14.sp),),
                                  Text(e.sets ?? "no",style: TextStyle(fontSize: 14.sp),),

                                ],
                              ),
                            );
                          }).toList(),
                        ))
                      ],
                    ),
                  );

                }),

                CustomButton(
                  topSpace: 1,
                  loading: courseController.addCourseLoad.value,
                  onPressed: (){
                    if(_formKey.currentState!.validate() && selectedValue != null){
                    courseController.createCourse();
                    }
                    if(selectedValue == null){
                      Get.snackbar("خطأ", "يرجى تحديد القسم اولا");
                    }
                },text: "انشاء كورس",backgroundColor: Theme.of(context).primaryColor,),
                SizedBox(height: 40,),

              ],
            ))
          ],
        ),
      ))),
    );
  }
}