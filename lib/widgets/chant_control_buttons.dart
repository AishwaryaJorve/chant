// lib/widgets/chant_control_buttons.dart
import 'package:flutter/material.dart';
import '../models/chant_model.dart';

class ChantControlButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onToggleTimer;
  final bool isTimerRunning;

  const ChantControlButtons({
    Key? key,
    required this.onReset,
    required this.onToggleTimer,
    required this.isTimerRunning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Reset Counter Button
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onReset,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: ChantModel.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reset Counter',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Space between the buttons

        // Play/Pause Timer Button
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onToggleTimer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: ChantModel.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isTimerRunning ? 'Pause Timer' : 'Play Timer',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
