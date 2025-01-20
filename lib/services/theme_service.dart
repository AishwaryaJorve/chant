import 'package:flutter/material.dart';

class ThemeService {
  static ThemeData get lightTheme {
    const primaryPink = Color(0xFFFF8BA7);    // Soft pink
    const secondaryPink = Color(0xFFFFC6C7);  // Lighter pink
    const surfacePink = Color(0xFFFFF1F3);    // Very light pink
    
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryPink,
        secondary: secondaryPink,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF4A4A4A),
        onSurface: Color(0xFF4A4A4A),
      ),
      scaffoldBackgroundColor: surfacePink,
      cardColor: Colors.white,
      dividerColor: secondaryPink,
      iconTheme: const IconThemeData(
        color: primaryPink,
        size: 24,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Color(0xFF4A4A4A)),
        bodyMedium: TextStyle(color: Color(0xFF4A4A4A)),
      ),
      // Update button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
        ),
      ),
      // Keep dark theme as is...
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF9DB5B2),        // Muted sage
        secondary: const Color(0xFFDAA89B),      // Muted terracotta
        surface: const Color(0xFF1E2324),     // Darker background
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white.withOpacity(0.87),
      ),
      scaffoldBackgroundColor: const Color(0xFF121617),
      cardColor: const Color(0xFF1E2324),
      dividerColor: Colors.white12,
      iconTheme: const IconThemeData(
        color: Color(0xFF9DB5B2),
        size: 24,
        opacity: 0.87,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white.withOpacity(0.87),
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.white.withOpacity(0.87)),
        bodyMedium: TextStyle(color: Colors.white.withOpacity(0.87)),
      ),
    );
  }
} 