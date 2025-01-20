import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chants/screens/meditation_session_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Meditation session initializes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeditationSessionScreen(
          title: 'Test Meditation',
          duration: '5 min',
          color: Colors.blue,
        ),
      ),
    );

    expect(find.text('Test Meditation'), findsOneWidget);
    expect(find.text('5:00'), findsOneWidget);
  });

  testWidgets('Play/pause button toggles correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeditationSessionScreen(
          title: 'Test Meditation',
          duration: '5 min',
          color: Colors.blue,
        ),
      ),
    );

    final playPauseButton = find.byIcon(Icons.pause_circle);
    expect(playPauseButton, findsOneWidget);

    await tester.tap(playPauseButton);
    await tester.pump();

    expect(find.byIcon(Icons.play_circle), findsOneWidget);
  });

  testWidgets('Sound toggle button works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeditationSessionScreen(
          title: 'Test Meditation',
          duration: '5 min',
          color: Colors.blue,
        ),
      ),
    );

    final soundButton = find.byIcon(Icons.volume_up);
    expect(soundButton, findsOneWidget);

    await tester.tap(soundButton);
    await tester.pump();

    expect(find.byIcon(Icons.volume_off), findsOneWidget);
  });

  testWidgets('Session completes and shows dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MeditationSessionScreen(
          title: 'Test Meditation',
          duration: '0 min',
          color: Colors.blue,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Session Complete'), findsOneWidget);
    expect(find.text('Congratulations on completing your meditation session!'), findsOneWidget);
  });
} 