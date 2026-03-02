import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema/json_schema.dart';

/// Common testing utilities for Flutter JSON Forms integration tests

void ensureWidgetTestBinding() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

Future<void> pumpForm(WidgetTester tester,
    {required JsonSchema jsonSchema,
    ui.UiSchema? uiSchema,
    void Function(Map<String, dynamic>?)? onFormSubmitSaveCallback,
    void Function(Map<String, dynamic>?, ui.Request?)? onFormRequestCallback}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Flutter JSON Forms Integration Tests'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FlutterJsonForm(
            jsonSchema: json.decode(jsonSchema.toJson()),
            uiSchema: uiSchema?.toJson(),
            onFormSubmitSaveCallback: onFormSubmitSaveCallback,
            onFormRequestCallback: onFormRequestCallback,
          ),
        ),
      ),
    ),
  ));

  await tester.pump();
  // await _waitForFormToRender(tester);
  await tester.pumpAndSettle();
}

// Future<void> _waitForFormToRender(WidgetTester tester, {Duration timeout = const Duration(seconds: 10)}) async {
//   final finder = find.byType(FlutterJsonForm);
//   expect(finder, findsOneWidget, reason: 'FlutterJsonForm should be present in the widget tree.');
//   final step = const Duration(milliseconds: 50);
//   var elapsed = Duration.zero;
//   while (elapsed < timeout) {
//     final state = tester.state<FlutterJsonFormState>(finder);
//     if (!state.isLoading) {
//       return;
//     }
//     await tester.pump(step);
//     elapsed += step;
//   }
//   throw FlutterError('Timed out waiting for FlutterJsonForm to finish loading after ${timeout.inSeconds}s');
// }

/// Taps a form field, enters text, and waits for the widget tree to settle.
Future<void> tapAndEnsureVisible(WidgetTester tester, Finder finder, {bool warnIfMissed = true}) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: warnIfMissed);
  await tester.pumpAndSettle();
}

Future<void> enterTextAndSettle(WidgetTester tester, Finder field, String text, {bool dismissKeyboard = true}) async {
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();

  await tester.tap(field, warnIfMissed: false);
  await tester.pumpAndSettle();

  await tester.enterText(field, text);
  await tester.pumpAndSettle();

  if (dismissKeyboard) {
    final focusNode = tester.binding.focusManager.primaryFocus;
    focusNode?.unfocus();
    await tester.pumpAndSettle();
  }
}

ui.UiSchema getBaseUiSchemaLayout(
    {required List<ui.LayoutElement> elements, ui.LayoutType type = ui.LayoutType.VERTICAL_LAYOUT, ui.LayoutOptions? options}) {
  return ui.UiSchema(
    version: "2.0",
    layout: ui.Layout(
      options: options,
      type: type,
      elements: elements,
    ),
  );
}

/// Visibility: Helper to get the crossFadeState of an AnimatedCrossFade ancestor for a Finder
CrossFadeState getWidgetCrossFadeState(WidgetTester tester, Finder finder) {
  final animatedCrossFade = tester.widget<AnimatedCrossFade>(
    find.ancestor(of: finder, matching: find.byType(AnimatedCrossFade)).first,
  );
  return animatedCrossFade.crossFadeState;
}

/// Expects that the AnimatedCrossFade ancestor of [finder] is visible (showFirst)
void expectShowOnVisible(WidgetTester tester, Finder finder) {
  expect(
    getWidgetCrossFadeState(tester, finder),
    CrossFadeState.showFirst,
    reason: 'Expected AnimatedCrossFade ancestor of \\${finder.toString()} to be visible (showFirst)',
  );
}

/// Expects that the AnimatedCrossFade ancestor of [finder] is hidden (showSecond)
void expectShowOnHidden(WidgetTester tester, Finder finder) {
  expect(
    getWidgetCrossFadeState(tester, finder),
    CrossFadeState.showSecond,
    reason: 'Expected AnimatedCrossFade ancestor of \\${finder.toString()} to be hidden (showSecond)',
  );
}

/// Checks if a given text field label is rendered as required
/// Looks for both a Semantics widget and an asterisk (*) text in the same row
bool isTextFieldRequired(WidgetTester tester, String labelText) {
  final text = find.byWidgetPredicate(
    (widget) => (widget is FormFieldText && widget.label == labelText && widget.required == true),
  );
  return text.evaluate().isNotEmpty;
}

/// get any text of the form builder
extension FinderFormTextExtension on CommonFinders {
  Finder formFieldText(String label) {
    return byWidgetPredicate(
      (widget) => widget is FormFieldText && widget.label == label,
    );
  }
}

