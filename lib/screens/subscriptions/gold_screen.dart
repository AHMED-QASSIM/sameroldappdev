import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smaergym/core/controllers/user_courses_controller.dart';
import 'package:smaergym/core/models/add_gold_model.dart';
import 'package:smaergym/core/validator/validators.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/custom_text_form_field.dart';
import 'package:smaergym/core/widgets/dropdown_widget.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../core/widgets/DropdownSets.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key,required this.docid});
  final String docid;

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var hrmon = [
    "نعم",
    "كلا",
  ];

  var selectedHrmon = null;
  var images = [];
  var tests = [];
    String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
 final ImagePicker _picker = ImagePicker();
        pickImage(type) async {
        var uploadimage = await _picker.pickMultiImage();


             if(uploadimage.length > 10 || images.length > 9){
          Get.snackbar("خطأ", "لا يمكن اختيار اكثر من 10 صور",snackPosition: SnackPosition.BOTTOM);
        }
        if (uploadimage != null && uploadimage.length <= 10 && images.length <= 9) {
        final dir = await path_provider.getTemporaryDirectory();
        final timeStamp = DateTime.now().millisecond;
        
        uploadimage.forEach((element) async {
                  final targetPath = dir.absolute.path + "/temp" +generateRandomString(5)+  ".jpg";

testCompressAndGetFile(File(element.path), targetPath).then((value) {
        Uint8List bytes = value!.readAsBytesSync();
        String base64Image = base64Encode(bytes);
        var imageType = p.extension(value.path);
        imageType = imageType.replaceAll('.', '');
        setState(() {
          if(type == 2){
tests.add({
          "imageFile" : value,
          "imageBase64" : base64Image,
          "imageType" : imageType,
        });
          }else {
            images.add({
          "imageFile" : value,
          "imageBase64" : base64Image,
          "imageType" : imageType,
        });
          }
       });
      });
        });
    }
    setState(() {});
  }
  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 88, minWidth: 1024, minHeight: 1000);
    return result;
  }
  deleteImage(e){
    setState(() {
      images.remove(e);
    });
  }

   deleteTest(e){
    setState(() {
      tests.remove(e);
    });
  }


  TextEditingController goal = TextEditingController();
  TextEditingController unWantedFood = TextEditingController();
  TextEditingController injurse = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController hight = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController sleep = TextEditingController();
  TextEditingController nots = TextEditingController();
  TextEditingController gymName = TextEditingController();
  TextEditingController gymAddress = TextEditingController();

  UserCoursesController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("ملئ معلومات الاشتراك الذهبي"),
      ),
      body: SingleChildScrollView(child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
               CustomTextFormField(validators: [IsRequiredRule()],
              label: "اسم القاعة ",
              controller: gymName,
              hint: "اكتب اسم قاعتك",),

                           CustomTextFormField(validators: [IsRequiredRule()],
              label: "عنوان القاعة ",
              controller: gymAddress,
              hint: "اكتب عنوان قاعتك",),

              CustomTextFormField(validators: [IsRequiredRule()],
              label: "هدف التمرين",
              controller: goal,
              hint: "اكتب هدفك في التمرين",),

                 CustomTextFormField(validators: [IsRequiredRule()],
              label: "اطعمة غير مرغوبة",
              controller: unWantedFood,
              hint: "اكتب اطمعة لا ترغب بتناولها",),

                      CustomTextFormField(validators: [IsRequiredRule()],
              label: "اصابات او تمارين لا يمكن عملها",
              controller: injurse,
              hint: "اذا كان لديك اصابات او تمارين غير مرغوبة",),

                     CustomTextFormField(validators: [IsRequiredRule()],
              label: "العمر",
              controller: age,
              keyboardType: TextInputType.number,
              hint: "اكتب عمرك"),

                       CustomTextFormField(validators: [IsRequiredRule()],
              label: "الطول",
              keyboardType: TextInputType.number,
              controller: hight,
              hint: "اكتب طولك"),

                    CustomTextFormField(validators: [IsRequiredRule()],
              label: "الوزن",
              keyboardType: TextInputType.number,
              controller: weight,
              hint: "اكتب وزنك"),

                       CustomTextFormField(validators: [IsRequiredRule()],
              label: "ساعات العمل",
              controller: work,
              keyboardType: TextInputType.number,

              hint: "اكتب ساعات عملك"),


                       CustomTextFormField(validators: [IsRequiredRule()],
              label: "ساعات النوم",
              bottomSpace: 2,
              keyboardType: TextInputType.number,

              controller: sleep,
              hint: "كم ساعة تنام في اليوم"),

              DropdownSetWidget(items: hrmon, onChange: (v){
                setState(() {
                  selectedHrmon = v;
                });
                
              },selectedValue: selectedHrmon,label: "هل ترغب بأستخدام هرمون",hint: "تحديد",),

    CustomTextFormField(validators: [IsRequiredRule()],
              label: "ملاحضات",
              bottomSpace: 2,
              maxLines: 3,
              controller: nots,
              hint: "هل لديك ملاحضات تحب ذكرها"),
              
              Container(
                alignment: Alignment.centerRight,
                child: Text("صور جسم اللاعب (مطلوبة)* 10 صور فقط",style: TextStyle(fontSize: 14.sp),),

              ),
              SizedBox(height: 20,),
             
    Container(
                              width: MediaQuery.of(context).size.width,
                              child: 
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: images.map((e){
                                      return  GestureDetector(
                                        onTap: () {
                                          deleteImage(e);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 90.w,
                                            height: 90.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: e["imageFile"] !=
                                                      ""
                                                  ? DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                          e["imageFile"]))
                                                  : null,
                                              border: Border.all(
                                                  color:
                                                      Theme.of(context).primaryColor),
                                            ),
                                            child: Icon(CupertinoIcons.delete,color: Colors.red,),
                                          
                                        ));
                                    }).toList(),
                                    alignment: WrapAlignment.start,
                                  ),
                            ),

                             Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         GestureDetector(
                                    onTap: (){
                                          pickImage(1);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: images.length > 0 ? 20 : 0),
                                          child: Icon(CupertinoIcons.add),
                                           alignment: Alignment.center,
                                                  width: 90.w,
                                                  height: 90.w,
                                                   decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                   
                                                    border: Border.all(
                                                        color:
                                                            Theme.of(context).primaryColor),
                                 ),
                                    ),
                                  ),
                                       ],
                                     ) ,

