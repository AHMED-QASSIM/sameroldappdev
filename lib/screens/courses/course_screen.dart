import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:smaergym/core/controllers/user_courses_controller.dart';
import 'package:smaergym/core/widgets/custom_button.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';
import 'package:smaergym/core/widgets/no_data_widget.dart';
import 'package:smaergym/screens/courses/previos_courses_screen.dart';
import 'package:smaergym/screens/courses/view_course.dart';
import 'package:smaergym/screens/courses/view_exercies.dart';
import 'package:smaergym/screens/exercies/view_exrcies.dart';
import 'package:smaergym/screens/subscriptions/bronze_screen.dart';
import 'package:smaergym/screens/subscriptions/gold_screen.dart';
import 'package:smaergym/screens/subscriptions/silver_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/loading_widget_user.dart';
class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>  with TickerProviderStateMixin{

  UserCoursesController coursesController = Get.put(UserCoursesController());
  late TabController tabController;
  late TabController stabController;

RefreshController _refreshController =
      RefreshController(initialRefresh: false);
      var _selectedTabbar = 0;

  void _onRefresh() async{
    // monitor network fetch
    await coursesController.getCurrentCourse();
    _refreshController.refreshCompleted();
  }

  Future<void> _launchUrl(phone) async {
  if (!await launchUrl(Uri.parse(phone))) {
    throw 'Could not launch $phone';
  }
}


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
    
