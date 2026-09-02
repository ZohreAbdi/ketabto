import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  static const String _boxName = 'profileBox';
  static const String _themeKey = 'theme_mode';

  static Future<void> init() async {
    final box = Hive.box(_boxName);

    final savedTheme = box.get(_themeKey) as String?;

    switch (savedTheme) {
      case 'light':
        themeNotifier.value = ThemeMode.light;
        break;

      case 'dark':
        themeNotifier.value = ThemeMode.dark;
        break;

      default:
        themeNotifier.value = ThemeMode.system;
    }
  }

  static Future<void> setTheme(ThemeMode mode) async {
    themeNotifier.value = mode;

    final box = Hive.box(_boxName);

    await box.put(
      _themeKey,
      mode.name,
    );
  }
}