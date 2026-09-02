import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';

class AppLightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: const ColorScheme.light(
        primary: MyColors.primary,
        surface: Colors.white,
        onSurface: MyColors.black,
        onSurfaceVariant: MyColors.text,
        outline: MyColors.hintGrey,
      ),

      scaffoldBackgroundColor: MyColors.backgroundColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.backgroundColor,
        foregroundColor: MyColors.black,
        elevation: 0,
      ),

      iconTheme: const IconThemeData(
        color: MyColors.icon,
      ),

      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: MyColors.hintGrey,
        ),
        labelStyle: TextStyle(
          color: MyColors.labelGrey,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.focusedBorder,
          ),
        ),
      ),
    );
  }
}