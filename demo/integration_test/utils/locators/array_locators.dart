import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

/// Constructs a scope string from a list of elements (strings for properties, ints for array indices)

Finder findArrayDragHandles(String arrayScope) {
  return find.byWidgetPredicate(
    (widget) {
      final key = widget.key;
      if (key is ValueKey<String>) {
        final value = key.value;
        return value.startsWith('$arrayScope/items/') && value.endsWith('/drag');
      }
      return false;
    },
    description: 'Array drag handles for $arrayScope',
  );
}

Finder findArrayDragHandle(List<dynamic> scope) {
  final path = scopePath(scope);
  return find.byKey(ValueKey('$path/drag'));
}

Finder findArrayAddButton(List<dynamic> scope) {
  final path = scopePath(scope);
  return find.byKey(ValueKey('$path/add'));
}

Finder findArrayRemoveButton(List<dynamic> scope) {
  final path = scopePath(scope);
  return find.byKey(ValueKey('$path/remove'));
}

// for a given scope and list of indexes, expects that the delete buttons are either enabled or disabled based on the provided matcher
void expectDeleteButtonState(WidgetTester tester, List<dynamic> scope, List<int> indexes, Matcher matcher) {
  for (final index in indexes) {
    final deleteButton = findArrayRemoveButton([...scope, index]);
    expect(deleteButton, findsOneWidget);
    expect(tester.widget<FilledButton>(deleteButton).onPressed, matcher);
  }
}
