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
import 'package:smaergym/core/models/add_silver_model.dart';
import 'package:smaergym/core/validator/validators.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/custom_text_form_field.dart';
import 'package:smaergym/core/widgets/dropdown_widget.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../core/widgets/DropdownSets.dart';

class SilverScreen extends StatefulWidget {
  const SilverScreen({super.key,required this.docid});
  final String docid;

  @override
  State<SilverScreen> createState() => _SilverScreenState();
}

class _SilverScreenState extends State<SilverScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var hrmon = [
    "نعم",
    "كلا",
    "اترك الخيار للمدرب"
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
           if(uploadimage.length > 4 && images.length <= 3){
          Get.snackbar("خطأ", "لا يمكن اختيار اكثر من 4 صور",snackPosition: SnackPosition.BOTTOM);
        }
        if (uploadimage != null && uploadimage.length <= 4 && images.length <= 3) {
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
    print(images);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("ملئ معلومات الاشتراك الفضي"),
      ),
      body: SingleChildScrollView(child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
               CustomTextFormField(validators: [IsRequiredRule()],
              label: "اسم القاعة والعنوان",
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
              label: "اصابات او تمارين لا يمكن عملها",
              controller: injurse,
              hint: "اذا كان لديك اصابات او تمارين غير مرغوبة",),


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
              label: "ملاحضات",
              bottomSpace: 2,
              maxLines: 3,
              controller: nots,
              hint: "هل لديك ملاحضات تحب ذكرها"),
              
              Container(
                alignment: Alignment.centerRight,
                child: Text("صور جسم اللاعب (مطلوبة)* 4 صور فقط",style: TextStyle(fontSize: 14.sp),),

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
    


                            Obx(()=> CustomButton(
                              topSpace: 3,
                              loading: controller.loadbtn.value,
                              onPressed: (){
                                if(_formKey.currentState!.validate() && images.length > 0){

              if(images.length > 4){
          Get.snackbar("خطأ", "لا يمكن اختيار اكثر من 4 صور",snackPosition: SnackPosition.BOTTOM);
        }else{
  AddSilverModel data = AddSilverModel(
                                    gymAddress: gymAddress.text,
                                    goal: goal.text, injurse: injurse.text, hight: hight.text, weight: weight.text, notes: nots.text,gymName: gymName.text);
                                  controller.addSilverInfo(silverModel: data, images: images, docid: widget.docid);
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