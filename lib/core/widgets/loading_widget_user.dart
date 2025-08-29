import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidgetProfile extends StatelessWidget {
  const LoadingWidgetProfile({Key? key}) : super(key: key);
  final delay = 300;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
               ,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: 
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeShimmer(
                height: 15,
                width: 150,
                radius: 5,
                millisecondsDelay: delay,
                fadeTheme: Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
                highlightColor: Colors.grey.shade500,
              ),
              SizedBox(
                height: 6,
              ),
                FadeShimmer(
                height: 10,
                width: 200,
                radius: 5,
                millisecondsDelay: delay,
                highlightColor: Colors.grey.shade500,

                fadeTheme: Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
              ),
              SizedBox(height: 6,),
              FadeShimmer(
                height: 80,
                millisecondsDelay: delay,
                width: MediaQuery.of(context).size.width,
                radius: 5,
                highlightColor: Colors.grey,

                fadeTheme: Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
              ),
            ],
          )
       
    );
  }
}
