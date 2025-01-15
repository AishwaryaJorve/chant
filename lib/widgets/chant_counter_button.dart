import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const CounterDisplay({
    required this.count,
    required this.onTap,
    super.key, 
    required Color borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.7), // Light or dark border color based on theme
            width: 5,
          ),
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color: colorScheme.onSurface, // Adapts text color based on theme
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
