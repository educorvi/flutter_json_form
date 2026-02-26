import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/test_utils.dart';
import 'object_data.dart';

void main() {
  ensureWidgetTestBinding();

  group('Object Form Tests', () {
    testWidgets('Object is rendered correctly', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchema);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.formFieldText('FirstName'), findsOneWidget);
      expect(find.formFieldText('LastName'), findsOneWidget);
    });

    // testWidgets('individual default values are rendered correctly', (tester) async {
    //   // GIVEN: default values in schema
    //   await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchemaWithIndividualDefaults);

    //   // THEN: fields should have default values
    //   expect(find.formFieldText('John Doe'), findsOneWidget);
    //   expect(find.formFieldText('John'), findsOneWidget);
    //   expect(find.formFieldText('Doe'), findsOneWidget);
    // });

    // testWidgets('Object default values are rendered correctly', (tester) async {
    //   // GIVEN: default values in schema
    //   await pumpForm(tester, jsonSchema: ObjectData.jsonSchemaWithObjectDefaults);

    //   // THEN: fields should have default values
    //   expect(find.formFieldText('John Doe'), findsOneWidget);
    //   expect(find.formFieldText('John'), findsOneWidget);
    //   expect(find.formFieldText('Doe'), findsOneWidget);
    // });

    // testWidgets('Object default values with mixed individual and object defaults are rendered correctly', (tester) async {
    //   // GIVEN: default values in schema
    //   await pumpForm(tester, jsonSchema: ObjectData.jsonSchemaWithMixedDefaults);

    //   // THEN: fields should have default values
    //   expect(find.formFieldText('Inner John Doe'), findsOneWidget);
    //   expect(find.formFieldText('John'), findsOneWidget);
    //   expect(find.formFieldText('Doe InnerInner'), findsOneWidget);
    //   expect(find.formFieldText('Inner Third Name'), findsOneWidget);
    // });

    testWidgets('Simple object follows a11y guidelines', (tester) async {
      await checkAccessibilityGuidelines(
        tester,
        (tester) => pumpForm(
          tester,
          jsonSchema: JsonSchemaObjectData.jsonSchema,
        ),
      );
    });

    testWidgets('Nested object with defaults is rendered correctly when no ui schema is provided', (tester) async {
      // GIVEN: default values in nested schema
      await pumpForm(tester, jsonSchema: JsonSchemaNestedObjectData.nestedSchemaWithDefaults);

      // THEN: fields should have default values
      expect(find.text('Outer'), findsOneWidget);
      expect(find.text('Main St'), findsOneWidget);
      expect(find.text('Metropolis'), findsOneWidget);
      expect(find.text('Freedonia'), findsOneWidget);
      expect(find.text('FR'), findsOneWidget);
      // Check switches
      final switchOuter = find.byKey(ValueKey('/properties/switchOuter'));
      expect(switchOuter, findsOneWidget);
      final switchObject = find.byKey(ValueKey('/properties/address/properties/switchObject'));
      expect(switchObject, findsOneWidget);
      final switchNestedObject = find.byKey(ValueKey('/properties/address/properties/country/properties/switchNestedObject'));
      expect(switchNestedObject, findsOneWidget);
    });

    testWidgets('Complex object follows a11y guidelines', (tester) async {
      await checkAccessibilityGuidelines(
        tester,
        (tester) => pumpForm(
          tester,
          jsonSchema: JsonSchemaNestedObjectData.jsonSchema,
        ),
      );
    });
  });
}
