import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../utils/locators/array_locators.dart';
import 'array_data.dart';
import '../../../utils/test_utils.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Array Form Tests', () {
    testWidgets('Simple array is rendered and default value is present', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaSimpleArray);

      // THEN
      expect(find.formFieldText('Tags'), findsOneWidget);
      expect(find.text('defaultTag'), findsOneWidget);
    });

    // Note: this logic is assumed form here on so all other tests depend on that assumption and will break if the id generation logic changes.
    testWidgets('Array object ids are sequential numbers starting from 0', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaArrayOfObjects);

      // When: Add new person
      final addButton = findArrayAddButton(['people']);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // THEN: Should have two person forms now with correct sequential ids
      expect(find.byKey(ValueKey(scopePath(['people', 0]))), findsOneWidget, reason: 'First array element should have an id of 0');
      expect(find.byKey(ValueKey(scopePath(['people', 1]))), findsOneWidget, reason: 'Array elements should have sequential ids starting from 0');
    });

    testWidgets('Can add, reorder, and delete elements in simple array', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaSimpleArray);

      // THEN: Reorder element should disabled when only one element is present
      final reorderButtonDisabled = findArrayDragHandle(['tags', 0]);
      expect(reorderButtonDisabled, findsOneWidget);
      expect(tester.widget<FilledButton>(reorderButtonDisabled).onPressed, isNull);

      // WHEN: Add a new tag
      final addButton = findArrayAddButton(['tags']);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // THEN: Should have two tag fields now
      expect(find.byType(FormBuilderTextField), findsNWidgets(2));

      // WHEN: Reorder newly added tag to the top
      final textFields = find.byType(FormBuilderTextField);
      await enterTextAndSettle(tester, textFields.last, 'NewTag');

      final dragHandle = findArrayDragHandle(['tags', 1]);
      expect(dragHandle, findsOneWidget);

      await tester.drag(dragHandle, const Offset(0, -150));
      await tester.pumpAndSettle();

      // THEN: NewTag should now be above defaultTag
      expectWidgetAbove(tester, find.text('NewTag'), find.text('defaultTag'));

      // WHEN: Delete element
      final deleteButton = findArrayRemoveButton(['tags', 0]);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // THEN: Should have one tag field now
      expect(find.byType(FormBuilderTextField), findsNWidgets(1));
    });

    testWidgets('Array respects min and max items property', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaArrayWithMinMax);

      // THEN: Should have two tags and the delete buttons should be disabled due to minItems
      expectDeleteButtonState(tester, ['tags'], [0, 1], isNull);

      // WHEN: Add two more tags to reach maxItems
      final addButton = findArrayAddButton(['tags']);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // THEN: Should have four tag fields now and add button should be disabled due to maxItems
      expect(find.byType(FormBuilderTextField), findsNWidgets(4));
      expect(addButton, findsOneWidget);
      expect(tester.widget<FilledButton>(addButton).onPressed, isNull);
      expectDeleteButtonState(tester, ['tags'], [0, 1, 2, 3], isNotNull);
    });

    /// TODO: check default values which are currently not set for additional new array elements
    testWidgets('Array of objects: default value, add, reorder, delete', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaArrayOfObjects);

      // THEN: Should render people array with one person from default value
      expect(find.formFieldText('People'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);

      // WHEN: Add new person
      final addButton = findArrayAddButton(['people']);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);

      await tester.pumpAndSettle();
      // THEN: Should have two person forms now
      expect(find.formFieldText('FirstName'), findsNWidgets(2));
      expect(find.formFieldText('LastName'), findsNWidgets(2));

      // WHEN: Delete element
      final deleteButton = findArrayRemoveButton(['people', 0]);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // THEN: Should have one person form now
      expect(find.formFieldText('FirstName'), findsOneWidget);
      expect(find.formFieldText('LastName'), findsOneWidget);
      expect(find.text('John'), findsNothing);
      expect(find.text('Doe'), findsNothing);
    });

    /// TODO: most likely it would be good if object with default values are set correctly here so the initial values are like the default of the array/object
    testWidgets('Array of arrays: default value, add, reorder, delete', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaArrayOfArrays);

      // THEN: Should render matrix array with two rows from default value
      expect(find.formFieldText('Matrix'), findsAny);
      expect(find.byType(FormBuilderTextField), findsNWidgets(4)); // 2x2 numbers

      // WHEN: Add a new row and a new element in that row
      final addButton = findArrayAddButton(['matrix']);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      final addNestedButton = findArrayAddButton(['matrix', 2]);
      expect(addNestedButton, findsOneWidget);
      await tester.tap(addNestedButton);
      await tester.pumpAndSettle();

      // THEN: Should have three rows now
      expect(find.byType(FormBuilderTextField), findsNWidgets(5));

      // WHEN: Delete the first element of the first row
      final deleteButton = findArrayRemoveButton(['matrix', 0]);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // THEN: Should have two rows now
      expect(find.byType(FormBuilderTextField), findsNWidgets(3));
    });

    testWidgets('Nested array: default value, add, reorder, delete', (tester) async {
      // GIVEN
      await pumpForm(tester, jsonSchema: ArrayData.jsonSchemaNestedArray);

      // THEN: Should render groups array with one group from default value
      expect(find.formFieldText('Groups'), findsAny);
      expect(find.text('GroupA'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      // WHEN: Add new group
      final addGroupButton = findArrayAddButton(['groups']);
      expect(addGroupButton, findsOneWidget);
      await tester.tap(addGroupButton);
      await tester.pumpAndSettle();

      // THEN: Should have two group forms now
      expect(find.formFieldText('Name'), findsNWidgets(2));

      // WHEN: Add member to first group
      final addMemberButton = findArrayAddButton(['groups', 0, 'members']);
      expect(addMemberButton, findsOneWidget);
      await tester.tap(addMemberButton);
      await tester.pumpAndSettle();

      // THEN: Should have three member fields in first group
      expect(find.byType(FormBuilderTextField), findsNWidgets(5)); // 2 group names + 3 members

      // WHEN: Delete member from first group
      final deleteMemberButton = findArrayRemoveButton(['groups', 0, 'members', 0]);
      expect(deleteMemberButton, findsOneWidget);
      await tester.tap(deleteMemberButton);
      await tester.pumpAndSettle();

      // THEN: Should have two member fields in first group
      expect(find.byType(FormBuilderTextField), findsNWidgets(4));
      expect(find.text('Alice'), findsNothing);
    });
  });
}
