import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoData extends StatelessWidget {
  final String? title;
  const NoData({Key? key,this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/json/nodata.json', width: 300.w),
      SizedBox(height: 20,),
        Text(
         title ?? "لا يوجد كورسات",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 90,
        ),
      ],
    );
  }
}
