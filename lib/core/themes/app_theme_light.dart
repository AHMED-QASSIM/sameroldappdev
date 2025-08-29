import 'dart:ui';

import 'package:flutter/material.dart';

import 'theme_palette.dart';

class AppTheme extends ThemePalette {
  @override
  String? get fontFamily => "Cairo";

  @override
  Color get primaryColor => const Color(0xFF6493E7);

  @override
  Color get backgroundColor => Color.fromARGB(255, 249, 252, 255);

  @override
  Color get errorColor => const Color(0xFF0a3d62);

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get dividerColor => const Color(0xFF928F9F);

  @override
  Color get inputBackgroundColor => Colors.grey.shade100;

  @override
  Color get inputBorderColor => const Color(0xFFCECCD6);

  @override
  Color get secondaryTextColor => const Color(0xFFD6D6DA);

  @override
  Color get textColor => const Color(0xFF4C4C4C);

  @override
  // TODO: implement backColor
  Color get backColor => const Color(0xFFFFFFFF);

  @override
  // TODO: implement accentColor
  Color get accentColor => const Color(0xFFA5BACF);

  @override
  // TODO: implement scafoldBackColor
  Color get scafoldBackColor => Color.fromARGB(255, 255, 255, 255);
}
