import 'package:chants/screens/chant_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // Implement login logic here

    // Add your login validation and storage logic
  }

  @override
  Widget build(BuildContext context) {
    // Get the current color scheme based on the theme mode (light/dark)
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary, // Primary color from the theme
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                style: TextStyle(color: colorScheme.onSurface), // Dynamic text color
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: colorScheme.onSurface), // Dynamic label color
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.1), // Lightened background for input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                style: TextStyle(color: colorScheme.onSurface), // Dynamic text color
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: colorScheme.onSurface), // Dynamic label color
                  filled: true,
                  fillColor: colorScheme.surface.withOpacity(0.1), // Lightened background for input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChantScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary, // Dynamic button color
                  foregroundColor: colorScheme.onPrimary, // Dynamic button text color
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 50.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
