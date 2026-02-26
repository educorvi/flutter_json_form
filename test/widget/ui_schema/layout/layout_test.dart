import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_layout.dart';

import '../../utils/test_utils.dart';
import 'layout_data.dart';

void main() {
  ensureWidgetTestBinding();

  group('UI Schema Layout Form Tests', () {
    testWidgets('Ui Schema Layout options and elements including nested layouts render correctly', (tester) async {
      // GIVEN: a layout with various options and nested elements, including another layout with its own options
      await pumpForm(tester, jsonSchema: UiSchemaLayoutData.jsonSchema, uiSchema: UiSchemaLayoutData.uiSchema);

      // THEN: should render layout options and elements correctly

      final layoutFinder = _layoutOfType(ui.LayoutType.VERTICAL_LAYOUT);
      expect(layoutFinder, findsNWidgets(2));

      final layoutLabelFinder = find.formFieldText('Outer Layout Label');
      final layoutDescriptionFinder = find.formFieldText('Outer Layout description');
      final nestedLayoutLabelFinder = find.formFieldText('Nested Layout Label');
      final nestedLayoutDescriptionFinder = find.formFieldText('Nested Layout Description');
      final stringPropFinder = find.formFieldText('StringProp');
      final nestedStringFinder = find.formFieldText('NestedString');
      final dividerFinder = find.byType(Divider);
      final numberPropFinder = find.formFieldText('NumberProp');
      // check that all elements are rendered
      expect(layoutLabelFinder, findsOneWidget); // layout label from options
      expect(layoutDescriptionFinder, findsOneWidget); // layout description from options
      expect(stringPropFinder, findsOneWidget); // control for stringProp
      expect(nestedLayoutLabelFinder, findsOneWidget); // nested layout label from options
      expect(nestedLayoutDescriptionFinder, findsOneWidget); // nested layout description from options
      expect(nestedStringFinder, findsOneWidget); // control for nestedString
      expect(dividerFinder, findsOneWidget); // divider element
      expect(numberPropFinder, findsOneWidget); // control for nestedNumber
      // expect correct placement of objects
      expectWidgetsInVerticalOrder(tester, [
        layoutLabelFinder,
        stringPropFinder,
        nestedLayoutLabelFinder,
        nestedStringFinder,
        dividerFinder,
        numberPropFinder,
      ]);
    });

    testWidgets('Horizontal layout arranges controls side by side', (tester) async {
      // GIVEN: a layout of type HORIZONTAL_LAYOUT with two controls as children
      await pumpForm(tester, jsonSchema: UiSchemaLayoutData.jsonSchema, uiSchema: UiSchemaLayoutData.uiSchemaHorizontal);

      // THEN: should render controls for stringProp and numberProp on the same horizontal line
      final horizontalLayoutFinder = _layoutOfType(ui.LayoutType.HORIZONTAL_LAYOUT);
      expect(horizontalLayoutFinder, findsOneWidget);

      final stringPropFinder = find.formFieldText('StringProp');
      final numberPropFinder = find.formFieldText('NumberProp');
      expect(stringPropFinder, findsOneWidget);
      expect(numberPropFinder, findsOneWidget);

      expectWidgetToBeInHorizontalLayout(tester, [stringPropFinder, numberPropFinder]);
    });

    testWidgets('Group layout renders label, description, and children', (tester) async {
      // GIVEN: a layout of type GROUP with label and description in options
      await pumpForm(tester, jsonSchema: UiSchemaLayoutData.jsonSchema, uiSchema: UiSchemaLayoutData.uiSchemaGroup);

      // THEN: should render group layout with label, description, and child controls
      final groupLayoutFinder = _layoutOfType(ui.LayoutType.GROUP);
      expect(groupLayoutFinder, findsOneWidget);

      final groupLabelFinder = find.formFieldText('Group Layout Label');
      final groupDescriptionFinder = find.formFieldText('Group Layout Description');
      final stringPropFinder = find.formFieldText('StringProp');
      final numberPropFinder = find.formFieldText('NumberProp');

      expect(groupLabelFinder, findsOneWidget);
      expect(groupDescriptionFinder, findsOneWidget);
      expect(stringPropFinder, findsOneWidget);
      expect(numberPropFinder, findsOneWidget);

      expectWidgetsInVerticalOrder(tester, [groupLabelFinder, stringPropFinder, numberPropFinder]);
    });

    testWidgets('Layouts respect showOn rules', (tester) async {
      // GIVEN: a layout with a showOn rule that depends on the value of showLayout boolean property
      await pumpForm(tester, jsonSchema: UiSchemaLayoutData.jsonSchema, uiSchema: UiSchemaLayoutData.uiSchemaLayoutShowOn);

      // THEN: the layout and its children should initially be hidden
      final conditionalLabelFinder = find.formFieldText('Conditional Layout Label');
      final conditionalFieldFinder = find.formFieldText('ConditionalString');

      expectShowOnHidden(tester, conditionalLabelFinder);
      expectShowOnHidden(tester, conditionalFieldFinder);

      // WHEN: the button is tapped
      final switchFinder = _findFormBuilderField<FormBuilderSwitch>('showLayout');
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // THEN: the layout and its children should be visible
      expectShowOnVisible(tester, conditionalLabelFinder);
      expectShowOnVisible(tester, conditionalFieldFinder);
    });

    testWidgets('Ui Schema Layout on object doesn\'t render duplicated labels', (tester) async {
      // GIVEN: a layout that is applied to an object control, where the layout has an label and the object implicitly has a label (the object property name in the jsonSchema)
      await pumpForm(tester, jsonSchema: UiSchemaLayoutData.jsonSchema, uiSchema: UiSchemaLayoutData.uiSchemaLayoutOnObject);

      // THEN: should only render the layout label which takes precedence over the implicit object label
      expect(find.formFieldText('Layout Label'), findsOneWidget);
      expect(find.formFieldText('ObjectProp'), findsNothing);
      expect(find.formFieldText('NestedString'), findsOneWidget);
    });
  });
}

/// Helper to check that given finders are in a horizontal layout (side by side) within a certain margin
Finder _layoutOfType(ui.LayoutType type) {
  return find.byWidgetPredicate(
    (widget) => widget is FormLayout && widget.layout.type == type,
    description: 'FormLayout for ${type.name}',
  );
}

/// Helper to check that given finders are in a horizontal layout (side by side) within a certain margin
Finder _findFormBuilderField<T extends FormBuilderField<dynamic>>(String property) {
  final candidates = <String>{
    property,
    '/properties/$property',
    '#/properties/$property',
  };

  return find.byWidgetPredicate(
    (widget) => widget is T && candidates.contains(widget.name),
    description: 'FormBuilder field for "$property"',
  );
}
