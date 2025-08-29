import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme_palette.dart';

class ThemeGenerator {
  static ThemeData generate(ThemePalette palette) {
    return ThemeData(
      fontFamily: palette.fontFamily,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: palette.backgroundColor,
      brightness: palette.brightness,
      //backgroundColor: palette.backgroundColor,
      // colors
      primaryColor: palette.primaryColor,
      // ignore: deprecated_member_use
      // error: palette.errorColor,
      hintColor: palette.inputBorderColor,
      dividerColor: palette.dividerColor,
      

      // primary swatch
      primarySwatch:
          MaterialColor(palette.primaryColor.value, _getSwatchFromColor),

      // appbar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black
      ),

      // icon theme
      primaryIconTheme: _generateIconThemeData(palette.textColor),
      iconTheme: _generateIconThemeData(palette.textColor),

      // text theme
      primaryTextTheme: generateTextTheme(palette.textColor, 16),
      textTheme: generateTextTheme(palette.textColor, 12),
      // ignore: deprecated_member_use

      // bottom navigationbar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.backgroundColor,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(color: Colors.grey,fontSize: 12.sp),
        selectedLabelStyle: TextStyle(color: palette.primaryColor,fontSize: 12.sp),
        selectedItemColor: palette.primaryColor,
      ),

      // text selection theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.primaryColor,
        selectionColor: palette.primaryColor,
        selectionHandleColor: palette.primaryColor,
      ),

      // input decoration
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        fillColor: palette.inputBackgroundColor,
        filled: true,
        contentPadding: EdgeInsets.all(14),
      ),

      // buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          elevation: 0,
        ),
      ),
    );
  }

  // helper methods
  static Map<int, Color> _getSwatchFromColor = {
    50: Color.fromRGBO(147, 205, 72, .1),
    100: Color.fromRGBO(147, 205, 72, .2),
    200: Color.fromRGBO(147, 205, 72, .3),
    300: Color.fromRGBO(147, 205, 72, .4),
    400: Color.fromRGBO(147, 205, 72, .5),
    500: Color.fromRGBO(147, 205, 72, .6),
    600: Color.fromRGBO(147, 205, 72, .7),
    700: Color.fromRGBO(147, 205, 72, .8),
    800: Color.fromRGBO(147, 205, 72, .9),
    900: Color.fromRGBO(147, 205, 72, 1),
  };
  static TextStyle _generateTextStyle(Color color, double size,
      {FontWeight? weight = FontWeight.normal}) {
    return TextStyle(
        color: color, fontSize: size, fontWeight: weight, letterSpacing: 0);
  }

  static IconThemeData _generateIconThemeData(Color color) {
    return IconThemeData(
      color: color,
    );
  }

  static TextTheme generateTextTheme(Color color, double baseFontSize) {
    return TextTheme(

    );
  }
}
