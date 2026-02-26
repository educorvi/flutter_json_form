import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

import '../utils/test_utils.dart';
import 'elements_data.dart';

void main() {
  ensureWidgetTestBinding();

  group('Primitive Json Schema Elements Form Tests', () {
    testWidgets('Primitive json schema elements are rendered correctly', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaPrimitiveElementsData.jsonSchema);

      // THEN: each json schema property should render with the intended widget type
      expectFormControlType<FormBuilderTextField>(tester, property: 'stringProp', label: 'StringProp');
      expectFormControlType<FormBuilderTextField>(tester, property: 'numberProp', label: 'NumberProp');
      expectFormControlType<FormBuilderTextField>(tester, property: 'integerProp', label: 'IntegerProp');
      expectFormControlType<FormBuilderSwitch>(tester, property: 'booleanProp', label: 'BooleanProp');
      expectFormControlType<FormBuilderDateTimePicker>(tester, property: 'dateTimeProp', label: 'DateTimeProp');
      expectFormControlType<FormBuilderDateTimePicker>(tester, property: 'dateProp', label: 'DateProp');
      expectFormControlType<FormBuilderDateTimePicker>(tester, property: 'timeProp', label: 'TimeProp');
      expectFormControlType<FormBuilderDropdown>(tester, property: 'stringEnum', label: 'StringEnum');
      expectFormControlType<FormBuilderCheckboxGroup>(tester, property: 'arrayEnumString', label: 'ArrayEnumString');
    });

    for (final field in JsonSchemaPrimitiveElementsData.primitiveFieldNames) {
      testWidgets('Field "$field" must be filled when marked as required', (tester) async {
        // GIVEN: A form where "$field" is the only required field
        await pumpForm(
          tester,
          jsonSchema: JsonSchemaPrimitiveElementsData.createSchema(requiredFields: [field]),
        );

        //THEN: the field should be marked as required
        expect(isTextFieldRequired(tester, upperName(field)), isTrue);

        // WHEN: Try to submit the form without filling the required field
        final formState = tester.state<FlutterJsonFormState>(find.byType(FlutterJsonForm));
        expect(
          formState.saveAndValidate(),
          isFalse,
          reason: 'Form should be invalid when required field "$field" is empty',
        );
        await tester.pumpAndSettle();

        // THEN: An error text should be shown for the specific field
        String text = "This field cannot be empty.";
        if (field == 'booleanProp') {
          // boolean fields have a different required error text since they must be true, not just non-empty
          text = "This field value must be equal to true.";
        }
        // check that required error text is shown for the specific field
        final errorTextFinder = find.descendant(
          of: _findFormControl(field),
          matching: find.text(text),
        );
        expect(errorTextFinder, findsOneWidget, reason: 'Expected required error text for "$field"');
      });
    }
  });
}

Finder _findFormControl(String property) {
  final candidates = <String>{
    property,
    '/properties/$property',
    '#/properties/$property',
  };

  return find.byWidgetPredicate(
    (widget) =>
        widget is FormBuilderField &&
        candidates.contains(
            widget.name), // TODO: this .name is dependant on the form builder implementation. It would be better to use a key here which we control.
    description: 'Form control for "$property"',
  );
}

void expectFormControlType<T extends FormBuilderField>(WidgetTester tester, {required String property, required String label}) {
  final fieldFinder = _findFormControl(property);
  expect(fieldFinder, findsOneWidget, reason: 'Expected form control for "$label" to exist');
  final widget = tester.widget(fieldFinder);
  expect(
    widget,
    isA<T>(),
    reason: 'Expected "$label" to render ${T.toString()} but found ${widget.runtimeType}',
  );
}
