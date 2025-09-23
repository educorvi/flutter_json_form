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
      expect(find.text('firstName'), findsOneWidget);
      expect(find.text('lastName'), findsOneWidget);
    });

    testWidgets('Object is rendered correctly when ui schema references whole object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaWholeObject);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.text('firstName'), findsOneWidget);
      expect(find.text('lastName'), findsOneWidget);
    });

    testWidgets('Object is rendered correctly when ui schema references single elements', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaObjectElements);

      // THEN: should render fields for person.firstName and person.lastName
      expect(find.text('firstName'), findsOneWidget);
      expect(find.text('lastName'), findsOneWidget);
    });

    testWidgets('Dynamic dependency: outer to object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaDynamicOuterToObject);

      // THEN: Initially only switchOuter is visible
      expect(find.text('switchOuter'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('firstName')), isFalse); // firstName is hidden

      // WHEN: Set switchOuter to true
      final outerSwitch = find.byKey(ValueKey('/properties/switchOuter'));
      expect(outerSwitch, findsOneWidget);
      await tester.tap(outerSwitch);
      await tester.pumpAndSettle();

      // THEN: firstName should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('firstName')), isTrue); // firstName is visible
    });

    testWidgets('Dynamic dependency: object to object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaDynamicObjectToObject);

      // THEN: Initially only switchObject is visible
      expect(find.text('switchObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('lastName')), isFalse);

      // WHEN: Set switchObject to true
      final objectSwitch = find.byKey(ValueKey('/properties/person/properties/switchObject'));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: lastName should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('lastName')), isTrue);
    });

    testWidgets('Dynamic dependency: object to outer', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ObjectData.jsonSchema, uiSchema: ObjectData.uiSchemaDynamicObjectToOuter);

      // THEN: Initially only switchObject is visible
      expect(find.text('switchObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('name')), isFalse);

      // WHEN: Set switchObject to true (simulate value 'show' if needed)
      final objectSwitch = find.byKey(ValueKey('/properties/person/properties/switchObject'));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: name should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('name')), isTrue);
    });
  });

  group('Nested Object Form Tests', () {
    testWidgets('Nested object is rendered correctly when no ui schema is provided', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.text('street'), findsOneWidget);
      expect(find.text('city'), findsOneWidget);
      expect(find.text('name'), findsOneWidget);
      expect(find.text('code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references whole object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaWholeObject);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.text('street'), findsOneWidget);
      expect(find.text('city'), findsOneWidget);
      expect(find.text('name'), findsOneWidget);
      expect(find.text('code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references whole nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaWholeNestedObject);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.text('name'), findsOneWidget);
      expect(find.text('code'), findsOneWidget);
    });

    testWidgets('Nested object is rendered correctly when ui schema references single elements', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaObjectElements);

      // THEN: should render fields for address.street, address.city, address.country.name, address.country.code
      expect(find.text('street'), findsOneWidget);
      expect(find.text('city'), findsOneWidget);
      expect(find.text('name'), findsOneWidget);
      expect(find.text('code'), findsOneWidget);
    });

    testWidgets('Dynamic dependency: outer to nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicOuterToNestedObject);

      // THEN: Initially only switchOuter is visible, street is hidden
      expect(find.text('switchOuter'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('name')), isFalse);

      // WHEN: Set switchOuter to true
      final outerSwitch = find.byKey(ValueKey('/properties/switchOuter'));
      expect(outerSwitch, findsOneWidget);
      await tester.tap(outerSwitch);
      await tester.pumpAndSettle();

      // THEN: street should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('name')), isTrue);
    });

    testWidgets('Dynamic dependency: object to nested object', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicObjectToNestedObject);

      // THEN: Initially only switchObject is visible, country.name is hidden
      expect(find.text('switchObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('name')), isFalse);

      // WHEN: Set switchObject to true
      final objectSwitch = find.byKey(ValueKey('/properties/address/properties/switchObject'));
      expect(objectSwitch, findsOneWidget);
      await tester.tap(objectSwitch);
      await tester.pumpAndSettle();

      // THEN: country.name should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('name')), isTrue);
    });

    testWidgets('Dynamic dependency: nested object to nestedElement', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicNestedObjectToElement);

      // THEN: Initially only switchNestedObject is visible, country.code is hidden
      expect(find.text('switchNestedObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('code')), isFalse);

      // WHEN: Set switchNestedObject to true
      final nestedSwitch = find.byKey(ValueKey('/properties/address/properties/country/properties/switchNestedObject'));
      expect(nestedSwitch, findsOneWidget);
      await tester.tap(nestedSwitch);
      await tester.pumpAndSettle();

      // THEN: country.code should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('code')), isTrue);
    });

    testWidgets('Dynamic dependency: nested object to outerElement', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: NestedObjectData.jsonSchema, uiSchema: NestedObjectData.uiSchemaDynamicNestedObjectToOuter);

      // THEN: Initially only switchNestedObject is visible, country.code is hidden
      expect(find.text('switchNestedObject'), findsOneWidget);
      expect(isWidgetCrossFadeVisible(tester, find.text('outerName')), isFalse);

      // WHEN: Set switchNestedObject to true
      final nestedSwitch = find.byKey(ValueKey('/properties/address/properties/country/properties/switchNestedObject'));
      expect(nestedSwitch, findsOneWidget);
      await tester.tap(nestedSwitch);
      await tester.pumpAndSettle();

      // THEN: country.code should now be visible
      expect(isWidgetCrossFadeVisible(tester, find.text('outerName')), isTrue);
    });
  });
}
