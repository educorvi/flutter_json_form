import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FlutterJsonForm can be created', () {
    final form = FlutterJsonForm(
      jsonSchema: {},
      uiSchema: {},
    );
    expect(form, isNotNull);
  });
}
