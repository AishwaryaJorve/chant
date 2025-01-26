import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/chant_screen.dart';
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

  testWidgets('Chant Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChantScreen()));

    // Verify key UI elements
    expect(find.text('Chanting Session'), findsOneWidget);
    expect(find.text('Tap to Count'), findsOneWidget);
    expect(find.text('Malas'), findsOneWidget);
    expect(find.text('Chants'), findsOneWidget);
  });

  testWidgets('Chant Screen Interaction Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChantScreen()));

    // Test initial state
    expect(find.text('0'), findsOneWidget);

    // Tap to increment count
    await tester.tap(find.text('Tap to Count'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // Test reset functionality
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
} 