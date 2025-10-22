import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';

void main() {
  group('mapEnumValuesToTitles', () {
    test('returns key-value pairs with titles', () {
      final values = ['a', 'b', 'c'];
      final titles = {'a': 'Alpha', 'b': 'Bravo'};
      final result = mapEnumValuesToTitles(values, titles);
      expect(result, [
        MapEntry('a', 'Alpha'),
        MapEntry('b', 'Bravo'),
        MapEntry('c', 'c'),
      ]);
    });

    test('returns value as title if no mapping', () {
      final values = ['x', 'y'];
      final result = mapEnumValuesToTitles(values, null);
      expect(result, [
        MapEntry('x', 'x'),
        MapEntry('y', 'y'),
      ]);
    });

    test('handles empty values', () {
      final result = mapEnumValuesToTitles([], {'a': 'A'});
      expect(result, isEmpty);
    });
  });
}
