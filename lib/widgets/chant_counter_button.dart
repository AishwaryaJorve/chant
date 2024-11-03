// lib/widgets/counter_display.dart
import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  final Color borderColor;

  const CounterDisplay({
    required this.count,
    required this.onTap,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 5),
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
}
