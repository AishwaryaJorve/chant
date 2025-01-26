import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/login_screen.dart';
import 'package:chants/services/database_service.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  testWidgets('Login Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify key UI elements
    expect(find.text('Login'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2)); // Email and Password fields
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('Login Screen Validation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Test empty email validation
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your email'), findsOneWidget);

    // Test invalid email validation
    await tester.enterText(find.byType(TextField).first, 'invalidemail');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Please enter a valid email'), findsOneWidget);
  });
} 