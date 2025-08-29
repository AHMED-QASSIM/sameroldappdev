import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smaergym/core/widgets/no_data_widget.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smaergym/screens/courses/view_course.dart';

import '../../core/controllers/user_courses_controller.dart';
import '../../core/widgets/loading_widget_user.dart';


class PreviosScreen extends StatefulWidget {
  const PreviosScreen({super.key});

  @override
  State<PreviosScreen> createState() => _PreviosScreenState();
}

class _PreviosScreenState extends State<PreviosScreen> {


      RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    coursesController.getPreviosCourses().then((value) {
      _refreshController.refreshCompleted();
    });
  }


  UserCoursesController coursesController = Get.find();
  getSubName(name){
    switch (name){
      case "gold" : return "ذهبي";
      case "bronze" : return "برونزي";
      case "silver" : return "فضي";

    }
  }
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
         controller: _refreshController,
          onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Obx(()=> coursesController.loadPrevois.value ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context,pos){
            return LoadingWidgetProfile();
          },itemCount:  5,padding: EdgeInsets.all(20),) : coursesController.loadPrevois.value == false && coursesController.previosCourses.length == 0 ? Container(
            height: MediaQuery.of(context).size.height - 200,
            alignment: Alignment.center,
            child: NoData()) : 
          ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,pos){
            var item = coursesController.previosCourses[pos];
            return  GestureDetector(
              onTap: (){ 
                print(coursesController.previosCourses[pos]);
                 Get.to(ViewCourse(course: coursesController.previosCourses[pos]));
              },
              child: Container(
                 margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        offset: Offset(0,6),
                        blurRadius: 6
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 15.0,
                          percent: 1,
                          center:  Text("0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp,color: Colors.black),),
                          progressColor: Color(0xFFDAA520),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["gymName"] ?? "",style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black),),
                              SizedBox(height: 15,),
                              Text(getSubName(item["subscription"]),style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey,fontWeight: FontWeight.bold),),
                
                            ],
                          ),
                        ),
                
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          height: 75.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Text(intl.DateFormat('MEd',Get.locale!.languageCode).format(item["date"].toDate()),style: TextStyle(color: Colors.black),),
                
                            Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            width: 60.sp,
                            alignment: Alignment.center,
                            height: 30.sp,
                            child: Text("منتهي",style: TextStyle(color: Colors.white),),
                          ),
                            ],
                          ),
                        ),
                
                
                        
                        ],
                      ),
                
                   
                
                    ],
                  ),
                ),
            );
          },itemCount: coursesController.previosCourses.length > 0 ? 1 : 0,)),
      ),
    );
  }
}