import 'package:flutter/material.dart';
import 'dart:async';

class Chant extends StatefulWidget {
  const Chant({super.key});

  @override
  State<Chant> createState() => _ChantButtonState();
}

class _ChantButtonState extends State<Chant> {
  int count = 0;
  int malasCount = 0;
  // bool isHighlighted = false;
  bool isTimerRunning = false;
  late Timer _highlightTimer;
  late Timer _elapsedTimeTimer;
  final Stopwatch stopwatch = Stopwatch();

  // Color constants
  static const Color primaryColor = Color.fromARGB(255, 205, 131, 181);
  static const Color highlightColor = Color.fromARGB(255, 213, 46, 118);
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color textColor = Color.fromARGB(255, 221, 205, 205);

  @override
  void initState() {
    super.initState();
    // _startHighlightTimer();
  }

  // void _startHighlightTimer() {
  //   _highlightTimer = Timer(const Duration(seconds: 2), () {
  //     setState(() => isHighlighted = true);
  //   });
  // }

  void incrementCount() {
    setState(() {
      count++;
      if (count == 108) {
        count = 0;
        malasCount++;
      }
      if (!isTimerRunning) {
        stopwatch.start();
        isTimerRunning = true;
        _startElapsedTimeTimer();
      }
    });
  }

  void reset() {
    setState(() {
      count = 0;
      malasCount = 0;
      // isHighlighted = false;
      isTimerRunning = false;
      stopwatch.reset();
      stopwatch.stop();
      _highlightTimer.cancel();
      // _startHighlightTimer();
    });
  }

  void _startElapsedTimeTimer() {
    _elapsedTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (stopwatch.isRunning) setState(() {});
    });
  }

  void stopTimer() {
    setState(() {
      stopwatch.stop();
      isTimerRunning = false;
      _elapsedTimeTimer.cancel();
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  Widget _buildCounterDisplay() {
    return GestureDetector(
      onTap: incrementCount,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor,
            width: 5,
          ),
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 243, 134, 183),
              Color.fromARGB(255, 163, 22, 83),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCounterDisplay(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('Reset', reset),
                _buildButton("Malas  $malasCount", () {}),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              formatDuration(stopwatch.elapsed),
              style: const TextStyle(fontSize: 24.0, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _highlightTimer.cancel();
    if (isTimerRunning) _elapsedTimeTimer.cancel();
    super.dispose();
  }
}
