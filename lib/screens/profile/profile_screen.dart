import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/controllers/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/custom_button.dart';
import '../../core/widgets/loader_image_widget.dart';
import '../auth/login_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
   
        centerTitle: true,
        actions: [
        

        ],
      ),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Obx(()=> Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(
              width: 120.w,height: 120.w,
              child: LoadingImage(image: userController.user.value.image ?? "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",width: 120.w,height: 120.w,radius: 100,)),
            SizedBox(height: 10,),
            Text(userController.user.value.name!,style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.normal,fontSize: 18.sp),),
            Text(userController.user.value.phone!,style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 15.sp,height: 1.2,color: Colors.grey.shade600).copyWith(fontWeight: FontWeight.normal),),
       

            SizedBox(height: 20,),

            // if(userController.user.value.admin != true)
            // section(SvgPicture.asset("assets/svg/gym.svg",width: 20.sp,),"عدد الكورسات",Text("0",style: TextStyle(fontSize: 14.sp),)),
            //             SizedBox(height: 15,),
            if(userController.user.value.admin != true)
            section(null,"تواصل مع الكابتن",Text("",style: TextStyle(fontSize: 14.sp),)),
                        SizedBox(height: 15,),

            if(userController.user.value.admin != true)
                            Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            launch("https://www.facebook.com/1C.samerr?mibextid=LQQJ4d");
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
                                        // on insta
                                        GestureDetector(
                                          onTap: (){
                                            launch("https://instagram.com/samerno1?igshid=YmMyMTA2M2Y=");
                                          },
                                         
                                            child: SvgPicture.asset("assets/svg/insta.svg",width: 47.sp,),
                                        ),
                                      ],
                                    ),
               
            SizedBox(height: 15,),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red,width: 1),
                borderRadius: BorderRadius.circular(10)
              ),
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(onPressed: (){
                FirebaseAuth.instance.signOut().then((value){
                Get.offAll(LoginScreen());

                });
              },text: "تسجيل الخروج",backgroundColor: Colors.red.shade100,fontColor: Colors.red.shade400),
            ),

            SizedBox(height: 20,),

            InkWell(
              onTap: (){
                Get.dialog(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Material(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Text("حذف حسابي",style: TextStyle(fontSize: 20.sp),),
                          SizedBox(height: 10,),
                      
                          Text("سيتم حذف جميع بياناتك ولا يمكن استعادتها",style: TextStyle(fontSize: 16.sp,color: Colors.grey.shade600),),
                      
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomButton(onPressed: (){
                                    FirebaseAuth.instance.currentUser!.delete().then((value){
                                      Get.offAll(LoginScreen());
                                    });
                                  },text: "نعم",backgroundColor: Colors.red.shade100,fontColor: Colors.red.shade400),
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: CustomButton(onPressed: (){
                                    Get.back();
                                  },text: "لا",backgroundColor: Colors.grey.shade100,fontColor: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )],
                ));
              },
              child: Text("حذف حسابي",style: TextStyle(color: Colors.red),)),
            SizedBox(height: 40,),
          ],
        ),)
       ),
    );
  }


  Widget section(Widget? icon,String text,Widget suffixIcon){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if(icon != null)
          icon,
          SizedBox(width: 10,),
          Expanded(child: Text(text,style: TextStyle(fontSize: 14.sp),)),
          suffixIcon
        ],
      ),
    );
  }
}