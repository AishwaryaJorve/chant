import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer functionality

class Chant extends StatefulWidget {
  const Chant({super.key});

  @override
  State<Chant> createState() => _ChantButtonState();
}

class _ChantButtonState extends State<Chant> {
  int count = 0;
  bool isHighlighted = false; // Flag for button highlight after 2 seconds
  late Timer _highlightTimer; // Timer for button highlight
  late Timer _elapsedTimeTimer; // Timer for elapsed time update
  int malasCount = 0; // Counter for malas (completed sets of 108 chants)
  Stopwatch stopwatch = Stopwatch(); // Timer for tracking chanting duration
  bool isTimerRunning = false; // Flag for stopwatch running state

  @override
  void initState() {
    super.initState();
    _startHighlightTimer();
  }

  void _startHighlightTimer() {
    _highlightTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isHighlighted = true;
      });
    });
  }

  void incrementCount() {
    setState(() {
      count++;
      if (count == 108) {
        count = 0; // Reset count after 108
        malasCount++; // Increment malas count
      }
      if (!isTimerRunning) {
        stopwatch.start(); // Start stopwatch on first chant
        isTimerRunning = true;
        _startElapsedTimeTimer(); // Start the elapsed time timer
      }
    });
  }

  void _startElapsedTimeTimer() {
    _elapsedTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (stopwatch.isRunning) {
        setState(() {}); // Rebuild the UI to update the elapsed time
      }
    });
  }

  void stopTimer() {
    setState(() {
      stopwatch.stop();
      isTimerRunning = false;
      _elapsedTimeTimer.cancel(); // Stop the elapsed time timer
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}"; 
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center widgets vertically
        children: [
          GestureDetector(
            onTap: incrementCount,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isHighlighted ? Colors.red : Colors.purple, // Border color with highlight
                  width: 5, // Border width
                ),
                color: Colors.transparent, // Transparent background
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 72.0, // Adjust font size as needed
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Spacing between buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons horizontally
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('just button'), // Dynamic button text
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Malas  $malasCount"),
              ),
            ],
          ),
          const SizedBox(height: 10), // Spacing between buttons and timer display
          Text(
            formatDuration(stopwatch.elapsed), // Display formatted elapsed time
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _highlightTimer.cancel();
    if (isTimerRunning) {
      _elapsedTimeTimer.cancel(); // Cancel the elapsed time timer
    }
    super.dispose();
  }
}
