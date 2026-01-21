import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/process_form_values.dart';
import 'package:flutter_json_forms/src/utils/data/list_item.dart';

class DummyListItem implements ListItem {
  @override
  dynamic value;
  @override
  int get id => 0;
  DummyListItem(this.value);
}

void main() {
  group('_extractListItemValue', () {
    test('unwraps ListItem recursively', () {
      final item = DummyListItem(DummyListItem(42));
      expect(extractListItemValue(item), 42);
    });
    test('unwraps List of ListItem', () {
      final items = [DummyListItem(1), DummyListItem(2)];
      expect(extractListItemValue(items), [1, 2]);
    });
    test('unwraps Map of ListItem', () {
      final map = {'a': DummyListItem('x'), 'b': DummyListItem('y')};
      expect(extractListItemValue(map), {'a': 'x', 'b': 'y'});
    });
    test('serializes DateTime', () {
      final dt = DateTime(2023, 1, 2, 3, 4, 5);
      expect(extractListItemValue(dt), dt.toIso8601String());
    });
    test('returns primitives unchanged', () {
      expect(extractListItemValue(123), 123);
      expect(extractListItemValue('abc'), 'abc');
      expect(extractListItemValue(null), null);
    });
  });

  group('processFormValues', () {
    test('flattens nested object keys', () {
      final input = {
        '/properties/person/properties/name': 'Alice',
        '/properties/person/properties/age': 30,
      };
      expect(processFormValues(input), {
        'person': {'name': 'Alice', 'age': 30},
      });
    });
    test('handles arrays and indices', () {
      final input = {
        '/properties/tags/0': 'tag1',
        '/properties/tags/1': 'tag2',
      };
      expect(processFormValues(input), {
        'tags': ['tag1', 'tag2'],
      });
    });
    test('unwraps ListItem and DateTime', () {
      final dt = DateTime(2023, 1, 2);
      final input = {
        '/properties/created': DummyListItem(dt),
      };
      expect(processFormValues(input), {
        'created': dt.toIso8601String(),
      });
    });
    test('skips null values', () {
      final input = {
        '/properties/a': null,
        '/properties/b': 1,
      };
      expect(processFormValues(input), {'b': 1});
    });
    test('handles deeply nested objects and arrays', () {
      final input = {
        '/properties/a/properties/b/0': 'x',
        '/properties/a/properties/b/1': 'y',
        '/properties/a/properties/c': 42,
      };
      expect(processFormValues(input), {
        'a': {
          'b': ['x', 'y'],
          'c': 42,
        },
      });
    });
  });
}
