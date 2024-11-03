// lib/models/chant_model.dart
import 'package:flutter/material.dart';

class ChantModel {
  int masterCount=0;
  int count;
  int malasCount;
  bool isTimerRunning;
  Duration elapsed;
  Duration masterElapsed;

  ChantModel({
    this.count = 0,
    this.malasCount = 0,
    this.isTimerRunning = false,
    this.elapsed = Duration.zero,
    this.masterElapsed=Duration.zero
  });

  void incrementCount() {
    count++;
    masterCount++; 
    if (count == 108) {
      count = 0;
      malasCount++;
    }
  }

  void reset() {
    count = 0;
    isTimerRunning = false;
    elapsed = Duration.zero;
  }

  static const Color primaryColor = Color.fromARGB(255, 220, 95, 149);
  static const Color highlightColor = Color.fromARGB(255, 213, 46, 118);
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color textColor = Color.fromARGB(255, 221, 205, 205);
}
