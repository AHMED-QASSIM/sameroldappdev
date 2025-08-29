import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart' as intl;
import 'package:smaergym/core/controllers/user_courses_controller.dart';
import 'package:smaergym/screens/courses/view_exercies.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/loader_image_widget.dart';

class ViewCourse extends StatefulWidget {
  final dynamic course;
  const ViewCourse({super.key,required this.course});

  @override
  State<ViewCourse> createState() => _ViewCourseState();
}

class _ViewCourseState extends State<ViewCourse> with TickerProviderStateMixin{

    late TabController tabController;
    late TabController stabController;
    UserCoursesController userCoursesController = Get.find();

      var _selectedTabbar = 0;


  getSubName(name){
    switch (name){
      case "gold" : return "ذهبي";
      case "bronze" : return "برونزي";
      case "silver" : return "فضي";

    }
  }

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
  void initState() {
    // TODO: implement initState
       stabController = TabController(length: 3, vsync: this);
       userCoursesController.getCourseExe(widget.course["courseId"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("معاينة الكورس"),
      ),
      body: SingleChildScrollView(
            
            child: Column(
              children : [
              Container(
               margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
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

                        
                        widget.course["date"].toDate().difference(DateTime.now()).inDays <= 30 ? CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 15.0,
                        percent: 0.03333 * (DateTime.now().difference(widget.course["date"].toDate()).inDays) <1 ? 0.03333 * (DateTime.now().difference(widget.course["date"].toDate()).inDays) : 1,
                        center:  Text((30 - DateTime.now().difference(widget.course["date"].toDate()).inDays) < 1 && (30 - DateTime.now().difference(widget.course["date"].toDate()).inDays)  > 0 ? (30 - DateTime.now().difference(widget.course["date"].toDate()).inDays).toString() : "0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp,color: Colors.white),),
                        progressColor: Color(0xFFDAA520),
                        backgroundColor: Colors.white,
                      ) : Container(),
                      SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.course["gymName"],style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),),
                            // Text(coursesController.courseExercises.value["days"].length.toString() + " ايام",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
                            SizedBox(height: 15,),
                            Text(getSubName(widget.course["subscription"]),style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey.shade200,fontWeight: FontWeight.bold),),
              
                          ],
                        ),
                      ),
              
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 75.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            Text(intl.DateFormat('MEd',Get.locale!.languageCode).format(widget.course["date"].toDate()),style: TextStyle(color: Colors.white),),
              
                          Container(
                          decoration: BoxDecoration(
                            color:widget.course["status"] == 4 ? Colors.black : Colors.green,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          width: 60.sp,
                          alignment: Alignment.center,
                          height: 30.sp,
                          child: Text(widget.course["status"] == 4 ? 'منتهي' : widget.course["status"] == 2 ? "بأنتضار الكورس" : "فعال",style: TextStyle(color: Colors.white),),
                        ),
                          ],
                        ),
                      ),
              
              
                      
                      ],
                    ),
              
                 
              
                  ],
                ),
              ),

    
              Padding(
                padding: EdgeInsets.symmetric(horizontal:0,vertical: 20),
                child: TabBar(
                  onTap: (index) {
                          print(index);                                  
                          setState(() {
                                _selectedTabbar = index;
                          });
                        },
                  controller: stabController,
                  tabs: [
                  Tab(text: "التمارين", ),
                  Tab(text: "نظام غذائي",),
                  Tab(text: "المكملات",),
              
                ]),
              ),
           SizedBox(height: 10,),
           
                 if(widget.course["status"] > 2 && _selectedTabbar == 0)
                 Obx(()=> userCoursesController.loadCourseExe.value ? CircularProgressIndicator() : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,pos){
                                  var day = userCoursesController.viewCourseExe.value["days"][pos];

                  return Container(
                  width:MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(ViewExrciesUser(name: day["name"] ?? "",exercises: day["exercises"],));
                    },
                    child: Row(
                      children: [
                        LoadingImage(image: day['image'] ?? "",height: 100,width: 100,),
                        SizedBox(width: 15,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(day["name"] ?? "",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                             Container(
                              padding: EdgeInsets.symmetric(horizontal: 30,vertical:3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Get.theme.primaryColor.withOpacity(0.9),
                                
                              ),
                              child: Text(day["exercises"].length.toString() + " تمرين",style: TextStyle(color: Colors.white,fontSize: 10.sp,fontWeight: FontWeight.bold),),
                            )
                            
                          ],
                        ),),
                        Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 16.sp,)
                      ],
                    ),
                  )
                );
                },itemCount:  userCoursesController.viewCourseExe.value["days"].length,shrinkWrap: true,),),

          
          
                if(widget.course["food"] == null || widget.course["food"] == "" && _selectedTabbar == 1)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("لا يوجد نظام غذائي",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
                ),
                if(widget.course["food"] != null && widget.course["food"] != ""  && _selectedTabbar == 1)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("النظام الغذائي",style: TextStyle(fontSize: 16.sp),),
                      Container(
                        height: 2,
                        width: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 10,),
                      Text(widget.course["food"],style: TextStyle(fontSize: 14.sp),)
                    ],
                  ),
                ),
          
          if( _selectedTabbar == 2)
                              if(widget.course["protien"] == "" && widget.course["protien"] != null)
                               Padding(
                                 padding: const EdgeInsets.all(20.0),
                                 child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text("لا توجد مكملات",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold))
                                    ],
                                   ),
                                   SizedBox(height: 20,),

                                   Text("لطلب المكملات عن طريق الفيسبوك او الواتساب",style: TextStyle(fontSize: 16.sp),),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            launch("https://www.facebook.com/profile.php?id=100064559064577&mibextid=LQQJ4d");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: Icon(Icons.facebook,color: Colors.white,),
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        GestureDetector(
                                          onTap: (){
                                            launch("https://wa.me/07860455118");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: Icon(Icons.phone,color: Colors.white,),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                 ),
                               ),

              if(widget.course["protien"] != null && _selectedTabbar == 2)
              if(widget.course["protien"] != "" && _selectedTabbar == 2)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("المكملات",style: TextStyle(fontSize: 16.sp),),
                      Container(
                        height: 2,
                        width: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                                          SizedBox(height: 10,),
                      Text(widget.course["protien"],style: TextStyle(fontSize: 14.sp),),

                      SizedBox(height: 20,),

                                   Text("لطلب المكملات عن طريق الفيسبوك او الواتساب",style: TextStyle(fontSize: 16.sp),),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            launch("https://www.facebook.com/profile.php?id=100064559064577&mibextid=LQQJ4d");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: Icon(Icons.facebook,color: Colors.white,),
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        GestureDetector(
                                          onTap: (){
                                            launch("https://wa.me/07860455118");
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: Icon(Icons.phone,color: Colors.white,),
                                          ),
                                        ),
                                      ],
                                    )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
          
       
            ],
                  ),
      )
    );
  }
}
