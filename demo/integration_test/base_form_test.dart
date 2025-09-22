import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_builder.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'data/base.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Helper to check if a Finder is visible (painted and non-zero size)

bool isWidgetCrossFadeVisible(WidgetTester tester, Finder finder) {
  final animatedCrossFade = tester.widget<AnimatedCrossFade>(
    find.ancestor(of: finder, matching: find.byType(AnimatedCrossFade)).first,
  );
  return animatedCrossFade.crossFadeState == CrossFadeState.showFirst;
}

bool isWidgetCrossFadeHidden(WidgetTester tester, Finder finder) {
  final animatedCrossFade = tester.widget<AnimatedCrossFade>(
    find.ancestor(of: finder, matching: find.byType(AnimatedCrossFade)).first,
  );
  return animatedCrossFade.crossFadeState == CrossFadeState.showSecond;
}

/// Checks if a given text field label is rendered as required
bool isTextFieldRequired(WidgetTester tester, String labelText) {
  final labelFinder = find.text(labelText);
  final rowElements = find.ancestor(of: labelFinder, matching: find.byType(Row)).evaluate();
  if (rowElements.isEmpty) return false;
  final outerRow = rowElements.last;

  final childRowFinder = find.descendant(
    of: find.byWidget(outerRow.widget),
    matching: find.byType(Row),
  );
  final childRowElements = childRowFinder.evaluate();
  if (childRowElements.isEmpty) return false;
  final innerRow = childRowElements.first;

  // Check for Semantics widget
  final semanticsFinder = find.descendant(
    of: find.byWidget(innerRow.widget),
    matching: find.byType(Semantics),
  );

  // Check for the asterisk text (it's inside the Semantics widget)
  final asteriskFinder = find.descendant(
    of: find.byWidget(innerRow.widget),
    matching: find.text('*'),
  );

  return semanticsFinder.evaluate().isNotEmpty && asteriskFinder.evaluate().isNotEmpty;
}

Future<void> pumpForm(WidgetTester tester, {dynamic jsonSchema, dynamic? uiSchema}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Flutter JSON Forms Integration Tests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FlutterJsonForm(jsonSchema: jsonSchema, uiSchema: uiSchema),
      ),
    ),
  ));

  await tester.pumpAndSettle();

  // // Wait for initial pump
  // await tester.pump();

  // // Wait for async initialization to complete by checking if skeleton/loading is gone
  // int attempts = 0;
  // const maxAttempts = 50; // 5 seconds timeout

  // while (attempts < maxAttempts) {
  //   await tester.pump(const Duration(milliseconds: 100));

  //   // Check if form is loaded by ensuring no Skeletonizer is in the widget tree
  //   final hasSkeletonizer = find.byType(Skeletonizer).evaluate().isNotEmpty;

  //   if (!hasSkeletonizer) {
  //     break;
  //   }

  //   attempts++;
  // }

  // // Final settle to ensure everything is ready
  // await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Base Form Test', () {
    group('Json Schema Test', () {
      // setUpAll(() async {
      //   await pumpForm(tester, BaseData.jsonSchema);
      // });

      // bool _isPumped = false;

      // Future<void> ensurePumped(WidgetTester tester) async {
      //   if (!_isPumped) {
      //     await pumpForm(tester, jsonSchema: BaseData.jsonSchema);
      //     _isPumped = true;
      //   }
      // }

      Future<void> init(WidgetTester tester) async {
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema);
      }

      testWidgets('Form loads successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(find.text('Registration'), findsOneWidget);
        expect(find.text('A simple registration form example'), findsOneWidget);
      });

      testWidgets('Basic form fields load successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        // field titles get generated from schema titles and property names
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Newsletter Json Title'), findsOneWidget);
        expect(find.text('email'), findsOneWidget);
        expect(find.text('timeMissingInUiSchema'), findsOneWidget);
        // input fields get generated from schema types
        expect(find.byType(FormBuilderTextField), findsNWidgets(2));
        expect(find.byType(FormBuilderSwitch), findsOneWidget);
        expect(find.byType(FormBuilderDateTimePicker), findsOneWidget);
      });

      testWidgets('Default values are set correctly', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        final switchWidget = tester.widget<FormBuilderSwitch>(switchFinder);
        expect(switchWidget.initialValue, isTrue);
      });

      testWidgets('Required fields are marked correctly', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(isTextFieldRequired(tester, 'Name'), isTrue); // required
        expect(isTextFieldRequired(tester, 'Newsletter Json Title'), isFalse); // not required
        expect(isTextFieldRequired(tester, 'email'), isTrue); // required
        expect(isTextFieldRequired(tester, 'timeMissingInUiSchema'), isFalse); // not required
      });
    });

    group('Ui Schema Test', () {
      Future<void> init(WidgetTester tester) async {
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema, uiSchema: BaseData.uiSchema);
      }

      testWidgets('Form loads successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(find.text('Registration'), findsOneWidget);
        expect(find.text('A simple registration form example'), findsOneWidget);
      });

      testWidgets('Basic form fields load successfully', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        // filed titles get generated from schema titles and property names
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Sign up for newsletter'), findsOneWidget);
        expect(find.text('email'), findsOneWidget);
        expect(find.text('elementMissingInUiSchema'), findsNothing); // element missing in ui schema is not shown
        // input fields get generated from schema types
        expect(find.byType(FormBuilderTextField), findsNWidgets(2));
        expect(find.byType(FormBuilderSwitch), findsOneWidget);
        expect(find.byType(FormBuilderDateTimePicker), findsNothing);
      });

      testWidgets('Default values are set correctly', (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        final switchWidget = tester.widget<FormBuilderSwitch>(switchFinder);
        expect(switchWidget.initialValue, isTrue);
      });

      testWidgets('Required fields are marked correctly', (tester) async {
        /// GIVEN
        await pumpForm(tester, jsonSchema: BaseData.jsonSchema, uiSchema: BaseData.uiSchema);

        /// THEN
        expect(isTextFieldRequired(tester, 'Name'), isTrue); // required
        expect(isTextFieldRequired(tester, 'Sign up for newsletter'), isFalse); // not required
        expect(isTextFieldRequired(tester, 'email'), isTrue); // required
      });

      testWidgets("Simple ShowOn Rule is working", (tester) async {
        /// GIVEN
        await init(tester);

        /// THEN
        expect(isWidgetCrossFadeVisible(tester, find.text('email')), isTrue); // hidden

        /// WHEN
        final switchFinder = find.byType(FormBuilderSwitch);
        expect(switchFinder, findsOneWidget);
        await tester.tap(switchFinder);
        await tester.pumpAndSettle();

        /// THEN
        expect(isWidgetCrossFadeHidden(tester, find.text('email')), isTrue); // email is now hidden
      });
    });
  });
}
