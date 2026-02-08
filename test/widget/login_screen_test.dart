import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cocos_mobile_application/features/auth/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('displays email and password fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.byType(TextField), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('displays login button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });
  });
}
