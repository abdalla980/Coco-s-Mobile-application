import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cocos_mobile_application/features/onboarding/questions/question_1.dart';

void main() {
  group('Question1 Widget Tests', () {
    testWidgets('renders with correct title and progress', (
      WidgetTester tester,
    ) async {
      // Build the widget
      await tester.pumpWidget(const MaterialApp(home: Question1()));

      // Verify title is displayed
      expect(find.text("Let's Start.."), findsOneWidget);

      // Verify question text is displayed
      expect(find.text("What's your business name?"), findsOneWidget);

      // Verify progress indicator is present
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('text field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Question1()));

      // Find the text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter text
      await tester.enterText(textField, 'My Awesome Business');
      await tester.pump();

      // Verify text was entered
      expect(find.text('My Awesome Business'), findsOneWidget);
    });

    testWidgets('shows error when trying to proceed with empty input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: Question1()));

      // Find and tap the Next button
      final nextButton = find.widgetWithText(FloatingActionButton, 'Next');
      expect(nextButton, findsOneWidget);

      await tester.tap(nextButton);
      await tester.pump();

      // Verify snackbar appears
      expect(find.text('Please enter your business name'), findsOneWidget);
    });

    testWidgets('Next button is enabled when text is entered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: Question1()));

      // Enter text in the field
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Test Business');
      await tester.pump();

      // Find the Next button
      final nextButton = find.widgetWithText(FloatingActionButton, 'Next');
      expect(nextButton, findsOneWidget);

      // Verify button exists and can be tapped (this would navigate, but we're just testing it's enabled)
      final button = tester.widget<FloatingActionButton>(nextButton);
      expect(button.onPressed, isNotNull);
    });
  });
}
