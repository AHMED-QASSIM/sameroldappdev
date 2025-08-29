import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';
import 'package:smaergym/screens/admin/courses/view_course_details.dart';
class ChatDetailPageAppBar extends StatelessWidget implements PreferredSizeWidget{
 final String name;
 final String image;
 final String phone;
 final bool isAdmin;
 final isFile;
 ChatDetailPageAppBar({required this.image, required this.name,required this.phone,required this.isAdmin,this.isFile = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: GestureDetector(
          onTap: (){
            if(isAdmin){
            Get.to(ViewCourseDetails(phone: phone));

            }
          },
          child: Container(
            height: 70.h,
            child: Row(
              children: <Widget>[
                    if(phone.isEmpty)
                SizedBox(width: 20,),

            if(phone.isNotEmpty)
                SizedBox(width: 50,),
                if(isFile)
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset("assets/samer.jpg",width: 40.sp))
                else
                LoadingImage(image: image,radius: 200,width: 40,height: 40,),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(name,style: TextStyle(fontWeight: FontWeight.w600),),
                      if(phone.isNotEmpty)
                      Text(phone,style: TextStyle(color: Colors.grey,fontSize: 12,height: 1.5),),
                    ],
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}