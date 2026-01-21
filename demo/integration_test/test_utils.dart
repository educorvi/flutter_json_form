import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';

/// Common testing utilities for Flutter JSON Forms integration tests

Future<void> pumpForm(WidgetTester tester, {dynamic jsonSchema, dynamic uiSchema}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Flutter JSON Forms Integration Tests'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FlutterJsonForm(jsonSchema: jsonSchema, uiSchema: uiSchema),
        ),
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

/// Helper to check if a Finder is visible in an AnimatedCrossFade widget
bool isWidgetCrossFadeVisible(WidgetTester tester, Finder finder) {
  final animatedCrossFade = tester.widget<AnimatedCrossFade>(
    find.ancestor(of: finder, matching: find.byType(AnimatedCrossFade)).first,
  );
  return animatedCrossFade.crossFadeState == CrossFadeState.showFirst;
}

/// Helper to check if a Finder is hidden in an AnimatedCrossFade widget
bool isWidgetCrossFadeHidden(WidgetTester tester, Finder finder) {
  final animatedCrossFade = tester.widget<AnimatedCrossFade>(
    find.ancestor(of: finder, matching: find.byType(AnimatedCrossFade)).first,
  );
  return animatedCrossFade.crossFadeState == CrossFadeState.showSecond;
}

/// Checks if a given text field label is rendered as required
/// Looks for both a Semantics widget and an asterisk (*) text in the same row
bool isTextFieldRequired(WidgetTester tester, String labelText) {
  final text = find.byWidgetPredicate(
    (widget) => (widget is FormFieldText && widget.label == labelText && widget.required == true),
  );
  return text.evaluate().isNotEmpty;
}

extension FinderFormTextExtension on CommonFinders {
  Finder formFieldText(String label) {
    return byWidgetPredicate(
      (widget) => widget is FormFieldText && widget.label == label,
    );
  }
}

// Finder findLabelText(String text) {
//   return find.byWidgetPredicate(
//     (widget) => (widget is FormFieldText && widget.label == text),
//   );
// }

/// Runs standard accessibility guidelines checks
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
