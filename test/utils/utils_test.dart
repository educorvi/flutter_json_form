import 'package:flutter_json_forms/src/widgets/data/list_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

void main() {
  group('generateDefaultUISchema', () {
    test('generates UI schema for flat properties', () {
      final Map<String, dynamic> jsonSchema = {
        'name': {'type': 'string'},
        'age': {'type': 'integer'},
      };
      final uiSchema = generateDefaultUISchema(jsonSchema);
      expect(uiSchema.version, equals('2.0'));
      expect(uiSchema.layout.type, equals(ui.LayoutType.VERTICAL_LAYOUT));
      expect(uiSchema.layout.elements.length, equals(2));
      expect(uiSchema.layout.elements[0].type, equals(ui.LayoutElementType.CONTROL));
      expect(uiSchema.layout.elements[0].scope, equals('/properties/name'));
      expect(uiSchema.layout.elements[1].type, equals(ui.LayoutElementType.CONTROL));
      expect(uiSchema.layout.elements[1].scope, equals('/properties/age'));
    });

    test('generates UI schema for nested object properties (flat only)', () {
      final Map<String, dynamic> jsonSchema = {
        'person': {
          'type': 'object',
          'properties': {
            'firstName': {'type': 'string'},
            'lastName': {'type': 'string'},
          }
        },
        'age': {'type': 'integer'},
      };
      final uiSchema = generateDefaultUISchema(jsonSchema);
      // Only top-level controls are generated (current implementation)
      expect(uiSchema.layout.elements.length, equals(2));
      expect(uiSchema.layout.elements[0].type, equals(ui.LayoutElementType.CONTROL));
      expect(uiSchema.layout.elements[0].scope, equals('/properties/person'));
      expect(uiSchema.layout.elements[1].type, equals(ui.LayoutElementType.CONTROL));
      expect(uiSchema.layout.elements[1].scope, equals('/properties/age'));
    });

    test('handles empty schema', () {
      final Map<String, dynamic> jsonSchema = {};
      final uiSchema = generateDefaultUISchema(jsonSchema);
      expect(uiSchema.layout.elements, isEmpty);
    });

    test('handles single property', () {
      final Map<String, dynamic> jsonSchema = {
        'foo': {'type': 'string'},
      };
      final uiSchema = generateDefaultUISchema(jsonSchema);
      expect(uiSchema.layout.elements.length, equals(1));
      expect(uiSchema.layout.elements[0].scope, equals('/properties/foo'));
    });
  });

  group('toEncodable', () {
    test('encodes DateTime to ISO8601 string', () {
      final dt = DateTime(2025, 9, 18, 12, 34, 56);
      final encoded = toEncodable(dt);
      expect(encoded, equals(dt.toIso8601String()));
    });

    test('encodes Map recursively', () {
      final dt = DateTime(2025, 9, 18, 12, 34, 56);
      final map = {
        'date': dt,
        'value': 42,
        'nested': {'inner': dt},
      };
      final encoded = toEncodable(map);
      expect(encoded['date'], equals(dt.toIso8601String()));
      expect(encoded['value'], equals(42));
      expect(encoded['nested']['inner'], equals(dt.toIso8601String()));
    });

    test('encodes List recursively', () {
      final dt = DateTime(2025, 9, 18, 12, 34, 56);
      final list = [
        dt,
        42,
        [dt]
      ];
      final encoded = toEncodable(list);
      expect(encoded[0], equals(dt.toIso8601String()));
      expect(encoded[1], equals(42));
      expect(encoded[2][0], equals(dt.toIso8601String()));
    });

    test('returns primitives unchanged', () {
      expect(toEncodable(42), equals(42));
      expect(toEncodable('foo'), equals('foo'));
      expect(toEncodable(true), equals(true));
      expect(toEncodable(null), isNull);
    });
  });

  group('getPathWithProperties', () {
    test('converts flat path to properties-prefixed path', () {
      expect(getPathWithProperties('foo/bar'), equals('/properties/foo/properties/bar'));
      expect(getPathWithProperties('foo/bar/baz'), equals('/properties/foo/properties/bar/properties/baz'));
    });

    test('removes # prefix', () {
      expect(getPathWithProperties('#/foo/bar'), equals('/properties/foo/properties/bar'));
      expect(getPathWithProperties('#foo/bar'), equals('/properties/foo/properties/bar'));
    });

    test('returns empty string unchanged', () {
      expect(getPathWithProperties(''), equals(''));
    });

    test('returns already properties-prefixed path unchanged', () {
      expect(getPathWithProperties('/properties/foo'), equals('/properties/foo'));
      expect(getPathWithProperties('/properties/foo/properties/bar'), equals('/properties/foo/properties/bar'));
    });

    test('handles single segment', () {
      expect(getPathWithProperties('foo'), equals('/properties/foo'));
    });

    test('handle element with name properties', () {
      expect(getPathWithProperties('properties'), equals('/properties/properties'));
    });

    // test('handles path with leading slash', () {
    //   expect(getPathWithProperties('/foo/bar'), equals('/properties//foo/properties/bar'));
    // });
  });

  group('getObjectFromJson', () {
    JsonSchema getSimpleSchema() {
      return JsonSchema.create({
        'type': 'object',
        'properties': {
          'foo': {'type': 'string'},
        },
      });
    }

    test('returns root schema for empty path', () {
      final result = getObjectFromJson(getSimpleSchema(), '');
      expect(result, equals(getSimpleSchema()));
    });

    test('returns property schema for simple path', () {
      final result = getObjectFromJson(getSimpleSchema(), '/properties/foo');
      expect(result?.type, equals(SchemaType.string));
    });

    test('returns nested property schema', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'bar': {
            'type': 'object',
            'properties': {
              'baz': {'type': 'integer'},
            },
          },
        },
      });
      final result = getObjectFromJson(schema, '/properties/bar/properties/baz');
      expect(result?.type, equals(SchemaType.integer));
    });

    test('returns null for invalid path', () {
      final result = getObjectFromJson(getSimpleSchema(), '/properties/doesNotExist');
      expect(result, isNull);
    });
  });

  group('initShowOnDependencies', () {
    test('returns empty map for null properties', () {
      final result = initShowOnDependencies(null, null);
      expect(result, equals({}));
    });

    test('handles simple string property with no formData', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'foo': {'type': 'string'},
        },
      });
      final result = initShowOnDependencies(schema.properties, null);
      expect(result, equals({'/properties/foo': null}));
    });

    test('handles simple string property with formData', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'foo': {'type': 'string'},
        },
      });
      final result = initShowOnDependencies(schema.properties, {'foo': 'bar'});
      expect(result, equals({'/properties/foo': 'bar'}));
    });

    // test('handles array property with minItems', () {
    //   final schema = JsonSchema.create({
    //     'type': 'object',
    //     'properties': {
    //       'arr': {'type': 'array', 'minItems': 2},
    //     },
    //   });
    //   final result = initShowOnDependencies(schema.properties, null);
    //   expect(result['/properties/arr'], equals([null, null]));
    // });

    test('handles nested object property', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'bar': {
            'type': 'object',
            'properties': {
              'baz': {'type': 'integer'},
            },
          },
        },
      });
      final result = initShowOnDependencies(schema.properties, null);
      expect(result['/properties/bar/properties/baz'], isNull);
    });

    test('handles nested object property with formData', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'bar': {
            'type': 'object',
            'properties': {
              'baz': {'type': 'integer'},
            },
          },
        },
      });
      final result = initShowOnDependencies(schema.properties, {
        'bar': {'baz': 42}
      });
      expect(result['/properties/bar/properties/baz'], equals(42));
    });

    test('handles defaultValue for property', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'foo': {'type': 'string', 'default': 'defaultVal'},
        },
      });
      final result = initShowOnDependencies(schema.properties, null);
      expect(result['/properties/foo'], equals('defaultVal'));
    });

    test('prioritizes formData over defaultValue', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'foo': {'type': 'string', 'default': 'defaultVal'},
        },
      });
      final result = initShowOnDependencies(schema.properties, {'foo': 'formDataVal'});
      expect(result['/properties/foo'], equals('formDataVal'));
    });

    test('handles date-time format with \$now', () {
      final schema = JsonSchema.create({
        'type': 'object',
        'properties': {
          'dt': {'type': 'string', 'format': 'date-time'},
        },
      });
      final result = initShowOnDependencies(schema.properties, {'dt': '\$now'});
      expect(result['/properties/dt'], isA<DateTime>());
    });
  });

  // group('resetShowOnDependencies', () {
  //   test('resets flat map values to null', () {
  //     final Map<String, dynamic> deps = {'/properties/foo': 'bar', '/properties/baz': 42};
  //     resetShowOnDependencies(deps);
  //     expect(deps['/properties/foo'], isNull);
  //     expect(deps['/properties/baz'], isNull);
  //   });

  //   test('recursively resets nested maps', () {
  //     final Map<String, dynamic> deps = {
  //       '/properties/foo': Map<String, dynamic>.from({'/properties/bar': 'baz'}),
  //       '/properties/qux': 123,
  //     };
  //     resetShowOnDependencies(deps);
  //     expect((deps['/properties/foo'] as Map<String, dynamic>)['/properties/bar'], isNull);
  //     expect(deps['/properties/qux'], isNull);
  //   });

  //   test('resets ListItem values in lists', () {
  //     final Map<String, dynamic> deps = {
  //       '/properties/list': [ListItem(id: 0, value: 'a'), ListItem(id: 1, value: 'b')],
  //     };
  //     resetShowOnDependencies(deps);
  //     expect((deps['/properties/list'] as List)[0].value, isNull);
  //     expect((deps['/properties/list'] as List)[1].value, isNull);
  //   });

  //   test('recursively resets ListItem values in nested lists/maps', () {
  //     final Map<String, dynamic> deps = {
  //       '/properties/list': [
  //         ListItem(id: 0, value: Map<String, dynamic>.from({'/properties/nested': 'val'}))
  //       ],
  //     };
  //     resetShowOnDependencies(deps);
  //     expect((((deps['/properties/list'] as List)[0] as ListItem).value as Map<String, dynamic>)['/properties/nested'], isNull);
  //   });
  // });
}
