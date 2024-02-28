import 'package:flutter/material.dart';

class AppThemes extends ChangeNotifier {
  static ThemeMode currentTheme = ThemeMode.light;

  static ThemeData light() {
    return ThemeData(
        brightness: Brightness.light, textTheme: const TextTheme());
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
    );
  }
}
