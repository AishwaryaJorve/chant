import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chants/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Performance Tests', () {
    testWidgets('App startup time', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle();

      stopwatch.stop();
      
      // Ensure app starts within 2 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('Chant screen performance', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to chant screen
      await tester.tap(find.text('Chants'));
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();
      
      // Perform multiple taps
      for (int i = 0; i < 100; i++) {
        await tester.tap(find.text('Tap to Count'));
        await tester.pump();
      }

      stopwatch.stop();
      
      // Ensure multiple taps complete quickly
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
} 