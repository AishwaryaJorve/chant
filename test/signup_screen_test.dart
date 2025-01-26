import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/signup_screen.dart';
import 'package:chants/services/database_service.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  testWidgets('Signup Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

    // Verify key UI elements
    expect(find.text('Sign Up'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(3)); // Name, Email, Password
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('Signup Screen Validation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

    // Test empty fields validation
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);

    // Test password length validation
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
} 