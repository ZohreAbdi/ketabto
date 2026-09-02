import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageController {
  static Future<void> setLanguage(
    BuildContext context,
    Locale locale,
  ) async {
    await context.setLocale(locale);
  }

  static Locale currentLanguage(BuildContext context) {
    return context.locale;
  }
}