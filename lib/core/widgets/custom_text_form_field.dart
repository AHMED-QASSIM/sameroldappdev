import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../config/size_config.dart';
import '../validator/validator.dart';
import '../validator/validator_rule.dart';

class CustomTextFormField extends StatefulWidget {
   const CustomTextFormField(
      {this.controller,
      this.label,
      this.hint,
      this.keyboardType,
      required this.validators,
      this.prefixIcon,
      this.suffixIcon,
      this.suffixText,
      this.obscureText = false,
      this.showLabelStar = false,
      this.topSpace = 2,
      this.bottomSpace = 0,
      this.maxLines = 1,
      this.focusNode,
      this.isLabelVisible = true,
      this.onChanged,
      this.inputFormatters,
      this.textDirection,
      this.isRtl});

  final TextEditingController? controller;
  final String? label, hint, suffixText;
  final TextInputType? keyboardType;
  final List<ValidatorRule>? validators;
  final Widget? suffixIcon, prefixIcon;
  final bool obscureText, isLabelVisible;
  final double topSpace, bottomSpace;
  final showLabelStar;
  final int maxLines;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final bool? isRtl;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

    bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  String? text = '';

  @override
  Widget build(BuildContext context) {
    String localCode = Get.locale!.languageCode;
    return Padding(
      padding: EdgeInsets.only(
          top: widget.topSpace * SizeConfig.heightMultiplier!,
          bottom: widget.bottomSpace * SizeConfig.heightMultiplier!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isLabelVisible)
            widget.showLabelStar
                ? RichText(
                    text: TextSpan(
                        text: widget.label!.tr,
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                        TextSpan(
                            text: " *", style: TextStyle(color: Colors.red))
                      ]))
                : Text(
                    widget.label!.tr,
                    // getTranslated(context, label!),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
          if (widget.isLabelVisible)
            SizedBox(
              height: 1 * SizeConfig.heightMultiplier!,
            ),
          TextFormField(
                onChanged: widget.onChanged == null ? (value) {
            setState(() {
              text = value;
            });
          } : widget.onChanged ,
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            obscureText: widget.obscureText,
            
            keyboardType: widget.keyboardType,
          textDirection: widget.onChanged != null ? widget.isRtl! ? TextDirection.rtl : TextDirection.ltr : isRTL(text!) ? TextDirection.rtl : TextDirection.ltr,
            validator: (value) => widget.validators != null
                ? Validator.validate(value, widget.validators!)
                : null,
            maxLines: widget.maxLines,
            focusNode: widget.focusNode,
            inputFormatters: widget.inputFormatters,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              // hintText: getTranslated(context, hint!),
              hintText: widget.hint!.tr,
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
              suffixText: widget.suffixText,
              filled: true,
              fillColor: Get.isDarkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).inputDecorationTheme.fillColor,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:BorderSide(
                  width: 1,
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:  BorderSide(
                  width: 1,
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red.shade200,
                  style: BorderStyle.solid,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red.shade200,
                  style: BorderStyle.solid,
                ),
              ),

              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.25 * SizeConfig.heightMultiplier!,
                          horizontal: 2 * SizeConfig.widthMultiplier!),
                      child: Container(
                        margin: EdgeInsets.only(
                            right: 1 * SizeConfig.widthMultiplier!,
                            left: 1 * SizeConfig.widthMultiplier!),
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: localCode == "ar"
                              ? EdgeInsets.only(
                                  left: 0.75 * SizeConfig.widthMultiplier!)
                              : EdgeInsets.only(
                                  right: 1.75 * SizeConfig.widthMultiplier!),
                          child: widget.prefixIcon,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

