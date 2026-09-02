import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';

class AppInputDecoration {
  static InputDecoration underline({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      labelStyle: const TextStyle(
        color: MyColors.labelGrey,
        fontSize: 15,
      ),

      hintStyle: const TextStyle(
        color: MyColors.hintGrey,
        fontSize: 13,
      ),

      floatingLabelStyle: const TextStyle(
        color: MyColors.focusedBorder,
        fontSize: 15,
      ),

      isDense: true,

      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      suffixIcon: suffixIcon,

      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black26,
        ),
      ),

      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: MyColors.focusedBorder,
          width: 1.8,
        ),
      ),

      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.8,
        ),
      ),
    );
  }
}