SizedBox(height: 20,),
                              Container(
                alignment: Alignment.centerRight,
                child: Text("صور التحاليل (ان وجدت)",style: TextStyle(fontSize: 14.sp),),

              ),
              SizedBox(height: 20,),
             
    Container(
                              width: MediaQuery.of(context).size.width,
                              child: 
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: tests.map((e){
                                      return  GestureDetector(
                                        onTap: () {
                                          deleteTest(e);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 90.w,
                                            height: 90.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: e["imageFile"] !=
                                                      ""
                                                  ? DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                          e["imageFile"]))
                                                  : null,
                                              border: Border.all(
                                                  color:
                                                      Theme.of(context).primaryColor),
                                            ),
                                            child: Icon(CupertinoIcons.delete,color: Colors.red,),
                                          
                                        ));
                                    }).toList(),
                                    alignment: WrapAlignment.start,
                                  ),
                            ),

                             Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         GestureDetector(
                                    onTap: (){
                                          pickImage(2);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: tests.length > 0 ? 20 : 0),
                                          child: Icon(CupertinoIcons.add),
                                           alignment: Alignment.center,
                                                  width: 90.w,
                                                  height: 90.w,
                                                   decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                   
                                                    border: Border.all(
                                                        color:
                                                            Theme.of(context).primaryColor),
                                 ),
                                    ),
                                  ),
                                       ],
                                     ) ,

                            Obx(()=> CustomButton(
                              topSpace: 3,
                              loading: controller.loadbtn.value,
                              onPressed: (){
                                if(_formKey.currentState!.validate() && selectedHrmon != null && images.length > 0){
                                       if(images.length > 10){
          Get.snackbar("خطأ", "لا يمكن اختيار اكثر من 10 صور",snackPosition: SnackPosition.BOTTOM);
        }else{
     AddGoldMode data = AddGoldMode(
                                    gymAddress: gymAddress.text,
                                    goal: goal.text, unWantedFood: unWantedFood.text, injurse: injurse.text, age: age.text, hight: hight.text, weight: weight.text, work: work.text, sleep: sleep.text, useHrmon: selectedHrmon, notes: nots.text,gymName: gymName.text);
                                  controller.addGoldInfo(goldMode: data, images: images, testes: tests, docid: widget.docid);
        }
                             
                                }else {
                                  Get.snackbar("نقص في المعلومات", "يرجى ملئ جميع المعلومات",margin: EdgeInsets.all(20),snackPosition: SnackPosition.TOP);
                                }

                                
                            },backgroundColor: Theme.of(context).primaryColor,text: "ارسال المعلومات",),),
              SizedBox(height: 50,)
            ],
          ),
        ),
      )),
    );
  }
}