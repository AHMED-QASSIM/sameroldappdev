import 'package:flutter/material.dart';

abstract class ThemePalette {
  abstract final String? fontFamily;
  abstract final Brightness brightness;
  abstract final Color primaryColor;
  abstract final Color accentColor;
  abstract final Color backgroundColor;
  abstract final Color backColor;
  abstract final Color errorColor;
  abstract final Color inputBackgroundColor;
  abstract final Color inputBorderColor;
  abstract final Color textColor;
  abstract final Color secondaryTextColor;
  abstract final Color dividerColor;
  abstract final Color scafoldBackColor;
}
