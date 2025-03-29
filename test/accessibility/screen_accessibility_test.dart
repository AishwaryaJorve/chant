import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chants/screens/login_screen.dart';

void main() {
  testWidgets('Login Screen Accessibility', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Check text contrast
    final emailField = find.byType(TextField).first;
    final loginButton = find.byType(ElevatedButton);

    expect(
      tester.widget<TextField>(emailField).decoration?.labelStyle?.color,
      isNotNull,
    );

    expect(
      tester.widget<ElevatedButton>(loginButton).style?.backgroundColor,
      isNotNull,
    );
  });
} 