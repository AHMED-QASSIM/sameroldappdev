import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smaergym/screens/courses/course_screen.dart';
import 'package:smaergym/screens/chat/chat_screen.dart';
import 'package:smaergym/screens/home/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smaergym/screens/profile/profile_screen.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int cureentIndex = 0;
  Widget callPage(){
    switch(cureentIndex){
      case 0 : return HomeScreen();
      case 1 : return CourseScreen();
      case 2 : return ChatPage();
      case 3 : return ProfileScreen();

      default : return HomeScreen();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: cureentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 4,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (val){
          setState(() {
            cureentIndex = val;
          });
        },
        items: [
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svg/home.svg",width: 20.sp,color: cureentIndex == 0 ? Theme.of(context).primaryColor : Colors.black,),label: "الرئيسية"),
          BottomNavigationBarItem(icon:  SvgPicture.asset("assets/svg/gym.svg",width: 20.sp,color: cureentIndex == 1 ? Theme.of(context).primaryColor : Colors.black,),label: "كورساتي",),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svg/chat.svg",width: 20.sp,color: cureentIndex == 2 ? Theme.of(context).primaryColor : Colors.black,),label: "الجات"),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svg/profile.svg",width: 20.sp,color: cureentIndex == 3 ? Theme.of(context).primaryColor : Colors.black,),label: "حسابي"),
          

        ],
      ),
      body: callPage(),
    );
  }
}