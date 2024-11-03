// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 205, 131, 181);
  static const Color highlightColor = Color.fromARGB(255, 213, 46, 118);
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color textColor = Color(0xFFF5F5F5);

  // Gradient colors
  static const List<Color> gradientColors = [
    // Color.fromARGB(255, 243, 134, 183),
    // Color.fromARGB(255, 163, 22, 83),
    Color.fromARGB(255, 245, 131, 182), 
    Color.fromARGB(255, 135, 3, 60), 
  ];

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradientColors,
  );
}
