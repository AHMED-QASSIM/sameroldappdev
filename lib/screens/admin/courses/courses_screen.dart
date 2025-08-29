import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smaergym/core/models/sections_model.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/no_data_widget.dart';
import 'package:smaergym/screens/admin/courses/add_course_screen.dart';
import 'package:smaergym/screens/admin/courses/view_course_screen.dart';
import '../../../core/controllers/course_controller.dart';
import '../../../core/controllers/sections_controller.dart';
import '../../../core/models/add_course_model.dart';
import '../../../core/widgets/loading_widget_user.dart';
import 'package:intl/date_symbol_data_local.dart';

class CoursesScreenAdmin extends StatefulWidget {
  const CoursesScreenAdmin({super.key});

  @override
  State<CoursesScreenAdmin> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreenAdmin> {
  SectionsController sectionsController = Get.find();
  CourseController courseController = Get.put(CourseController());

  @override
  void initState() {
    // TODO: implement initState
    
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Container(
        width: 170.w,
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: CustomButton(onPressed: (){
          Get.to(AddCourseScreen())!.then((value){
            courseController.addCourseModel.value = AddCourseModel(
  title: "",
  date: DateTime.now(),
  section: "",
  days: [
  ],

);
          });
        },text: "اضافة كورس",backgroundColor: Theme.of(context).primaryColor,),
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("الكورسات"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(()=> Container(
              height: 80.sp,
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.horizontal,
                itemCount: sectionsController.sections.length,
                itemBuilder: (context,pos){
                  SectionModel sex = sectionsController.sections[pos];
                return GestureDetector(
                  onTap: (){
                     setState(() {
                       sectionsController.sections.where((p0) => p0.selected == true).first.selected = false;
                    sectionsController.sections[pos].selected = true;
                     });
                     courseController.getCourses(sex.docid);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: sex.selected! ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).primaryColor)
                    ),
                    height: 50.sp,
                    child: Text(sex.title!,style: TextStyle(color:sex.selected! ? Colors.white : Theme.of(context).primaryColor,fontSize: 13.sp),),
                  ),
                );
              }),
            )),
            

            Obx(()=> courseController.loadCourses.value ? ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context,pos){
          return LoadingWidgetProfile();
        },itemCount:  5,padding: EdgeInsets.all(20),) : !courseController.loadCourses.value && courseController.courses.length == 0 ? NoData(title: "لا يوجد كورسات",) :
            ListView.builder(
              padding: EdgeInsets.only(left: 20,right: 20,bottom: 40),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: courseController.courses.length,
              itemBuilder: (context,pos){
                var data = courseController.courses[pos].data();
              return Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(data["title"],style: TextStyle(color: Colors.black,fontSize: 14.sp,height: 1.5),),
                      Text(data["days"].length.toString() + " " + "ايام")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(DateFormat('MEd',Get.locale!.languageCode).format(data["date"].toDate())),
                      SizedBox(height: 5,),
                      GestureDetector(
                        onTap: (){
                          Get.to(ViewCourseScreen(courseDetails: data,id: courseController.courses[pos].id));
                        },
                        child: Icon(CupertinoIcons.eye,color: Theme.of(context).primaryColor,))
                    ],
                  ),

                 
                ],),
              );
            })
            )
          ],
        ),
      ),
    );
  }
}