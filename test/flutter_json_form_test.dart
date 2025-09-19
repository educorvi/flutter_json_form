import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_test/flutter_test.dart';

class Dummy {}

void main() {
  test('FlutterJsonForm can be created', () {
    final form = FlutterJsonForm(
      jsonSchema: {},
      uiSchema: {},
    );
    expect(form, isNotNull);
  });

  group('FlutterJsonForm argument flexibility', () {
    test('accepts arbitrary jsonSchema and uiSchema values', () {
      final form1 = FlutterJsonForm(jsonSchema: {}, uiSchema: {});
      final form2 = FlutterJsonForm(jsonSchema: {'foo': 123}, uiSchema: {'bar': 'baz'});
      final form3 = FlutterJsonForm(jsonSchema: null, uiSchema: null);
      final form4 = FlutterJsonForm(jsonSchema: [], uiSchema: []);
      final form5 = FlutterJsonForm(jsonSchema: Dummy(), uiSchema: ['a', 'b', 'c']);
      expect(form1, isNotNull);
      expect(form2, isNotNull);
      expect(form3, isNotNull);
      expect(form4, isNotNull);
      expect(form5, isNotNull);
    });
  });
}
