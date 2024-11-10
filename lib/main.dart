import 'package:chants/models/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:chants/screens/start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppTheme.lightBackgroundColor,
        colorScheme: AppTheme.lightColorScheme,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppTheme.lightTextColor),
          bodyMedium: TextStyle(color: AppTheme.lightTextColor),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.darkBackgroundColor,
        colorScheme: AppTheme.darkColorScheme,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppTheme.darkTextColor),
          bodyMedium: TextStyle(color: AppTheme.darkTextColor),
        ),
      ),
      home: const StartScreen(),
    );
  }
}