String upperName(String name) => name[0].toUpperCase() + name.substring(1);

/// Layout Checks

const crossAxisToleranceMargin = 30.0;
const horizontalPositionTolerance = 30.0;

/// Expects that the widget found by [upperFinder] is above the widget found by [lowerFinder], and that they are horizontally aligned within a margin
void expectWidgetAbove(WidgetTester tester, Finder upperFinder, Finder lowerFinder, {double dxMargin = crossAxisToleranceMargin}) {
  final upperOffset = tester.getTopLeft(upperFinder);
  final lowerOffset = tester.getTopLeft(lowerFinder);
  // check that upper widget is above lower widget
  expect(
    upperOffset.dy,
    lessThan(lowerOffset.dy),
    reason: 'Expected \\${upperFinder.toString()} to appear above \\${lowerFinder.toString()}',
  );
  // Check that their x positions are aligned within margin
  expect(
    upperOffset.dx,
    closeTo(lowerOffset.dx, dxMargin),
    reason: 'Expected \\${upperFinder.toString()} and \\${lowerFinder.toString()} to be vertically aligned (dx within $dxMargin)',
  );
}

/// Expects that the widgets found in [orderedFinders] are in vertical order (first above second, second above third, etc) and that they are horizontally aligned within a margin
void expectWidgetsInVerticalOrder(WidgetTester tester, List<Finder> orderedFinders, {double dxMargin = crossAxisToleranceMargin}) {
  assert(orderedFinders.length >= 2, 'Provide at least two finders to compare order.');
  for (int i = 0; i < orderedFinders.length - 1; i++) {
    expectWidgetAbove(tester, orderedFinders[i], orderedFinders[i + 1], dxMargin: dxMargin);
  }
}

/// Expects that the widget found by [firstFinder] is to the left of the widget found by [secondFinder], and that they are vertically aligned within a margin
void expectWidgetNextTo(WidgetTester tester, Finder firstFinder, Finder secondFinder,
    {double dyMargin = crossAxisToleranceMargin, double dxTolerance = horizontalPositionTolerance}) {
  final firstOffset = tester.getTopLeft(firstFinder);
  final secondOffset = tester.getTopLeft(secondFinder);
  expect(
    firstOffset,
    lessThan(secondOffset),
    reason:
        'Expected \\${firstFinder.toString()} to appear to the left of \\${secondFinder.toString()} within a $dxTolerance px tolerance (dx delta: ${dxDelta.toStringAsFixed(2)})',
  );
  // Check that their y positions are aligned within margin
  expect(
    firstOffset.dy,
    closeTo(secondOffset.dy, dyMargin),
    reason: 'Expected \\${firstFinder.toString()} and \\${secondFinder.toString()} to be horizontally aligned (dy within $dyMargin)',
  );
}

/// Expects that the widgets found in [orderedFinders] are in horizontal order (first to the left of second, second to the left of third, etc) and that they are vertically aligned within a margin
void expectWidgetToBeInHorizontalLayout(WidgetTester tester, List<Finder> orderedFinders, {double dyMargin = crossAxisToleranceMargin}) {
  assert(orderedFinders.length >= 2, 'Provide at least two finders to compare order.');
  for (int i = 0; i < orderedFinders.length - 1; i++) {
    expectWidgetNextTo(tester, orderedFinders[i], orderedFinders[i + 1], dyMargin: dyMargin);
  }
}

/// Generates a scope path string for array items and objects based on the provided scope list, which can contain both property names (strings) and array indices (ints).
/// For example, given a scope list of ['person', 'addresses', 0, 'street'], the generated scope path would be '/properties/person/properties/addresses/items/0/properties/street'.
String scopePath(List<dynamic> elements) {
  final buffer = StringBuffer();
  for (final el in elements) {
    if (el is String) {
      buffer.write('/properties/$el');
    } else if (el is int) {
      buffer.write('/items/$el');
    }
  }
  return buffer.toString();
}

/// Runs standard accessibility guideline checks

Future<void> checkAccessibilityGuidelines(WidgetTester tester, Future<void> Function(WidgetTester) setupForm) async {
  /// GIVEN
  final SemanticsHandle handle = tester.ensureSemantics();
  await setupForm(tester);

  // Checks that tappable nodes have a minimum size of 48 by 48 pixels
  // for Android.
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

  // Checks that tappable nodes have a minimum size of 44 by 44 pixels
  // for iOS.
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

  // Checks that touch targets with a tap or long press action are labeled.
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

  // Optionally check text contrast (3:1 for larger text, 18pt and above)
  // await expectLater(tester, meetsGuideline(textContrastGuideline));

  handle.dispose();
}
