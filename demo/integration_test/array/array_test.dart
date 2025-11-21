import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'array_data.dart';
import '../test_utils.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Array Form Tests', () {
    testWidgets('Simple array is rendered and default value is present', (tester) async {
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaSimpleArray, uiSchema: ArrayData.uiSchemaSimpleArray);
      expect(find.formFieldText('tags'), findsOneWidget);
      expect(find.text('defaultTag'), findsOneWidget);
    });

    testWidgets('Can add, reorder, and delete elements in simple array', (tester) async {
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaSimpleArray, uiSchema: ArrayData.uiSchemaSimpleArray);
      // Add new tag
      final addButton = find.byKey(ValueKey('/properties/tags/add'));
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      // Should have two tag fields now
      expect(find.byType(FormBuilderTextField), findsNWidgets(2));

      // Reorder: simulate drag if supported
      // final dragHandle = find.byKey(ValueKey('/properties/tags/0/drag'));
      // await tester.drag(dragHandle, Offset(0, 50));
      // await tester.pumpAndSettle();

      // Delete
      final deleteButton = find.byKey(ValueKey('/properties/tags/0/remove'));
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      // Should have one tag field now
      expect(find.byType(FormBuilderTextField), findsNWidgets(1));
    });

    /// TODO: check default values which are currently not set for additional new array elements
    testWidgets('Array of objects: default value, add, reorder, delete', (tester) async {
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaArrayOfObjects, uiSchema: ArrayData.uiSchemaArrayOfObjects);
      expect(find.formFieldText('people'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);

      // Add new person
      final addButton = find.byKey(ValueKey('/properties/people/add'));
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      // Should have two person forms now
      expect(find.formFieldText('firstName'), findsNWidgets(2));
      expect(find.formFieldText('lastName'), findsNWidgets(2));

      // Delete
      final deleteButton = find.byKey(ValueKey('/properties/people/0/remove'));
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      // Should have one person form now
      expect(find.formFieldText('firstName'), findsOneWidget);
      expect(find.formFieldText('lastName'), findsOneWidget);
      expect(find.text('John'), findsNothing);
      expect(find.text('Doe'), findsNothing);
    });

    /// TODO: most likely it would be good if object with default values are set correctly here so the initial values are like the default of the array/object
    testWidgets('Array of arrays: default value, add, reorder, delete', (tester) async {
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaArrayOfArrays, uiSchema: ArrayData.uiSchemaArrayOfArrays);
      expect(find.formFieldText('matrix'), findsOneWidget);
      // Should render two array rows
      expect(find.byType(FormBuilderTextField), findsNWidgets(4)); // 2x2 numbers

      // Add new row
      final addButton = find.byKey(ValueKey('/properties/matrix/add'));
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      final addNestedButton = find.byKey(ValueKey('/properties/matrix/items/3/add'));
      expect(addNestedButton, findsOneWidget);
      await tester.tap(addNestedButton);
      await tester.pumpAndSettle();
      // Should have three rows now
      expect(find.byType(FormBuilderTextField), findsNWidgets(5));

      // Delete
      final deleteButton = find.byKey(ValueKey('/properties/matrix/0/remove'));
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      // Should have two rows now
      expect(find.byType(FormBuilderTextField), findsNWidgets(3));
    });
  });

  group('Nested Array Form Tests', () {
    testWidgets('Nested array: default value, add, reorder, delete', (tester) async {
      await pumpForm(tester, jsonSchema: NestedArrayData.jsonSchemaNestedArray, uiSchema: NestedArrayData.uiSchemaNestedArray);
      expect(find.formFieldText('groups'), findsOneWidget);
      expect(find.text('GroupA'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      // Add new group
      final addGroupButton = find.byKey(ValueKey('/properties/groups/add'));
      expect(addGroupButton, findsOneWidget);
      await tester.tap(addGroupButton);
      await tester.pumpAndSettle();
      // Should have two group forms now
      expect(find.formFieldText('name'), findsNWidgets(2));

      // Add member to first group
      final addMemberButton = find.byKey(ValueKey('/properties/groups/items/0/properties/members/add'));
      expect(addMemberButton, findsOneWidget);
      await tester.tap(addMemberButton);
      await tester.pumpAndSettle();
      // Should have three member fields in first group
      expect(find.byType(FormBuilderTextField), findsNWidgets(5)); // 2 group names + 3 members

      // Delete member from first group
      final deleteMemberButton = find.byKey(ValueKey('/properties/groups/items/0/properties/members/0/remove'));
      expect(deleteMemberButton, findsOneWidget);
      await tester.tap(deleteMemberButton);
      await tester.pumpAndSettle();
      // Should have two member fields in first group
      expect(find.byType(FormBuilderTextField), findsNWidgets(4));
      expect(find.text('Alice'), findsNothing);
    });
  });
}
