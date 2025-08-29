import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smaergym/screens/admin/chats/chats_screen.dart';
import 'package:smaergym/screens/admin/courses/courses_screen.dart';
import 'package:smaergym/screens/admin/exercise/exercise.dart';
import 'package:smaergym/screens/chat/chat_screen.dart';
import 'package:smaergym/screens/home/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smaergym/screens/profile/profile_screen.dart';
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<AdminDashboard> {

  int cureentIndex = 0;
  Widget callPage(){
    switch(cureentIndex){
      case 0 : return CoursesScreenAdmin();
      case 1 : return Excersies();
      case 2 : return Chats();
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
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svg/gym.svg",width: 20.sp,color: cureentIndex == 0 ? Theme.of(context).primaryColor : Colors.black,),label: "الكورسات"),
          BottomNavigationBarItem(icon:  SvgPicture.asset("assets/svg/dumbbell-gym-svgrepo-com.svg",width: 20.sp,color: cureentIndex == 1 ? Theme.of(context).primaryColor : Colors.black,),label: "التمارين",),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svg/chat.svg",width: 20.sp,color: cureentIndex == 2 ? Theme.of(context).primaryColor : Colors.black,),label: "الجات"),
          BottomNavigationBarItem(icon: SvgPicture.asset("assets/svg/profile.svg",width: 20.sp,color: cureentIndex == 3 ? Theme.of(context).primaryColor : Colors.black,),label: "حسابي"),
          

        ],
      ),
      body: callPage(),
    );
  }
}