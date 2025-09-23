import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common testing utilities for Flutter JSON Forms integration tests

Future<void> pumpForm(WidgetTester tester, {dynamic jsonSchema, dynamic uiSchema}) async {
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
