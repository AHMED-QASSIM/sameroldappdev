import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/size_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.text,
    this.backgroundColor,
    this.topSpace = 0,
    this.bottomSpace = 0,
    this.width,
    this.loading = false,
    required this.onPressed,
    this.fontColor
  });

  final String? text;
  final Function() onPressed;
  final double? topSpace, bottomSpace, width;
  final bool? loading;
  final Color? backgroundColor;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: topSpace! * SizeConfig.heightMultiplier!,
          bottom: bottomSpace! * SizeConfig.heightMultiplier!),
      child: Container(
        width: width != null ? width : MediaQuery.of(context).size.width,
        height: 6.5 * SizeConfig.heightMultiplier!,
        child: TextButton(
          onPressed: onPressed,
          child: loading == true
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text!.tr,
                  //getTranslated(context, text),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                      color: fontColor != null ? fontColor : Colors.white,
                      fontSize: 2 * SizeConfig.textMultiplier!),
                ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(backgroundColor),shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ))),
        ),
      ),
    );
  }
}
