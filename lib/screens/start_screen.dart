import 'package:chants/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chants/models/app_theme.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/chant7.png',
              color: colorScheme.primary, // Primary color for image overlay
              width: 300,
            ),
            const SizedBox(height: 100),
            Text(
              "Spiritual Growth",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 24,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onPrimary, // Button color
              ),
              icon: const Icon(Icons.arrow_right_alt_outlined),
              label: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
