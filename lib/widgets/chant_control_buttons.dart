import 'package:flutter/material.dart';

class ChantControlButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onToggleTimer;
  final bool isTimerRunning;

  const ChantControlButtons({
    super.key,
    required this.onReset,
    required this.onToggleTimer,
    required this.isTimerRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Reset Counter Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onReset,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF171717),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white.withOpacity(0.12);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white.withOpacity(0.08);
                  }
                  return null;
                }),
              ),
              child: const Text(
                'Reset Counter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Play/Pause Timer Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onToggleTimer,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF171717),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white.withOpacity(0.12);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white.withOpacity(0.08);
                  }
                  return null;
                }),
              ),
              child: Text(
                isTimerRunning ? 'Pause Timer' : 'Play Timer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
