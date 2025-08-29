import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:smaergym/core/widgets/custom_button.dart';

import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/dropdown_widget.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/validator/validators/is_required_rule.dart';
import '../../core/validator/validators/max_length_rule.dart';
import '../../core/validator/validators/min_length_rule.dart';
import '../../core/validator/validators/regex_rule.dart';

class RegisterScreen extends StatefulWidget {
  final String? phoneNumber;
  RegisterScreen({ this.phoneNumber});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterScreen> {
  TextEditingController phone = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController controller = Get.find();
final countryPicker = const FlCountryCodePicker();
  final ImagePicker _picker = ImagePicker();
  dynamic? selectedGov = null;

   File imageFile = File("");
 String imageType = "";
 var selectedCode = "+964";
  pickImage() async {
    var uploadimage = await _picker.pickImage(source: ImageSource.gallery);

    if (uploadimage != null) {
      final dir = await path_provider.getTemporaryDirectory();
      final timeStamp = DateTime.now().millisecond;
      final targetPath = dir.absolute.path + "/temp$timeStamp.jpg";

      testCompressAndGetFile(File(uploadimage.path), targetPath).then((value) {
        setState(() {
          imageFile = value!;
        });
        Uint8List bytes = value!.readAsBytesSync();
        String base64Image = base64Encode(bytes);
        var imageType = p.extension(value.path);
        imageType = imageType.replaceAll('.', '');
        imageType = imageType;
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

  @override
  void initState() {
    // TODO: implement initState
    
    if(widget.phoneNumber != null){
      phone.text = widget.phoneNumber.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(CupertinoIcons.arrow_right)),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "مرحبا بك!",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    height: 2,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "انشاء حساب جديد",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      pickImage();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      alignment: Alignment.center,
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image:imageFile.path != ""
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                    imageFile))
                                            : null,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      child: Icon(CupertinoIcons.camera),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "الصورة الشخصية",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                              
                                  CustomTextFormField(
                                    controller: fullname,
                                    validators: [
                                      IsRequiredRule(),
                                    ],
                                    hint: "ادخل الاسم الثلاثي",
                                    label: "الاسم الثلاثي",
                                  ),
                                  CustomTextFormField(
                                    bottomSpace: 0,
                                    controller: phone,
                                   
                                    validators: [
                                      IsRequiredRule(),
                                    ],
                                    hint: "ادخل رقم الهاتف",
                                    suffixIcon: GestureDetector(
    onTap: () async {
        final code = await countryPicker.showPicker(context: context,initialSelectedLocale: "IQ");
        if (code != null){
          setState(() {
            selectedCode = code.dialCode;
          });
        };
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      
      child: Text(selectedCode,
          style: const TextStyle(color: Colors.black),textAlign: TextAlign.right),
    ),
  ),
                                    label: "رقم الهاتف",
                                    keyboardType: TextInputType.number,
                                  ),


  CustomTextFormField(
                                    controller: email,
                                    validators: [
                                      IsRequiredRule(),
                                      MinLengthRule(2),
                                      // username regex

                                      RegexRule(r"^[a-zA-Z0-9]+([_ -]?[a-zA-Z0-9])*$")
                                    ],
                                    hint: "ادخل اسم المستخدم مثلا samer",
                                    label: "اسم المستخدم",
                                    prefixIcon: Icon(CupertinoIcons.at,size: 16,color: Colors.grey,),
                                  ),

                                    CustomTextFormField(
                                    controller: password,
                                    validators: [
                                      IsRequiredRule(),
                                      MinLengthRule(6),
                                    ],
                                    hint: "ادخل كلمة المرور",
                                    label: "كلمة المرور",
                                     obscureText: true,
                                    prefixIcon: Icon(CupertinoIcons.lock,size: 16,color: Colors.grey,),
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),
                                
                                ],
                              ),
                            )
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        child: Obx(()=> CustomButton(
                          loading: controller.loadregister.value,
                          onPressed: (){
                          if(imageFile.path == ""){
                            Get.snackbar("الصورة مطلوبة", "يرجى رفع صورتك الشخصية",margin: EdgeInsets.all(20),snackPosition: SnackPosition.BOTTOM);
                          }
                          if (_formKey.currentState!.validate() && imageFile.path != "") {
                            controller.register(
                                phone: phone.text,
                                imageFile: imageFile,
                                imageType: imageType,
                                name: fullname.text,
                                code: selectedCode,
                                email: email.text,
                                password: password.text
                                );
                          }
                        },text: "انشاء حساب",
                        backgroundColor: Theme.of(context).primaryColor,))),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {label,
      hint,
      obscureText = false,
      required TextEditingController controller,
      IconData? iconData,
      TextInputType textInputType = TextInputType.name,
      int maxNumber = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Theme.of(context).cardColor),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          keyboardType: textInputType,
          obscureText: obscureText,
        
          decoration: InputDecoration(
            filled: true,
            suffixIcon: controller.text.length >= maxNumber
                ? Icon(
                    CupertinoIcons.check_mark_circled,
                    color: Colors.green,
                  )
                : Icon(iconData),
            labelStyle: TextStyle(color: Colors.black),
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
