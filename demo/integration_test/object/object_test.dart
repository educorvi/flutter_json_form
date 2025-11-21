import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'object_data.dart';
import '../test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Object Form Tests', () {
    testWidgets('Object is rendered correctly when no ui schema is provided', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.formFieldText('firstName'), findsOneWidget);
      expect(find.formFieldText('lastName'), findsOneWidget);
    });

    testWidgets('Object is rendered correctly when ui schema references whole object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaWholeObject);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.formFieldText('firstName'), findsOneWidget);
      expect(find.formFieldText('lastName'), findsOneWidget);
    });

    testWidgets('Object is rendered correctly when ui schema references single elements', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaObjectElements);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.formFieldText('firstName'), findsOneWidget);
      expect(find.formFieldText('lastName'), findsOneWidget);
    });

    // testWidgets('individual default values are rendered correctly', (tester) async {
    //   // GIVEN: default values in schema
    //   await pumpForm(tester, jsonSchema: ObjectData.jsonSchemaWithIndividualDefaults);

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

    testWidgets('Dynamic dependency: outer to object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaDynamicOuterToObject);

      // THEN: Initially only switchOuter is visible
      expect(find.formFieldText('switchOuter'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('firstName')), isFalse); // firstName is hidden

      // WHEN: Set switchOuter to true
      final outerSwitch = find.byKey(ValueKey('/properties/switchOuter'));
      expect(outerSwitch, findsOneWidget);
      await tester.tap(outerSwitch);
      await tester.pumpAndSettle();

      // THEN: firstName should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('firstName')), isTrue); // firstName is visible
    });

    testWidgets('Dynamic dependency: object to object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaDynamicObjectToObject);

      // THEN: Initially only switchObject is visible
      expect(find.formFieldText('switchObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('lastName')), isFalse);

      // WHEN: Set switchObject to true
      final objectSwitch = find.byKey(ValueKey('/properties/person/properties/switchObject'));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: lastName should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('lastName')), isTrue);
    });

    testWidgets('Dynamic dependency: object to outer', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaDynamicObjectToOuter);

      // THEN: Initially only switchObject is visible
      expect(find.formFieldText('switchObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('name')), isFalse);

      // WHEN: Set switchObject to true (simulate value 'show' if needed)
      final objectSwitch = find.byKey(ValueKey('/properties/person/properties/switchObject'));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: name should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('name')), isTrue);
    });

    testWidgets('Follows a11y guidelines', (tester) async {
      await checkAccessibilityGuidelines(
        tester,
        (tester) => pumpForm(
          tester,
          jsonSchema: ObjectData.jsonSchema,
        ),
      );
    });
  });

  group('Nested Object Form Tests', () {
    testWidgets('Nested object with defaults is rendered correctly when no ui schema is provided', (tester) async {
      // GIVEN: default values in nested schema
      await pumpForm(tester, jsonSchema: NestedObjectData.nestedSchemaWithDefaults);

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

    testWidgets('Nested object is rendered correctly when ui schema references whole object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaWholeObject);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.formFieldText('street'), findsOneWidget);
      expect(find.formFieldText('city'), findsOneWidget);
      expect(find.formFieldText('name'), findsOneWidget);
      expect(find.formFieldText('code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references whole nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaWholeNestedObject);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.formFieldText('name'), findsOneWidget);
      expect(find.formFieldText('code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references single elements', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaObjectElements);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.formFieldText('street'), findsOneWidget);
      expect(find.formFieldText('city'), findsOneWidget);
      expect(find.formFieldText('name'), findsOneWidget);
      expect(find.formFieldText('code'), findsOneWidget);
    });

    testWidgets('Dynamic dependency: outer to nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicOuterToNestedObject);

      // THEN: Initially only switchOuter is visible, street is hidden
      expect(find.formFieldText('switchOuter'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('name')), isFalse);

      // WHEN: Set switchOuter to true
      final outerSwitch = find.byKey(ValueKey('/properties/switchOuter'));
      expect(outerSwitch, findsOneWidget);
      await tester.tap(outerSwitch);
      await tester.pumpAndSettle();

      // THEN: street should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('name')), isTrue);
    });

    testWidgets('Dynamic dependency: object to nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicObjectToNestedObject);

      // THEN: Initially only switchObject is visible, country.name is hidden
      expect(find.formFieldText('switchObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('name')), isFalse);

      // WHEN: Set switchObject to true
      final objectSwitch = find.byKey(ValueKey('/properties/address/properties/switchObject'));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: country.name should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('name')), isTrue);
    });

    testWidgets('Dynamic dependency: nested object to nestedElement', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicNestedObjectToElement);

      // THEN: Initially only switchNestedObject is visible, country.code is hidden
      expect(find.formFieldText('switchNestedObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('code')), isFalse);

      // WHEN: Set switchNestedObject to true
      final nestedSwitch = find.byKey(ValueKey('/properties/address/properties/country/properties/switchNestedObject'));
      expect(nestedSwitch, findsOneWidget);
      await tester.tap(nestedSwitch);
      await tester.pumpAndSettle();

      // THEN: country.code should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('code')), isTrue);
    });

    testWidgets('Dynamic dependency: nested object to outerElement', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicNestedObjectToOuter);

      // THEN: Initially only switchNestedObject is visible, country.code is hidden
      expect(find.formFieldText('switchNestedObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('outerName')), isFalse);

      // WHEN: Set switchNestedObject to true
      final nestedSwitch = find.byKey(ValueKey('/properties/address/properties/country/properties/switchNestedObject'));
      expect(nestedSwitch, findsOneWidget);
      await tester.tap(nestedSwitch);
      await tester.pumpAndSettle();

      // THEN: country.code should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.formFieldText('outerName')), isTrue);
    });

    testWidgets('Follows a11y guidelines', (tester) async {
      await checkAccessibilityGuidelines(
        tester,
        (tester) => pumpForm(
          tester,
          jsonSchema: NestedObjectData.jsonSchema,
        ),
      );
    });
  });
}
