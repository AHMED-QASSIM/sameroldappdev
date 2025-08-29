// ignore_for_file: prefer_const_constructors

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smaergym/screens/exercies/app_viwe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/controllers/exercise_controller.dart';


class ViewExrcies extends StatefulWidget {
  final String name;
  final String id;
  final String sets;
  const ViewExrcies({super.key,required this.id,required this.name,required this.sets});


  @override
  State<ViewExrcies> createState() => _ViewExrciesState();
}

class _ViewExrciesState extends State<ViewExrcies> {

  ExerciseController controller = Get.find();



  @override
  void initState() {
    // TODO: implement initState
    controller.getExeById(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(()=> controller.loadExe.value == false ? Container(
        padding: EdgeInsets.all(20),
        height: 120.sp,
        width: MediaQuery.of(context).size.width,
        // ignore: sort_child_properties_last
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("الدفعات",style: Theme.of(context).textTheme.titleMedium,),
                Text(widget.sets,style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),textDirection: TextDirection.ltr,),

              ],

              
            ),
          ),
         Column(
          children: [
             Text("فديو تعليمي",style: TextStyle(color: Colors.white,fontSize: 16.sp),),
             SizedBox(height: 10,),
             GestureDetector(
              onTap: (){

                Get.to(TrainAppView(url: controller.exe.value.youtubeLink!));

//                 YoutubePlayerController _controller = YoutubePlayerController(
//     initialVideoId: YoutubePlayer.convertUrlToId(controller.exe.value.youtubeLink!)!,
//     flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//     ),
// );

//                 Get.bottomSheet(Container(
//                   height:MediaQuery.of(context).size.height,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 3,
//                               width: 30.sp,
//                               decoration: BoxDecoration(
//                               color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(10)
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(height: 10,),
//                         YoutubePlayer(
//                           aspectRatio: 2 / 2.274,
//     controller: _controller,
// ),
//                       ],
//                     ),
//                   ),
//                 )
                
              },
               child: Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Icon(Icons.play_arrow,color: Colors.white,),
               ),
             )
          ],
         )
        ],
      ),decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10)
      ),margin: EdgeInsets.all(30),) : Container()),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.name,style: TextStyle(color: Colors.white,fontSize: 14),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 250.sp,
        alignment: Alignment.center,
        child: Obx(()=> controller.loadExe.value ? CircularProgressIndicator() : Container(
          margin: EdgeInsets.all(30),
          child: Swiper(
       
            
              
itemBuilder: (BuildContext context, int index) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      color: Colors.white, // optional background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Image.network(
            controller.exe.value.image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 500, // set height for image
          ),

          // Text title
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    //SizedBox(width: 8),
    if (controller.exe.value.name != controller.exe.value.description)  
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Name
          Text(
            "اسم التمرين البديل",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          // Description
          Text(
            controller.exe.value.description ?? "لايوجد",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),

        // Play video icon
    if (controller.exe.value.youtubeLink2 != null)    
    IconButton(
      icon: Icon(Icons.play_circle_fill, color: Theme.of(context).primaryColor),
      onPressed: () {
        // Add your video play logic here, e.g., open YouTube link
        String? videoUrl = controller.exe.value.youtubeLink2;
        if (videoUrl != null && videoUrl.isNotEmpty) {
                         Get.to(TrainAppView(url: controller.exe.value.youtubeLink2!));

        }
      },
    ),

  ],
),

          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
,
  itemCount: 1,
  physics: NeverScrollableScrollPhysics(),
  itemWidth: MediaQuery.of(context).size.width,
  layout: SwiperLayout.DEFAULT,
),
        ),)
      ),
    );
  }
}