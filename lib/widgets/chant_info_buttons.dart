// lib/widgets/chant_info_display.dart
import 'package:flutter/material.dart';
import '../services/timer_service.dart';

class ChantInfoButtons extends StatelessWidget {
  final int malasCount;
  final int masterCount;
  final Duration elapsedTime;

  const ChantInfoButtons({
    super.key,
    required this.malasCount,
    required this.masterCount,
    required this.elapsedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoTile("Malas", malasCount.toString()),
        _buildInfoTile("Chants", masterCount.toString()),
        _buildInfoTile("Time", TimerService.formatDuration(elapsedTime)),
      ],
    );
  }

  // Private method to build each tile
  Widget _buildInfoTile(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(2.0), // Reduced padding
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 208, 161, 193), // Button background color
          borderRadius: BorderRadius.circular(19.0), // Rounded corners
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black), // Reduced font size
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16, // Reduced font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
