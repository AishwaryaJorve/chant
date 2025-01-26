import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/profile_screen.dart';
import 'package:chants/services/database_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'userId': 1,
      'isLoggedIn': true,
    });
  });

  testWidgets('Profile Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    // Verify key UI elements
    expect(find.text('Your Stats'), findsOneWidget);
    expect(find.text('Total Time'), findsOneWidget);
    expect(find.text('Total Malas'), findsOneWidget);
    expect(find.text('Sessions Completed'), findsOneWidget);
  });

  testWidgets('Profile Screen Settings Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    // Test Account Settings navigation
    await tester.tap(find.text('Account Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Account Settings'), findsOneWidget);

    // Test Help & Support navigation
    await tester.tap(find.text('Help & Support'));
    await tester.pumpAndSettle();
    expect(find.text('Help & Support'), findsOneWidget);
  });
} 