import 'package:flutter/material.dart';

import 'theme_palette.dart';

class AppDarkTheme extends ThemePalette {
  @override
  String? get fontFamily => "Cairo";

  @override
  Color get primaryColor => const Color(0xFF8B9A46);

  @override
  Color get backgroundColor => const Color(0xFF191919);

  @override
  Color get errorColor => const Color(0xFFFE4D58);

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get dividerColor => const Color(0xFF6D6D9B);

  @override
  Color get inputBackgroundColor => const Color(0xFF363644);

  @override
  Color get inputBorderColor => const Color(0xFF606081);

  @override
  Color get secondaryTextColor => const Color(0xFF0A0A0E);

  @override
  Color get textColor => const Color(0xFFD6D6DA);

  @override
  // TODO: implement backColor
  Color get backColor => const Color(0xFF363644);

  @override
  // TODO: implement accentColor
  Color get accentColor => const Color(0xFFECDBBA);
  Color get scafoldBackColor => const Color(0xFF0F0E0E);
}
