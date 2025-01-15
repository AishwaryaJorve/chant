// light_theme.dart
import 'package:flutter/material.dart';

class LightTheme {
  static final ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 205, 131, 181),
      onPrimary: Colors.black,
      // ignore: deprecated_member_use
      background: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 205, 131, 181),
        foregroundColor: Colors.white,
      ),
    ),
  );
}
