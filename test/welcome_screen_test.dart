import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/welcome_screen.dart';
import 'package:chants/screens/login_screen.dart';
import 'package:chants/screens/signup_screen.dart';

void main() {
  testWidgets('Welcome Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Verify key UI elements
    expect(find.text('Welcome to Meditation'), findsOneWidget);
    expect(find.text('Start your journey to inner peace'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Already have an account? Login'), findsOneWidget);
    expect(find.byIcon(Icons.self_improvement), findsOneWidget);
  });

  testWidgets('Welcome Screen Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Test Sign Up button navigation
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);

    // Test Login button navigation
    await tester.tap(find.text('Already have an account? Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
} 