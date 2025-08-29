import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:smaergym/core/controllers/exercise_controller.dart';
import 'package:smaergym/core/models/exrcies_model.dart';
import 'package:smaergym/core/validator/validators.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/custom_text_form_field.dart';

class EditExercise extends StatefulWidget {
  const EditExercise({super.key, required this.exerciseModel});
  final ExerciseModel exerciseModel;

  @override
  State<EditExercise> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // New state
  File? _newImageFile;                   // when user picks a new image
  late final String? _initialImageUrl;   // existing URL from Firestore

  final name = TextEditingController();
  final description = TextEditingController();
  final youtubeLink = TextEditingController();
    final youtubeLink2 = TextEditingController();

  final ExerciseController exerciseController = Get.find();

  @override
  void initState() {
    super.initState();
    name.text = widget.exerciseModel.name ?? "";
    youtubeLink.text = widget.exerciseModel.youtubeLink ?? "";
        youtubeLink2.text = widget.exerciseModel.youtubeLink2 ?? "";

    description.text = widget.exerciseModel.description ?? "";
    _initialImageUrl = widget.exerciseModel.image; // keep the URL if present
  }

  Future<File?> _compressToTemp(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        p.join(dir.path, "ex_${DateTime.now().microsecondsSinceEpoch}.jpg");
    return FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      minWidth: 1024,
      minHeight: 1000,
    );
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final compressed = await _compressToTemp(File(picked.path));
    if (compressed != null) {
      setState(() {
        _newImageFile = compressed; // show immediately
      });
    }
  }

  Widget _imageBox(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120.sp,
        height: 120.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _newImageFile != null
              ? Image.file(_newImageFile!, fit: BoxFit.cover)
              : (_initialImageUrl != null && _initialImageUrl!.isNotEmpty)
                  ? Image.network(_initialImageUrl!, fit: BoxFit.cover)
                  : Icon(CupertinoIcons.photo, size: 50, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: const Text("تعديل تمرين"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _imageBox(context),
                const SizedBox(height: 10),
                Text("صورة التمرين (اضغط لتغييرها)", style: TextStyle(fontSize: 16.sp)),

                CustomTextFormField(
                  controller: name,
                  validators: [IsRequiredRule()],
                  label: "الاسم",
                  hint: "اكتب اسم التمرين",
                ),
                CustomTextFormField(
                  controller: youtubeLink,
                  validators: [IsRequiredRule()],
                  label: "الرابط",
                  hint: "اكتب رابط اليوتيوب",
                ),
                                CustomTextFormField(
                  controller: youtubeLink2,
                  validators: [IsRequiredRule()],
                  label: "الرابط الثاني",
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
                          exerciseController.editExercise(
                            docid: widget.exerciseModel.docid ?? "",
                            name: name.text,
                            youtubeLink: youtubeLink.text,
                            youtubeLink2 : youtubeLink2.text ,
                            description: description.text,
                            categoryId: widget.exerciseModel.categeoryId,
                            newImageFile: _newImageFile, // << pass picked file (or null)
                          );
                        }
                      },
                      text: "تعديل التمرين",
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
