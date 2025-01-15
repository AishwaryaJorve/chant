// dark_theme.dart
import 'package:flutter/material.dart';

class DarkTheme {
  static final ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 205, 131, 181),
      onPrimary: Color(0xFFF5F5F5),
      // ignore: deprecated_member_use
      background: Colors.black,
      surface: Colors.black,
      onSurface: Color(0xFFF5F5F5),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFF5F5F5)),
      bodyMedium: TextStyle(color: Color(0xFFF5F5F5)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 205, 131, 181),
        foregroundColor: const Color(0xFFF5F5F5),
      ),
    ),
  );
}
