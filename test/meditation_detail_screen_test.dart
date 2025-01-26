import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/meditation_detail_screen.dart';
import 'package:chants/screens/meditation_session_screen.dart';

void main() {
  testWidgets('Meditation Detail Screen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MeditationDetailScreen(
          title: 'Test Meditation',
          duration: '10 min',
          icon: Icons.mediation,
          color: Colors.blue,
        ),
      ),
    );

    // Verify key UI elements
    expect(find.text('Test Meditation'), findsOneWidget);
    expect(find.text('10 min'), findsOneWidget);
    expect(find.text('About this meditation'), findsOneWidget);
    expect(find.text('Start Meditation'), findsOneWidget);
  });

  testWidgets('Meditation Detail Screen Navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MeditationDetailScreen(
          title: 'Test Meditation',
          duration: '10 min',
          icon: Icons.mediation,
          color: Colors.blue,
        ),
      ),
    );

    // Test Start Meditation button navigation
    await tester.tap(find.text('Start Meditation'));
    await tester.pumpAndSettle();
    expect(find.byType(MeditationSessionScreen), findsOneWidget);
  });
} 