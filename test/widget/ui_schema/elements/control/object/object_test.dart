import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../json_schema/object/object_data.dart';
import '../../../../utils/test_utils.dart';
import 'object_data.dart';

void main() {
  ensureWidgetTestBinding();

  group('Object Form Tests', () {
    testWidgets('Object is rendered correctly when ui schema references whole object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchema, uiSchema: UiSchemaControlObjectData.uiSchemaWholeObject);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.formFieldText('FirstName'), findsOneWidget);
      expect(find.formFieldText('LastName'), findsOneWidget);
    });

    testWidgets('Object is rendered correctly when ui schema references single elements', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchema, uiSchema: UiSchemaControlObjectData.uiSchemaObjectElements);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.formFieldText('FirstName'), findsOneWidget);
      expect(find.formFieldText('LastName'), findsOneWidget);
    });

    testWidgets('Dynamic dependency: outer to object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchema, uiSchema: UiSchemaControlObjectData.uiSchemaDynamicOuterToObject);

      // THEN: Initially only switchOuter is visible
      expect(find.formFieldText('SwitchOuter'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('FirstName')); // FirstName is hidden

      // WHEN: Set switchOuter to true
      final outerSwitch = find.byKey(ValueKey(scopePath(['switchOuter'])));
      expect(outerSwitch, findsOneWidget);
      await tester.tap(outerSwitch);
      await tester.pumpAndSettle();

      // THEN: FirstName should now be visible
      expectShowOnVisible(tester, find.formFieldText('FirstName')); // FirstName is visible
    });

    testWidgets('Dynamic dependency: object to object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchema, uiSchema: UiSchemaControlObjectData.uiSchemaDynamicObjectToObject);

      // THEN: Initially only switchObject is visible
      expect(find.formFieldText('SwitchObject'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('LastName')); // LastName is hidden

      // WHEN: Set switchObject to true
      final objectSwitch = find.byKey(ValueKey(scopePath(['person', 'switchObject'])));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: lastName should now be visible
      expectShowOnVisible(tester, find.formFieldText('LastName')); // LastName is visible
    });

    testWidgets('Dynamic dependency: object to outer', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaObjectData.jsonSchema, uiSchema: UiSchemaControlObjectData.uiSchemaDynamicObjectToOuter);

      // THEN: Initially only switchObject is visible
      expect(find.formFieldText('SwitchObject'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('Name')); // Name is hidden

      // WHEN: Set switchObject to true (simulate value 'show' if needed)
      final objectSwitch = find.byKey(ValueKey(scopePath(['person', 'switchObject'])));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: Name should now be visible
      expectShowOnVisible(tester, find.formFieldText('Name')); // Name is visible
    });
  });

  group('Nested Object Form Tests', () {
    testWidgets('Nested object is rendered correctly when ui schema references whole object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaWholeObject);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.formFieldText('Street'), findsOneWidget);
      expect(find.formFieldText('City'), findsOneWidget);
      expect(find.formFieldText('Name'), findsOneWidget);
      expect(find.formFieldText('Code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references whole nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaWholeNestedObject);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.formFieldText('Name'), findsOneWidget);
      expect(find.formFieldText('Code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references single elements', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaObjectElements);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.formFieldText('Street'), findsOneWidget);
      expect(find.formFieldText('City'), findsOneWidget);
      expect(find.formFieldText('Name'), findsOneWidget);
      expect(find.formFieldText('Code'), findsOneWidget);
    });

    testWidgets('Dynamic dependency: outer to nested object', (tester) async {
      // GIVEN
      await pumpForm(tester,
          jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaDynamicOuterToNestedObject);

      // THEN: Initially only switchOuter is visible, street is hidden
      expect(find.formFieldText('SwitchOuter'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('Name')); // Name is hidden

      // WHEN: Set switchOuter to true
      final outerSwitch = find.byKey(ValueKey(scopePath(['switchOuter'])));
      expect(outerSwitch, findsOneWidget);
      await tester.tap(outerSwitch);
      await tester.pumpAndSettle();

      // THEN: street should now be visible
      expectShowOnVisible(tester, find.formFieldText('Name')); // Name is visible
    });

    testWidgets('Dynamic dependency: object to nested object', (tester) async {
      // GIVEN
      await pumpForm(tester,
          jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaDynamicObjectToNestedObject);

      // THEN: Initially only switchObject is visible, country.name is hidden
      expect(find.formFieldText('SwitchObject'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('Name')); // Name is hidden

      // WHEN: Set switchObject to true
      final objectSwitch = find.byKey(ValueKey(scopePath(['address', 'switchObject'])));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: country.name should now be visible
      expectShowOnVisible(tester, find.formFieldText('Name')); // Name is visible
    });

    testWidgets('Dynamic dependency: nested object to nestedElement', (tester) async {
      // GIVEN
      await pumpForm(tester,
          jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaDynamicNestedObjectToElement);

      // THEN: Initially only switchNestedObject is visible, country.code is hidden
      expect(find.formFieldText('SwitchNestedObject'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('Code')); // Code is hidden

      // WHEN: Set switchNestedObject to true
      final nestedSwitch = find.byKey(ValueKey(scopePath(['address', 'country', 'switchNestedObject'])));
      expect(nestedSwitch, findsOneWidget);
      await tester.tap(nestedSwitch);
      await tester.pumpAndSettle();

      // THEN: country.code should now be visible
      expectShowOnVisible(tester, find.formFieldText('Code')); // Code is visible
    });

    testWidgets('Dynamic dependency: nested object to outerElement', (tester) async {
      // GIVEN
      await pumpForm(tester,
          jsonSchema: JsonSchemaNestedObjectData.jsonSchema, uiSchema: UiSchemaControlNestedObjectData.uiSchemaDynamicNestedObjectToOuter);

      // THEN: Initially only switchNestedObject is visible, country.code is hidden
      expect(find.formFieldText('SwitchNestedObject'), findsOneWidget);
      expectShowOnHidden(tester, find.formFieldText('OuterName')); // OuterName is hidden

      // WHEN: Set switchNestedObject to true
      final nestedSwitch = find.byKey(ValueKey(scopePath(['address', 'country', 'switchNestedObject'])));
      expect(nestedSwitch, findsOneWidget);
      await tester.tap(nestedSwitch);
      await tester.pumpAndSettle();

      // THEN: country.code should now be visible
      expectShowOnVisible(tester, find.formFieldText('OuterName')); // OuterName is visible
    });
  });
}
