import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms_demo/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDemoApp();
  });

  group('Flutter Json Forms Demo App', () {
    testWidgets('Form selector dropdown works and can load Showcase Form', (WidgetTester tester) async {
      // GIVEN: the demo app is loaded
      await tester.pumpWidget(const FlutterJsonFormsDemo());
      await tester.pumpAndSettle();
      // And the form selector dropdown is present
      final dropdownFinder = find.byType(DropdownMenu<FormFile>);
      expect(dropdownFinder, findsOneWidget);

      // WHEN: Open dropdown and select the "Showcase"
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      expect(find.text('Showcase'), findsWidgets);
      await tester.tap(find.text('Showcase').last);
      await tester.pumpAndSettle();

      // THEN: Check that "Showcase" is present as an option in the dropdown
      final showcaseOptionFinder = find.text('Showcase Form');
      expect(showcaseOptionFinder, findsOneWidget);
    });
  });
}
