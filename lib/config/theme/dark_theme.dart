import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';

class AppDarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: const ColorScheme.dark(
        primary: MyColors.primary,
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFF5F5F5),
        onSurfaceVariant: Color(0xFFBDBDBD),
        outline: Color(0xFF666666),
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      iconTheme: const IconThemeData(
        color: Color(0xFFBDBDBD),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xFF9E9E9E),
        ),
        labelStyle: TextStyle(
          color: Color(0xFFBDBDBD),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.primary,
          ),
        ),
      ),
    );
  }
}