    tabController = TabController(length: 2, vsync: this);
      stabController = TabController(length: 4, vsync: this);
     tabController.addListener(() {
      setState(() {
        tabindex = tabController.index;
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }
  int maxDays = 30;


  double calcDays(){

  var res = 1 - (DateTime.now().difference(coursesController.currentCourse.value.data()["date"].toDate()).inDays / maxDays);

    if(res < 0){
      print(coursesController.currentCourse.value.id);
      FirebaseFirestore.instance.collection("players").doc(coursesController.currentCourse.value.id).update({
        "status" : 4
      });
      coursesController.currentCourse.value.data()["status"] = 4;
      return 0;
    
    }

    return res;
  }

  var tabindex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      
      child:  Obx(()=>Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            
        floatingActionButton: tabindex == 0 && coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] <= 2 ? Container(
          height: 200.sp,
                padding: EdgeInsets.all(15),
                
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(coursesController.currentCourse.value.data()["subscription"] == "gold" )
                        Text("كورس ذهبي",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold, color:Color(0xFFDAA520),height: 1),),
                                                if(coursesController.currentCourse.value.data()["subscription"] == "bronze" )
                        Text("كورس برونزي",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold, color:Color(0xFFCD7F32),height: 1),),
                                                                        if(coursesController.currentCourse.value.data()["subscription"] == "silver" )
                        Text("كورس فضي",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold, color:Color(0xFFA9A9A9),height: 1),),
                        SizedBox(width: 10,),
                        SvgPicture.asset("assets/svg/dunble.svg",width: 20.sp,color: Colors.white,)
                      ],
                    ),
                    SizedBox(height: 5,),

                    Divider(),
                    if(coursesController.currentCourse.value.data()["status"] == 1)
                    Text("لديك كورس جديد يرجى ادخال معلوماتك للكابتن لكتابة النظام التدريبي",style: TextStyle(color: Colors.white,fontSize: 13.sp),),
                           if(coursesController.currentCourse.value.data()["status"] == 2)
                    Text(" تم ارسال معلوماتك الى الكابتن سيقوم الكابتن بمراجعة معلوماتك التي ادخلتها ويقوم بكتابه النظام التدريبي الخاص بك بأسرع وقت ممكن سيتم اعلامك عند الاكتمال من كتابة الكورس",style: TextStyle(color: Colors.white,fontSize: 13.sp),),
                    if(coursesController.currentCourse.value.data()["status"] == 1)                  
                    CustomButton(onPressed: (){
                   
 if(coursesController.currentCourse.value.data()["subscription"] == "gold" ){
                          Get.to(GoldScreen(docid: coursesController.currentCourse.value.id,));
                        }
                      
 if(coursesController.currentCourse.value.data()["subscription"] == "silver" ){
                          Get.to(SilverScreen(docid: coursesController.currentCourse.value.id,));

 }

  if(coursesController.currentCourse.value.data()["subscription"] == "bronze" ){
                          Get.to(BronzeScreen(docid: coursesController.currentCourse.value.id,));

 }
                       
                    },topSpace: 2,text: "اضافة المعلومات",backgroundColor: Colors.white,fontColor: Colors.black,)
                  ],
                ),
              ) : Container(),
        appBar: AppBar(
         
          bottom:  TabBar(
            dividerColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorPadding: EdgeInsets.symmetric(vertical: 5),
              onTap: (v) {
                    setState(() {
                      tabindex = v;
                    });
                  },
                     controller: tabController,

            labelColor: Colors.white,
            tabs: [
              Tab(
                text: "الكورس الحالي",
                
              ),
              Tab(
                                text: "كورسات سابقة",

              ),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        
          toolbarHeight: 0,
        ),
        body: TabBarView(
          controller: tabController,
          children: [
          SmartRefresher(
            controller: _refreshController,
             enablePullDown: true,
             onRefresh: _onRefresh,
            child: SingleChildScrollView(
              
              child:  Obx(()=> coursesController.loading.value ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context,pos){
            return LoadingWidgetProfile();
                  },itemCount:  5,padding: EdgeInsets.all(20),) : Column(
            children: [
              SizedBox(height: 20,),
              if(coursesController.currentCourse.value == null)
              Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(onTap: (){
                     _launchUrl("https://www.facebook.com/1C.samerr?mibextid=LQQJ4d");
                    },child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("تواصل مع كابتن سامر على فيسبوك",style: TextStyle(fontSize: 14.sp,),),
                          SvgPicture.asset("assets/svg/face.svg",width: 20.sp)
                        ],
                      ),
                    ),)
                  ],
                ),
              ),
          
              if(coursesController.currentCourse.value != null &&  coursesController.currentCourse.value.data()["status"] <= 2)
              Container(
                child: Lottie.asset("assets/json/new.json"),
              ),
          
              if(coursesController.currentCourse.value != null &&coursesController.currentCourse.value.data()["status"] > 2)
              GestureDetector(
                onTap: (){
                  Get.to(ViewCourse(course: coursesController.currentCourse.value,));
                },
                child: Container(
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
              
                          
                          coursesController.currentCourse.value.data()["date"].toDate().difference(DateTime.now()).inDays <= 30 ? CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 15.0,
                          percent: calcDays(),
                          center:  Text((1 - (DateTime.now().difference(coursesController.currentCourse.value.data()["date"].toDate()).inDays - maxDays)).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp,color: Colors.white),),
                          progressColor: Color(0xFFDAA520),
                          backgroundColor: Colors.white,
                        ) : Container(),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(coursesController.currentCourse.value.data()["gymName"],style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),),
                              if(coursesController.courseExercises.value != null)
                              Text(coursesController.courseExercises.value["days"].length.toString() + " ايام",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
                              SizedBox(height: 15,),
                              Text(getSubName(coursesController.currentCourse.value.data()["subscription"]),style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey.shade200,fontWeight: FontWeight.bold),),
                
                            ],
                          ),
                        ),
                
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          height: 75.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Text(intl.DateFormat('MEd',Get.locale!.languageCode).format(coursesController.currentCourse.value.data()["date"].toDate()),style: TextStyle(color: Colors.white),),
                
                            Container(
                            decoration: BoxDecoration(
                              color: coursesController.currentCourse.value.data()["status"] == 4 ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            width: 60.sp,
                            alignment: Alignment.center,
                            height: 30.sp,
                            child: Text(coursesController.currentCourse.value.data()["status"] == 4 ? 'منتهي' : coursesController.currentCourse.value.data()["status"] == 2 ? "بأنتضار الكورس" : "فعال",style: TextStyle(color: Colors.white),),
                          ),
                            ],
                          ),
                        ),
                
                
                        
                        ],
                      ),
                
                   
                
                    ],
                  ),
                ),
              ),
              if(coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] > 2)
              SizedBox(height: 20,),
              if(coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] > 2)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TabBar(
                  isScrollable: coursesController.currentCourse.value.data()["subscription"] == 'gold' ? true : false,
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
                  if(coursesController.currentCourse.value.data()["subscription"] == 'gold')
                  Tab(text: "محسنات الاداء",),
                ]),
              ),
           SizedBox(height: 10,),
              if(coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] > 2 && _selectedTabbar == 0 )
               coursesController.courseExercises.value != null ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,pos){
                  var day = coursesController.courseExercises.value["days"][pos];
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
                      Get.to(ViewExrciesUser(name: day["name"] ?? "لا يوجد اسم",exercises: day["exercises"],));
                    },
                    child: Row(
                      children: [
                        LoadingImage(image: day['image'] ?? "",height: 100,width: 100,),
                        SizedBox(width: 15,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(day["name"] ?? "لا يوجد اسم",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
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
                },itemCount: coursesController.courseExercises.value["days"].length,shrinkWrap: true,) : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("لا يوجد تمارين",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
                ),

          
              if(coursesController.currentCourse.value != null && _selectedTabbar == 3)
                 if(coursesController.currentCourse.value.data()["hermoon"] == null || coursesController.currentCourse.value.data()["hermoon"] == "")
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("لا يوجد هرمونات",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
                ),
                if(coursesController.currentCourse.value != null && _selectedTabbar == 3)
                 if(coursesController.currentCourse.value.data()["hermoon"] != null || coursesController.currentCourse.value.data()["hermoon"] != "")
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(coursesController.currentCourse.value.data()["hermoon"],style: TextStyle(fontSize: 14.sp),),
                  ),

                if(coursesController.currentCourse.value != null && _selectedTabbar == 1)
                if(coursesController.currentCourse.value.data()["food"] == null || coursesController.currentCourse.value.data()["food"] == "")
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("لا يوجد نظام غذائي",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
                ),
                if(coursesController.currentCourse.value != null)
                if( coursesController.currentCourse.value.data()["food"] != null  && _selectedTabbar == 1)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      SizedBox(height: 10,),
                      Text(coursesController.currentCourse.value.data()["food"],style: TextStyle(fontSize: 14.sp),)
                    ],
                  ),
                ),
          
                SizedBox(height: 20,),
                              if(coursesController.currentCourse.value != null)
                              if(coursesController.currentCourse.value.data()["protien"] == null && coursesController.currentCourse.value.data()["protien"] == ""  && _selectedTabbar == 2)

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
                              if(coursesController.currentCourse.value != null)
                              if(coursesController.currentCourse.value.data()["protien"] != null  && _selectedTabbar == 2)
                              if(coursesController.currentCourse.value.data()["protien"] != ""  && _selectedTabbar == 2)
                            
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Text(coursesController.currentCourse.value.data()["protien"],style: TextStyle(fontSize: 14.sp),),

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
          
                if(coursesController.loading == false && coursesController.currentCourse.value == null)
              NoData()
            ],
                  ),
                  )),
          ),

        PreviosScreen()
        ])
      ),)
    );
  }
}