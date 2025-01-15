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
        _buildInfoTile(context, "Malas", malasCount.toString()),
        _buildInfoTile(context, "Chants", masterCount.toString()),
        _buildInfoTile(context, "Time", TimerService.formatDuration(elapsedTime)),
      ],
    );
  }

  // Private method to build each tile
  Widget _buildInfoTile(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(2.0), // Reduced padding
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.2), // Using theme color for background
          borderRadius: BorderRadius.circular(19.0), // Rounded corners
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface, // Text color based on theme
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface, // Text color based on theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
