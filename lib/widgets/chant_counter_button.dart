import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../themes/app_theme.dart';

class CounterDisplay extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const CounterDisplay({
    required this.count,
    required this.onTap,
    Key? key, required Color borderColor,
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
          border: Border.all(
            color: AppTheme.counterBorderColorForMode(context),
            width: 5,
          ),
          color: Colors.transparent,
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color: AppTheme.counterTextColorForMode(context),
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
