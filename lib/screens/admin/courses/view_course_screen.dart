import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/course_controller.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';

import '../../../core/models/add_course_model.dart';

class ViewCourseScreen extends StatefulWidget {
  const ViewCourseScreen({super.key,required this.courseDetails,required this.id});
  final dynamic courseDetails;
  final String id;

  @override
  State<ViewCourseScreen> createState() => _ViewCourseScreenState();
}

class _ViewCourseScreenState extends State<ViewCourseScreen> {

    CourseController controller = Get.find();

    convNumToText(int number){
    switch(number){
      case 0 : return "الاول";
      case 1 : return "الثاني";
      case 2 : return "الثالث";
      case 3 : return "الرابع";
      case 4 : return "الخامس";
      case 5 : return "السادس";
      case 5 : return "السابع";
      case 5 : return "الثامن";
      case 5 : return "التاسع";


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.courseDetails["title"]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(20),
              itemBuilder: (context,pos){
                 List exercise = widget.courseDetails["days"][pos]["exercises"]!;
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
                                   
                                   Expanded(child: Text(widget.courseDetails["days"][pos]["name"] ?? "",style: TextStyle(fontSize: 16.sp,color: Theme.of(context).primaryColor),)),
                                   LoadingImage(image: widget.courseDetails["days"][pos]["image"] ?? "",height: 40,width: 40,),
                                
                                ],
                              ),
                              SizedBox(height: 5,),
                              Divider(),
                              SizedBox(height: 5,),
      
                              Column(
                                children: exercise.map((e){
                                  print(e);
                                  return e["exerciseSuper"].length > 0 ? Container(
                                    child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green,width: 1),
                                      borderRadius: BorderRadius.circular(10)
                                    ),                              child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        SizedBox(height: 10,),
                                         Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e["name"],style: TextStyle(fontSize: 12.sp),),
                                        Text(e["sets"],style: TextStyle(fontSize: 12.sp),),
      
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Divider(),
                                    ListView.builder(
                                      itemCount:  e["exerciseSuper"].length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context,pos){
                                      dynamic s = e["exerciseSuper"][pos];
                                      return  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(s["name"],style: TextStyle(fontSize: 12.sp),),
                                        Text(s["sets"],style: TextStyle(fontSize: 12.sp),),
      
                                      ],
                                    );
                                    })
      
                                      ],
                                    )
                                  ),
                                  ) : Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300,width: 0.5),
                                      borderRadius: BorderRadius.circular(10)
                                    ),                              child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(e["name"],style: TextStyle(fontSize: 12.sp),),),
                                        SizedBox(width: 5,),
                                        Text(e["sets"],style: TextStyle(fontSize: 12.sp),),
      
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        );
            },itemCount: widget.courseDetails["days"].length,),

            Obx(()=> Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                loading: controller.loadDelete.value,
                onPressed: (){
                controller.deleteCourse(widget.id,widget.courseDetails["section"]);
              },text: "حذف الكورس",backgroundColor: Color.fromARGB(255, 195, 66, 56),),
            ))
          ],
        ),
      ),
    );
  }
}