import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';
import 'package:smaergym/screens/exercies/view_exrcies.dart';
import '../../../core/controllers/courses_details_controller.dart';
import '../../../core/widgets/loading_widget_user.dart';
import '../../../core/widgets/no_data_widget.dart';
import 'package:intl/intl.dart' as intl;

class ViewCourseDetails extends StatefulWidget {
  final String phone;
  const ViewCourseDetails({super.key,required this.phone});

  @override
  State<ViewCourseDetails> createState() => _ViewCourseDetailsState();
}

class _ViewCourseDetailsState extends State<ViewCourseDetails> {

 CoursesDetailsController coursesController = Get.put(CoursesDetailsController());
 List images = [];
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
    coursesController.getCurrentCourse(widget.phone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("معلومات اللاعب"),
      ),
      body: SingleChildScrollView(
              
              child:  Obx(()=> coursesController.loading.value ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context,pos){
            return LoadingWidgetProfile();
                  },itemCount:  5,padding: EdgeInsets.all(20),) : Column(
            children: [
              if(coursesController.currentCourse.value != null &&coursesController.currentCourse.value.data()["status"] < 2)
              Container(
                margin: EdgeInsets.only(top: 40),
                child: NoData(title: "لا يوجد كورس",)),
              if(coursesController.currentCourse.value != null &&coursesController.currentCourse.value.data()["status"] > 2)
              
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300)
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                children: [

infoCard(title: "الاسم",subtitle:  coursesController.currentCourse.value.data()["name"],icon: CupertinoIcons.bolt_horizontal),
                 
                  Divider(),

infoCard(title: "الوزن",subtitle:  coursesController.currentCourse.value.data()["weight"],icon: CupertinoIcons.bolt_horizontal),

                ],
              ),),
              if(coursesController.currentCourse.value != null &&coursesController.currentCourse.value.data()["status"] > 2)
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
                         CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 15.0,
                        percent: 0.03333 * (DateTime.now().difference(coursesController.currentCourse.value.data()["date"].toDate()).inDays),
                        center:  Text((30 - DateTime.now().difference(coursesController.currentCourse.value.data()["date"].toDate()).inDays).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp,color: Colors.white),),
                        progressColor: Color(0xFFDAA520),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(coursesController.currentCourse.value.data()["gymName"],style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),),
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
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          width: 60.sp,
                          alignment: Alignment.center,
                          height: 30.sp,
                          child: Text("فعال",style: TextStyle(color: Colors.white),),
                        ),
                          ],
                        ),
                      ),
              
              
                      
                      ],
                    ),
              
                 
              
                  ],
                ),
              ),
              if(coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] > 2)
              SizedBox(height: 20,),
              if(coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] > 2)
              
              Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                       child: Text("التمارين",style: TextStyle(color: Colors.white,fontSize: 14.sp),),
                      ),
              if(coursesController.currentCourse.value != null && coursesController.currentCourse.value.data()["status"] > 2)
                 
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,pos){
                  return Container(
                  width:MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("اليوم ${convNumToText(pos)}",style: TextStyle(fontSize: 14.sp),),
                      SizedBox(height: 5,),
                      Container(width: 30.sp,height: 2,decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100)
                      ),),
          
                      SizedBox(height: 10,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: coursesController.courseExercises.value["days"][pos]["exercises"].length,
                        itemBuilder: (context,index){
                        return Container(
                          padding: EdgeInsets.all(10),
                        
                          child: GestureDetector(
                            onTap: (){
                              Get.to(ViewExrcies(sets: coursesController.courseExercises.value["days"][pos]["exercises"][index]["sets"],name: coursesController.courseExercises.value["days"][pos]["exercises"][index]["name"],id: coursesController.courseExercises.value["days"][pos]["exercises"][index]["id"],));
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                  Expanded(child:   Text(coursesController.courseExercises.value["days"][pos]["exercises"][index]["name"],style: TextStyle(fontSize: 12.sp),)),
                                  Text(coursesController.courseExercises.value["days"][pos]["exercises"][index]["sets"],textDirection: TextDirection.ltr,style: TextStyle(fontSize: 12.sp),),
                                  SizedBox(width: 20,),
                                        
                                  Icon(CupertinoIcons.eye,size: 14.sp,color: Theme.of(context).primaryColor,),
                                        
                                  SizedBox(width: 10,),
                                
                                  
                                  ],
                                ),

                                ListView.builder(itemBuilder: (context,supers){
                                  return  Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("-"),
                                    ),
                                  Expanded(child:   Text(coursesController.courseExercises.value["days"][pos]["exercises"][index]["exerciseSuper"][supers]["name"],style: TextStyle(fontSize: 12.sp,color: Colors.green),)),
                                  Text(coursesController.courseExercises.value["days"][pos]["exercises"][index]["exerciseSuper"][supers]["sets"],textDirection: TextDirection.ltr,style: TextStyle(fontSize: 12.sp,color: Colors.green),),
                                  SizedBox(width: 20,),
                                        
                                  Icon(CupertinoIcons.eye,size: 14.sp,color: Theme.of(context).primaryColor,),
                                        
                                  SizedBox(width: 10,),
                                
                                  
                                  ],
                                );
                                },shrinkWrap: true,itemCount: coursesController.courseExercises.value["days"][pos]["exercises"][index]["exerciseSuper"].length,)
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                );
                },itemCount: coursesController.courseExercises.value["days"].length,shrinkWrap: true,),
          
                if(coursesController.currentCourse.value != null)
                if(coursesController.currentCourse.value.data()["food"] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("الاطعمة",style: TextStyle(fontSize: 16.sp),),
                      Container(
                        height: 2,
                        width: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 10,),
                      Text(coursesController.currentCourse.value.data()["food"],style: TextStyle(fontSize: 14.sp),)
                    ],
                  ),
                ),
          
                SizedBox(height: 20,),
          if(coursesController.currentCourse.value != null)
                              if(coursesController.currentCourse.value.data()["protien"] != null)
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
                      Text(coursesController.currentCourse.value.data()["protien"],style: TextStyle(fontSize: 14.sp),)
                    ],
                  ),
                ),

                SizedBox(height: 20,),
          if(coursesController.currentCourse.value != null)
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("صور اللاعب",style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.start,
                          children: List.from(coursesController.currentCourse.value.data()["images"]).map((e){
                            return LoadingImage(image: e,width: MediaQuery.of(context).size.width / 2.3,height: 200.sp,radius: 10,);
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),

                           SizedBox(height: 20,),
          if(coursesController.currentCourse.value != null)
           if(coursesController.currentCourse.value.data()["tests"] != null)
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("صور التحاليل",style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.center,
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.start,
                          children: List.from(coursesController.currentCourse.value.data()["tests"]).map((e){
                            return LoadingImage(image: e,width: MediaQuery.of(context).size.width / 2.3,height: 200.sp,radius: 10,);
                          }).toList(),
                        ),
                      ),

                          SizedBox(height: 10,),

                            Text("الاطعمة",style: Theme.of(context).textTheme.titleLarge,),
                            Text(coursesController.currentCourse.value.data()["food"],style: Theme.of(context).textTheme.titleLarge,),


                     
                      SizedBox(height: 20,),

                            Text("محسنات الاداء",style: Theme.of(context).textTheme.titleLarge,),
                           Text(coursesController.currentCourse.value.data()["hermoon"],
                         style: Theme.of(context).textTheme.titleLarge,),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
          
                if(coursesController.loading == false && coursesController.currentCourse.value == null)
              NoData()
            ],
                  ),
                  )),
    );
  }


  Widget infoCard({title,subtitle,required IconData icon}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 10,),
        Icon(icon,size: 20.sp,color: Colors.grey,),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style:  TextStyle(fontSize: 12.sp)),
            Text(subtitle,style: Theme.of(context).textTheme.titleMedium,),

          ],
        )
      ],
    );
  }
}