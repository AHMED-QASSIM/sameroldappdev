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
import 'package:smaergym/core/models/add_bronze_model.dart';
import 'package:smaergym/core/models/add_gold_model.dart';
import 'package:smaergym/core/validator/validators.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/custom_text_form_field.dart';
import 'package:smaergym/core/widgets/dropdown_widget.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../core/widgets/DropdownSets.dart';

class BronzeScreen extends StatefulWidget {
  const BronzeScreen({super.key,required this.docid});
  final String docid;

  @override
  State<BronzeScreen> createState() => _SilverScreenState();
}

class _SilverScreenState extends State<BronzeScreen> {

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
        uploadimage.forEach((element) async {
        final timeStamp = DateTime.now().millisecond;
        // generato random 12 number
          

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


  TextEditingController weight = TextEditingController();
  TextEditingController gymName = TextEditingController();
  TextEditingController gymAddress = TextEditingController();
  TextEditingController since = TextEditingController();
  TextEditingController hight = TextEditingController();

  UserCoursesController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("ملئ معلومات الاشتراك البرونزي"),
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
              label: "الوزن",
              keyboardType: TextInputType.number,
              controller: weight,
              hint: "اكتب وزنك"),

                  CustomTextFormField(validators: [IsRequiredRule()],
              label: "الطول",
              keyboardType: TextInputType.number,
              controller: hight,
              hint: "اكتب طولك"),

                CustomTextFormField(validators: [IsRequiredRule()],
              label: "منذ متى تمارس كمال الاجسام",
              controller: since,
              bottomSpace: 2,
              hint: "اكتب اجابتك"),
                   
              
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
               AddBronzeModel data = AddBronzeModel( 
                                     hight: hight.text,
                                     weight:weight.text,gymName: gymName.text,since: since.text,gymAddress: gymAddress.text);
                                  controller.addBronzeInfo(addBronzeModel: data, images: images,  docid: widget.docid);
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