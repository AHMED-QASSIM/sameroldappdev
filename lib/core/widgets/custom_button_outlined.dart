import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/size_config.dart';

class CustomButtonOutlined extends StatelessWidget {
  const CustomButtonOutlined({
    Key? key,
    this.text,
    this.topSpace = 0,
    this.bottomSpace = 0,
    required this.onPressed,
  }) : super(key: key);
  final String? text;
  final VoidCallback onPressed;
  final double topSpace, bottomSpace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: topSpace * SizeConfig.heightMultiplier!,
          bottom: bottomSpace * SizeConfig.heightMultiplier!),
      child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 5))
          ], color: Theme.of(context).scaffoldBackgroundColor),
          height: 7 * SizeConfig.heightMultiplier!,
          child: new OutlinedButton(
            child: Text(
              text!.tr,
              style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier!),
            ),

            onPressed: onPressed,
          )),
    );
  }
}
