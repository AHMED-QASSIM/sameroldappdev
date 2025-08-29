import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoadingWidgetCategorie extends StatelessWidget {
  final bool showSecondLine;
  const LoadingWidgetCategorie({Key? key, this.showSecondLine = true})
      : super(key: key);
  final delay = 300;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        height: 80.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 4,
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, pos) {
            return Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeShimmer(
                    height: 70.w,
                    width: 70.w,
                    radius: 10,
                    millisecondsDelay: delay,
                    fadeTheme:
                        Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  if (showSecondLine)
                    FadeShimmer(
                      height: 8,
                      millisecondsDelay: delay,
                      width: 70.w,
                      radius: 4,
                      fadeTheme:
                          Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
