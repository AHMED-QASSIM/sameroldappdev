import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:smaergym/core/widgets/loader_image_widget.dart';
import 'package:smaergym/screens/admin/exercise/showall.dart';

class Excersies extends StatefulWidget {
  const Excersies({super.key});

  @override
  State<Excersies> createState() => _ExcersiesState();
}

class _ExcersiesState extends State<Excersies>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List mucles = [
    {
      "name" : "الظهر",
      "icon" : "assets/svg/muscle/body-part.png",
      "id" : 1
    },
      {
      "name" : "الصدر",
      "icon" : "assets/svg/muscle/chest.png",
      "id" : 2
    },
         {
      "name" : "الكتف",
      "icon" : "assets/svg/muscle/shoulder.png",
      "id" : 3
    },
          {
      "name" : "التراي",
      "icon" : "assets/svg/muscle/triceps.png",
      "id" : 4
    },

              {
      "name" : "الباي",
      "icon" : "assets/svg/muscle/bicep.png",
      "id" : 5

    },

                  {
      "name" : "الرجل",
      "icon" : "assets/svg/muscle/leg.png",
      "id" : 6

    },

                    {
      "name" : "الكولف",
      "icon" : "assets/svg/muscle/calves.png",
      "id" : 7

    },

                        {
      "name" : "الساعد",
      "icon" : "assets/svg/muscle/band.png",
      "id" : 8
    },


                        {
      "name" : "البطن",
      "icon" : "assets/svg/muscle/abs.png",
      "id" : 9
    },


                            {
      "name" : "تمارين اخرى",
      "icon" : "assets/svg/muscle/upper-body.png",
      "id" : 10
    }
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text("التمارين"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DynamicHeightGridView(
          itemCount: mucles.length,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          builder: (ctx, index) {
            /// return your widget here.
            return GestureDetector(
              onTap: (){
                Get.to(ShowAllScreen(title: mucles[index]["name"],id:mucles[index]["id"] ,));
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                   Image.asset(mucles[index]["icon"],width: 70.w,),
                   SizedBox(height: 10,),
                   Divider(color: Colors.grey.shade300,),
                    Text(mucles[index]["name"],style: TextStyle(fontSize: 14.sp),)
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}