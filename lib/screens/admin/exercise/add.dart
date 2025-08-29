import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smaergym/core/controllers/exercise_controller.dart';
import 'package:smaergym/core/validator/validators.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/custom_text_form_field.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
class AddExercise extends StatefulWidget {
  const AddExercise({super.key, required this.id});
  final int id;

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File imageFile = File("");
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController youtubeLink1 = TextEditingController();
  TextEditingController youtubeLink2 = TextEditingController(); // new field
  ExerciseController exerciseController = Get.find();

  var baseImage;
  var imageTypes;

  pickImage() async {
    var uploadimage = await _picker.pickImage(source: ImageSource.gallery);

    if (uploadimage != null) {
      final dir = await path_provider.getTemporaryDirectory();
      final timeStamp = DateTime.now().millisecond;
      final targetPath = dir.absolute.path + "/temp$timeStamp.jpg";

      testCompressAndGetFile(File(uploadimage.path), targetPath).then((value) {
        setState(() {
          imageFile = value!;
          Uint8List bytes = value.readAsBytesSync();
          String base64Image = base64Encode(bytes);
          baseImage = base64Image;
          var imageType = p.extension(value.path).replaceAll('.', '');
          imageTypes = imageType;
        });
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
        title: Text("اضافة تمرين"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Container(
                    width: 120.sp,
                    height: 120.sp,
                    child: Icon(CupertinoIcons.photo),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      image: imageFile.path != ""
                          ? DecorationImage(
                              fit: BoxFit.cover, image: FileImage(imageFile))
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("صورة التمرين", style: TextStyle(fontSize: 16.sp)),
                CustomTextFormField(
                  controller: name,
                  validators: [IsRequiredRule()],
                  label: "الاسم",
                  hint: "اكتب اسم التمرين",
                ),
                CustomTextFormField(
                  controller: youtubeLink1,
                  validators: [IsRequiredRule()],
                  label: "رابط اليوتيوب 1",
                  hint: "اكتب رابط اليوتيوب الأول",
                ),
                CustomTextFormField(
                  validators: [IsRequiredRule()],
                  controller: youtubeLink2,
                  label: "رابط اليوتيوب 2",
                  hint: "اكتب رابط اليوتيوب الثاني",
                ),
                CustomTextFormField(
                  controller: description,
                  validators: [IsRequiredRule()],
                  label: "الوصف",
                  hint: "اكتب وصف التمرين",
                  maxLines: 3,
                ),
                Obx(() => CustomButton(
                      loading: exerciseController.loadadd.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          exerciseController.addExercise(
                            name: name.text,
                            youtubeLink: youtubeLink1.text,
                            youtubeLink2: youtubeLink2.text, // pass new field
                            description: description.text,
                            categoryId: widget.id,
                            imageFile: imageFile,
                            imageType: imageTypes,
                          );
                        }
                      },
                      text: "اضافة التمرين",
                      backgroundColor: Theme.of(context).primaryColor,
                      topSpace: 3,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
