import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smaergym/core/models/exrcies_model.dart';
import 'package:smaergym/core/models/sections_model.dart';

import '../config/size_config.dart';

class DropdownTamreenWidget extends StatelessWidget {
  final List<ExerciseModel> items;
  final dynamic? selectedValue;
  final Function(dynamic) onChange;
  final String? hint;
  final String? label;
  const DropdownTamreenWidget(
      {Key? key,
      required this.items,
      this.selectedValue,
      required this.onChange,
      this.hint,
      this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (label != null)
          SizedBox(
            height: 1 * SizeConfig.heightMultiplier!,
          ),
        DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300
              ),
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).inputDecorationTheme.fillColor),
            child: DropdownButton2(
                          iconStyleData:  IconStyleData(
              icon:  SvgPicture.asset(
                "assets/svg/down.svg",
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),

            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.redAccent,
              ),
              offset: Offset(0, -10),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(10),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

              hint: Text(
                hint!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              items: items
                  .map((item) => DropdownMenuItem<Object>(
                        value: item,
                        child: Text(
                          item.name!,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                onChange(value);
              },
                 buttonStyleData: ButtonStyleData(
              height: 40,
              width: 140,

                 ),

            menuItemStyleData: const MenuItemStyleData(
              height: 40,
             
            ),            ),
          ),
        ),
      ],
    );
  }
}
