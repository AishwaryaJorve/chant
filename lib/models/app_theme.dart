import 'package:flutter/material.dart';

class AppTheme {
  // Common colors
  static const Color primaryColor = Color.fromARGB(255, 205, 131, 181);
  static const Color highlightColor = Color.fromARGB(255, 213, 46, 118);
  static const Color textColor = Color(0xFFF5F5F5);

  // Light and dark mode colors
  static const _LightColors = _ThemeColors(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    buttonColor: primaryColor,
    buttonTextColor: Colors.white,
    counterBorderColor: Color(0xFFCCCCCC),
    counterTextColor: Colors.black,
  );

  static const _DarkColors = _ThemeColors(
    backgroundColor: Colors.black,
    textColor: Color(0xFFF5F5F5),
    buttonColor: primaryColor,
    buttonTextColor: Color(0xFFF5F5F5),
    counterBorderColor: Color(0xFF666666),
    counterTextColor: Colors.white,
  );

  // Public getters to access light and dark theme colors
  static Color get lightBackgroundColor => _LightColors.backgroundColor;
  static Color get lightTextColor => _LightColors.textColor;
  static Color get darkBackgroundColor => _DarkColors.backgroundColor;
  static Color get darkTextColor => _DarkColors.textColor;

  // Light theme color scheme
  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: primaryColor,
    onPrimary: _LightColors.textColor,
    surface: _LightColors.backgroundColor,
    onSurface: _LightColors.textColor,
  );

  // Dark theme color scheme
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: primaryColor,
    onPrimary: _DarkColors.textColor,
    surface: _DarkColors.backgroundColor,
    onSurface: _DarkColors.textColor,
  );

  // Helper method to get the correct color set based on theme mode
  static _ThemeColors _getColors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _DarkColors : _LightColors;
  }

  // Methods to access colors based on theme mode
  static Color backgroundColor(BuildContext context) => _getColors(context).backgroundColor;
  static Color textColorForMode(BuildContext context) => _getColors(context).textColor;
  static Color buttonColorForMode(BuildContext context) => _getColors(context).buttonColor;
  static Color buttonTextColorForMode(BuildContext context) => _getColors(context).buttonTextColor;
  static Color counterBorderColorForMode(BuildContext context) => _getColors(context).counterBorderColor;
  static Color counterTextColorForMode(BuildContext context) => _getColors(context).counterTextColor;
}

// Internal class to store theme-dependent color values
class _ThemeColors {
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color counterBorderColor;
  final Color counterTextColor;

  const _ThemeColors({
    required this.backgroundColor,
    required this.textColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.counterBorderColor,
    required this.counterTextColor,
  });
}
