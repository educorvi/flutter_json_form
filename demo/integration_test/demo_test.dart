import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms_demo/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flutter Json Forms Demo App', () {
    testWidgets('Showcase is present in the form selector dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Find the dropdown menu
      final dropdownFinder = find.byType(DropdownMenu<FormFile>);
      expect(dropdownFinder, findsOneWidget);

      // Tap to open the dropdown
      await tester.tap(dropdownFinder);
      await tester.pump();

      // Now check that "Showcase" is present as an option in the dropdown
      final showcaseOptionFinder = find.text('Showcase').last;
      expect(showcaseOptionFinder, findsOneWidget);
    });

    testWidgets('Form selector dropdown works and can select another form', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Find the form selector dropdown
      final dropdownFinder = find.byType(DropdownMenu<FormFile>);
      expect(dropdownFinder, findsOneWidget);

      // Tap to open the dropdown
      await tester.tap(dropdownFinder);
      await tester.pump();

      // Select another form (e.g., 'Reproduce')
      expect(find.text('Reproduce'), findsWidgets);
      await tester.tap(find.text('Reproduce').last);
      await tester.pump();
      // The form should now show 'Reproduce'
      expect(find.text('Reproduce'), findsWidgets);
    });

    testWidgets('Custom file upload buttons for JSON and UI schema are present', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Check for custom file upload buttons
      expect(find.text('JSON Schema'), findsOneWidget);
      expect(find.text('UI Schema'), findsOneWidget);
    });

    // testWidgets('Custom file upload buttons can be tapped', (WidgetTester tester) async {
    //   await tester.pumpWidget(const MyApp());
    //   // Simulate tap on JSON Schema upload button
    //   await tester.tap(find.text('JSON Schema'));
    //   await tester.pumpAndSettle();
    //   // Simulate tap on UI Schema upload button
    //   await tester.tap(find.text('UI Schema'));
    //   await tester.pumpAndSettle();
    //   // No crash expected
    // });
  });
}
