import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/login_screen.dart';

void main() {
  testWidgets('Login Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify key UI elements
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Login Screen Validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap login without entering credentials
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify validation messages
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
} 