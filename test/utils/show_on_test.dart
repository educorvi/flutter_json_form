import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/utils/show_on.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

ui.ShowOnProperty makeShowOn(String? id) => ui.ShowOnProperty(id: id);

ui.DescendantControlOverrides makeOverride(String? id, [Map<String, ui.DescendantControlOverrides>? nested]) => ui.DescendantControlOverrides(
      showOn: id != null ? makeShowOn(id) : null,
      options: nested != null ? ui.Options(formattingOptions: ui.ControlFormattingOptions(descendantControlOverrides: nested)) : null,
    );

ui.LayoutElement makeElement(String? id, {List<ui.LayoutElement>? elements, Map<String, ui.DescendantControlOverrides>? overrides}) =>
    (elements != null)
        ? ui.Layout(
            type: ui.LayoutType.VERTICAL_LAYOUT,
            showOn: id != null ? makeShowOn(id) : null,
            elements: elements,
          )
        : ui.Control(
            type: ui.ControlType.CONTROL,
            scope: id != null ? '/properties/$id' : "",
            showOn: id != null ? makeShowOn(id) : null,
            options: overrides != null ? ui.Options(formattingOptions: ui.ControlFormattingOptions(descendantControlOverrides: overrides)) : null,
          );

void main() {
  group('collectDescendantRitaRules', () {
    test('empty map returns empty list', () {
      final rules = collectDescendantRitaRules({});
      expect(rules, isEmpty);
    });

    test('collects rules from flat map', () {
      final overrides = {
        'a': makeOverride('id1'),
        'b': makeOverride('id2'),
      };
      final rules = collectDescendantRitaRules(overrides);
      expect(rules.map((r) => r.id), containsAll(['id1', 'id2']));
    });
    test('collects rules from nested overrides', () {
      final nested = {
        'c': makeOverride('id3'),
      };
      final overrides = {
        'a': makeOverride('id1', nested),
      };
      final rules = collectDescendantRitaRules(overrides);
      expect(rules.map((r) => r.id), containsAll(['id1', 'id3']));
    });
    test('skips null showOn and null id', () {
      final overrides = {
        'a': makeOverride(null),
        'b': makeOverride(null),
      };
      final rules = collectDescendantRitaRules(overrides);
      expect(rules, isEmpty);
    });
  });

  group('collectRitaRules', () {
    test('empty list returns empty list', () {
      final rules = collectRitaRules([]);
      expect(rules, isEmpty);
    });

    test('collects rules from elements and nested elements', () {
      final nested = makeElement('id2');
      final elements = [
        makeElement('id1', elements: [nested]),
      ];
      final rules = collectRitaRules(elements);
      expect(rules.map((r) => r.id), containsAll(['id1', 'id2']));
    });
    test('collects rules from descendantControlOverrides', () {
      final overrides = {
        'a': makeOverride('id3'),
      };
      final element = makeElement('id1', overrides: overrides);
      final rules = collectRitaRules([element]);
      expect(rules.map((r) => r.id), containsAll(['id1', 'id3']));
    });
    test('skips null showOn and null id', () {
      final elements = [
        makeElement(null),
        makeElement(null),
      ];
      final rules = collectRitaRules(elements);
      expect(rules, isEmpty);
    });
  });

  group('evaluateCondition', () {
    group('EQUALS', () {
      test('EQUALS returns true for equal', () {
        expect(evaluateCondition(ui.ShowOnFunctionType.EQUALS, 1, 1), isTrue);
        expect(evaluateCondition(ui.ShowOnFunctionType.EQUALS, 'a', 'a'), isTrue);
      });
      test('EQUALS returns false for not equal', () {
        expect(evaluateCondition(ui.ShowOnFunctionType.EQUALS, 1, 2), isFalse);
        expect(evaluateCondition(ui.ShowOnFunctionType.EQUALS, 1, 'a'), isFalse);
        expect(evaluateCondition(ui.ShowOnFunctionType.EQUALS, 'a', 'b'), isFalse);
      });
    });

    group('NOT_EQUALS', () {
      test('NOT_EQUALS returns true for not equal', () {
        expect(evaluateCondition(ui.ShowOnFunctionType.NOT_EQUALS, 1, 2), isTrue);
        expect(evaluateCondition(ui.ShowOnFunctionType.NOT_EQUALS, 1, 'a'), isTrue);
        expect(evaluateCondition(ui.ShowOnFunctionType.NOT_EQUALS, 'a', 'b'), isTrue);
      });
      test('NOT_EQUALS returns false for equal', () {
        expect(evaluateCondition(ui.ShowOnFunctionType.NOT_EQUALS, 1, 1), isFalse);
        expect(evaluateCondition(ui.ShowOnFunctionType.NOT_EQUALS, 'a', 'a'), isFalse);
      });
    });
    test('GREATER returns true/false', () {
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER, 2, 1), isTrue);
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER, 1, 1), isFalse);
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER, 1, 2), isFalse);
    });
    test('SMALLER returns true/false', () {
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER, 1, 2), isTrue);
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER, 1, 1), isFalse);
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER, 2, 1), isFalse);
    });
    test('GREATER_OR_EQUAL returns true/false', () {
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER_OR_EQUAL, 2, 1), isTrue);
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER_OR_EQUAL, 1, 1), isTrue);
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER_OR_EQUAL, 1, 2), isFalse);
    });
    test('SMALLER_OR_EQUAL returns true/false', () {
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER_OR_EQUAL, 1, 2), isTrue);
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER_OR_EQUAL, 2, 2), isTrue);
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER_OR_EQUAL, 2, 1), isFalse);
    });
    test('null operator returns false', () {
      expect(evaluateCondition(null, 1, 1), isFalse);
    });
    test('type error returns false', () {
      expect(evaluateCondition(ui.ShowOnFunctionType.GREATER, 'a', 1), isFalse);
      expect(evaluateCondition(ui.ShowOnFunctionType.SMALLER, 1, 'a'), isFalse);
    });
  });
}
