import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/exercise_controller.dart';
import 'package:smaergym/core/controllers/sections_controller.dart';
import 'package:smaergym/core/models/exrcies_model.dart';
import 'package:smaergym/core/models/sections_model.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';
import 'package:smaergym/core/widgets/loading_categori_widget.dart';
import 'package:smaergym/core/widgets/loading_widget_user.dart';
import 'package:smaergym/core/widgets/no_data_widget.dart';
import 'package:smaergym/screens/admin/exercise/add.dart';
import 'package:smaergym/screens/admin/exercise/edit.dart';

class ShowAllScreen extends StatefulWidget {
  final String title;
  final int id;
  const ShowAllScreen({super.key,required this.title,required this.id});

  @override
  State<ShowAllScreen> createState() => _ShowAllScreenState();
}

class _ShowAllScreenState extends State<ShowAllScreen> {

  SectionsController sectionsController = Get.find();
  ExerciseController excersiesController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    
    excersiesController.getExercises(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Container(
        width: 170.w,
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: CustomButton(onPressed: (){
          Get.to(AddExercise(id: widget.id,));
        },text: "اضافه تمرين",backgroundColor: Theme.of(context).primaryColor,),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("تمارين ال ${widget.title}"),
      ),
      body: Obx(()=> excersiesController.load.value ? Center(
        child: ListView.builder(itemBuilder: (context,pos){
          return LoadingWidgetProfile();
        },itemCount:  5,padding: EdgeInsets.all(20),),
      ): !excersiesController.load.value && excersiesController.exercises.length == 0 ?  Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height - 150.sp,
        child: NoData(title: "لا يوجد تمارين",),): ListView.builder(
          padding: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 80),
          shrinkWrap: true,
          itemCount: excersiesController.exercises.length,
          itemBuilder: (context,pos){
            ExerciseModel exe = excersiesController.exercises[pos];
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exe.name!,style: TextStyle(fontSize: 16.sp,color: Colors.black,fontWeight: FontWeight.bold),),
                    Text(exe.description!,style: TextStyle(fontSize: 12.sp,color: Colors.grey.shade600),)
                  ],
                ),),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  LoadingImage(image: exe.image!,width: 80.sp,height: 80.sp,radius: 10,),
           
                  ],
                )
                  ],
                ),
                SizedBox(height: 5,),
                Divider(),

                 Row(
                  children: [
                    GestureDetector(
                  onTap: (){
                    Get.to(EditExercise(exerciseModel: exe));
                  },
                   child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),child: Text("تعديل",style: TextStyle(color: Colors.white),),),
                 ),
                 SizedBox(width: 10,),
                 GestureDetector(
                  onTap: (){
                   excersiesController.deleteExersise(widget.id, exe.docid);
                  },
                   child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 204, 51, 51),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),child: Text("حذف",style: TextStyle(color: Colors.white),),),
                 )
                  ],
                 ),

              ],
            )
          );
        },)),
    );
    
  }
}