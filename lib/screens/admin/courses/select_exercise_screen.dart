import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/course_controller.dart';
import 'package:smaergym/core/models/add_course_model.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/dropdown_widget.dart';
import '../../../core/controllers/exercise_controller.dart';
import '../../../core/models/exrcies_model.dart';
import '../../../core/widgets/DropdownSets.dart';
import '../../../core/widgets/dropdown_tamreen.dart';
import '../../../core/widgets/loader_image_widget.dart';
import '../../../core/widgets/loading_widget_user.dart';
import '../../../core/widgets/no_data_widget.dart';
import '../exercise/edit.dart';
class SelectExerciseScreen extends StatefulWidget {
  final String title;
  final int id;
  final int day;
  const SelectExerciseScreen({super.key,required this.day,required this.id,required this.title});
  @override
  State<SelectExerciseScreen> createState() => _SelectExerciseScreenState();
}
class _SelectExerciseScreenState extends State<SelectExerciseScreen> {
    ExerciseController excersiesController = Get.find();
    CourseController controller = Get.find();
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
 
  @override
  void initState() {
    // TODO: implement initState
    excersiesController.getExercises(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("اختر من تمارين ${widget.title}"),
      ),
      body: Obx(()=> excersiesController.load.value ? Center(
        child: ListView.builder(itemBuilder: (context,pos){
          return LoadingWidgetProfile();
        },itemCount:  5,padding: EdgeInsets.all(20),),
      ): !excersiesController.load.value && excersiesController.exercises.length == 0 ?  Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height - 150.sp,
        child: NoData(title: "لا يوجد تمارين",),): SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text("عدد التمارين  : ${excersiesController.exercises.length}",style: TextStyle(fontSize: 14.sp),)),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                shrinkWrap: true,
                itemCount: excersiesController.exercises.length,
                itemBuilder: (context,pos){
                  ExerciseModel exe = excersiesController.exercises[pos];
                return GestureDetector(
                  onTap: (){
                    if(controller.checkTmreenExists(exe.docid, widget.day) == 0){
                      controller.selectedExe.value = exe;
                      setState(() {
                        
                      });
                    Get.bottomSheet(StatefulBuilder(builder: (context,setState){
                      return Container(
                    
                      padding: EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                      ),
                       child: SingleChildScrollView(
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Text("اختر عدد السيتات",style: TextStyle(fontSize: 16.sp),),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Obx(()=>  Wrap(
                                alignment: WrapAlignment.start,
                                children: controller.sets.map((e){
                                  return Obx(()=> GestureDetector(
                                    onTap: (){
                                     setState(() {
                                        controller.selected.value = e.name;
                                     });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      decoration: BoxDecoration(
                                        color: controller.selected == e.name ? Theme.of(context).primaryColor : Colors.white,
                                        border: Border.all(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(e.name!,style: TextStyle(color: controller.selected == e.name ? Colors.white : Theme.of(context).primaryColor,fontSize: 12.sp),),
                                    ),
                                  ));
                                }).toList(),)),
                            ),
        
                            Obx(()=> Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(value: controller.isSuper.value, onChanged: (v){
                                  setState(() {
                                    controller.isSuper.value = v!;
                                    if(v){
                                       controller.secondExe.add(Super(
                                      name: "",
                                      id: "",
                                      sets: ""
                                    ));
                                    }else {
                                      controller.secondExe.clear();
                                    }
                                  });
                                }),
                                Text("سوبر",style: TextStyle(fontSize: 16.sp),),
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                      controller.secondExe.add(Super(
                                      name: "",
                                      id: "",
                                      sets: ""
                                    ));
                                  },
                                  child: Icon(Icons.add_circle,color: Theme.of(context).primaryColor,size: 25.sp,)),
        
                                   GestureDetector(
                                  onTap: (){
                                      controller.secondExe.removeLast();
                                      
                                  },
                                  child: Icon(Icons.remove_circle_outline,color: Colors.red,size: 25.sp,)),
                              ],
                            ),),
        
                            Obx(() => ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context,pos){
                              return Column(children: [
                               controller.isSuper.value ? Container(
                              margin: EdgeInsets.only(bottom: 20,top: 10),
                              child: DropdownTamreenWidget(
                                label: "التمرين ${convNumToText(pos+1)}",
                                hint: "اختر التمرين",
                                items: excersiesController.exercises.value,
                                selectedValue: excersiesController.exercises.firstWhereOrNull((element) => element.docid == controller.secondExe[pos].id),
                                onChange: (v){
                                  controller.secondExe.value[pos].name = v.name;
                                  controller.secondExe.value[pos].id = v.docid;
                                  setState(() {});
                                },
                              ),
                            ) : Container(),
        
                            Obx(()=> controller.isSuper.value ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: Obx(()=> Wrap(
                                alignment: WrapAlignment.start,
                                children:controller.sets.map((e){
                                  return GestureDetector(
                                    onTap: (){
                                     setState(() {
                                        controller.secondExe[pos].sets = e.name;
                                     });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                      decoration: BoxDecoration(
                                        color: controller.secondExe[pos].sets == e.name ? Theme.of(context).primaryColor : Colors.white,
                                        border: Border.all(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(e.name!,style: TextStyle(color:controller.secondExe[pos].sets == e.name ? Colors.white : Theme.of(context).primaryColor,fontSize: 12.sp),),
                                    ),
                                  );
                                }).toList(),)),
                            ) : Container()),
                                ],);
                            },itemCount: controller.secondExe.length,shrinkWrap: true,)),
                            
                            SizedBox(height: 10,),
                            CustomButton(onPressed: (){
                              if(controller.selected.value != null){
                                controller.addTamreenToCourse(widget.day);
                              setState(() {
                                
                              });
                              }
                            },text: "تحديد",backgroundColor: Theme.of(context).primaryColor,),
                            SizedBox(height: 15,),
                          ],
                         ),
                       ),
                    );
                    }),isScrollControlled: true).then((value) => setState(() {}));
                    }
                    
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(exe.name!,style: TextStyle(fontSize: 14.sp,color: Colors.black)),),
                        Text(
                           controller.checkTmreenExists(exe.docid, widget.day) > 0 ? "تم تحديد" : "تحديد",style: TextStyle(color: controller.checkTmreenExists(exe.docid, widget.day) > 0 ? Colors.green : Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                           if(controller.checkTmreenExists(exe.docid, widget.day) > 0)
                           SizedBox(width: 15,),
                           if(controller.checkTmreenExists(exe.docid, widget.day) > 0)
                           GestureDetector(
                            onTap: (){
                              setState(() {
                                var list = controller.addCourseModel.value.days![widget.day].exercises;
        var check = list!.where((element) => element.id == exe.docid).toList();
                                controller.addCourseModel.value.days![widget.day].exercises!.remove(check.first);
                              });
                            },
                            child: Icon(CupertinoIcons.delete,color: Colors.red,),
                           )
                      ],
                    )
                  ),
                );
              },),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: CustomButton(onPressed: (){
                  Get.back();
                },text: "انتهاء",backgroundColor: Theme.of(context).primaryColor),
              ),
            ],
          ),
        )),
    );
  }
}