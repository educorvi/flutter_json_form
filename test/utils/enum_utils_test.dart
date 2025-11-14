import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';

void main() {
  group('mapEnumValuesToTitles', () {
    test('returns key-value pairs with titles for string values', () {
      final values = ['a', 'b', 'c'];
      final titles = {'a': 'Alpha', 'b': 'Bravo'};
      final result = mapEnumValuesToTitles(values, titles);
      expect(result.length, 3);
      expect(result[0].key, 'a');
      expect(result[0].value, 'Alpha');
      expect(result[1].key, 'b');
      expect(result[1].value, 'Bravo');
      expect(result[2].key, 'c');
      expect(result[2].value, 'c');
    });

    test('returns value as title if no mapping', () {
      final values = ['x', 'y'];
      final result = mapEnumValuesToTitles(values, null);
      expect(result.length, 2);
      expect(result[0].key, 'x');
      expect(result[0].value, 'x');
      expect(result[1].key, 'y');
      expect(result[1].value, 'y');
    });

    test('handles empty values', () {
      final result = mapEnumValuesToTitles([], {'a': 'A'});
      expect(result, isEmpty);
    });

    test('handles numeric enum values', () {
      final values = [1, 2, 3];
      final titles = {'1': 'One', '2': 'Two'};
      final result = mapEnumValuesToTitles(values, titles);
      expect(result.length, 3);
      expect(result[0].key, 1);
      expect(result[0].value, 'One');
      expect(result[1].key, 2);
      expect(result[1].value, 'Two');
      expect(result[2].key, 3);
      expect(result[2].value, '3');
    });

    test('handles object enum values', () {
      final values = [
        {'id': 1, 'name': 'Item 1'},
        {'id': 2, 'name': 'Item 2'},
      ];
      final titles = {'{"id":1,"name":"Item 1"}': 'First Item'};
      final result = mapEnumValuesToTitles(values, titles);
      expect(result.length, 2);
      expect(result[0].key, {'id': 1, 'name': 'Item 1'});
      expect(result[0].value, 'First Item');
      expect(result[1].key, {'id': 2, 'name': 'Item 2'});
      // Second one should use JSON encoding as fallback
      expect(result[1].value, '{"id":2,"name":"Item 2"}');
    });

    test('handles array enum values', () {
      final values = [
        ['a', 'b'],
        ['c', 'd'],
      ];
      final titles = {'["a","b"]': 'First Array'};
      final result = mapEnumValuesToTitles(values, titles);
      expect(result.length, 2);
      expect(result[0].key, ['a', 'b']);
      expect(result[0].value, 'First Array');
      expect(result[1].key, ['c', 'd']);
      expect(result[1].value, '["c","d"]');
    });
  });
}
