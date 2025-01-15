import 'package:chants/models/app_theme.dart';
import 'package:chants/widgets/chant_control_buttons.dart';
import 'package:chants/widgets/chant_info_buttons.dart';
import 'package:flutter/material.dart';
import '../models/chant_model.dart';
import '../services/timer_service.dart';
import '../widgets/chant_counter_button.dart'; // Import the new widget

class ChantScreen extends StatefulWidget {
  const ChantScreen({super.key});

  @override
  State<ChantScreen> createState() => _ChantScreenState();
}

class _ChantScreenState extends State<ChantScreen> {
  final ChantModel chantModel = ChantModel();
  final TimerService timerService = TimerService();

  @override
  void initState() {
    super.initState();
  }

  void incrementCount() {
    setState(() {
      chantModel.incrementCount();
      if (!chantModel.isTimerRunning) {
        chantModel.isTimerRunning = true;
        timerService.startTimer(onTick: (elapsed) {
          setState(() {
            chantModel.elapsed = elapsed;
            chantModel.masterElapsed = elapsed;
          });
        });
      }
    });
  }

  void reset() {
    setState(() {
      chantModel.reset();
      timerService.resetTimer();
    });
  }

  void toggleTimer() {
    setState(() {
      if (chantModel.isTimerRunning) {
        pauseTimer();
      } else {
        startTimer();
      }
    });
  }

  void startTimer() {
    chantModel.isTimerRunning = true;
    timerService.startTimer(onTick: (elapsed) {
      setState(() {
        chantModel.elapsed = elapsed;
        chantModel.masterElapsed = elapsed;
      });
    });
  }

  void pauseTimer() {
    setState(() {
      chantModel.isTimerRunning = false;
      timerService.stopTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the color scheme based on the current theme (light or dark)
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying elapsed time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: colorScheme.onSurface, // Using theme's text color
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  TimerService.formatDuration(chantModel.elapsed),
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorScheme.onSurface, // Using theme's text color
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Counter display with border color from theme
            CounterDisplay(
              count: chantModel.count,
              onTap: incrementCount,
              borderColor: colorScheme.primary, // Using theme's primary color
            ),

            const SizedBox(height: 20),

            // Chant info buttons with dynamic styling
            ChantInfoButtons(
              malasCount: chantModel.malasCount,
              masterCount: chantModel.masterCount,
              elapsedTime: chantModel.masterElapsed,
            ),

            const SizedBox(height: 20),

            // Chant control buttons
            ChantControlButtons(
              onReset: reset,
              onToggleTimer: toggleTimer,
              isTimerRunning: chantModel.isTimerRunning,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timerService.stopTimer();
    super.dispose();
  }
}
