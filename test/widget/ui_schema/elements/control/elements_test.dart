import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/custom_form_input_fields/form_builder_segmented_button.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_help.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/complex_elements/form_array/form_array_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_color_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_segmented_control_field.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/test_utils.dart';
import 'elements_data.dart';

void main() {
  ensureWidgetTestBinding();

  group('Enum option controls', () {
    testWidgets('enum titles replace option labels', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.enumJsonSchema,
        uiSchema: UiSchemaControlElementsData.enumRadioWithTitlesUiSchema,
      );

      expect(find.text('Espresso Shot'), findsOneWidget);
      expect(find.text('Sparkling Water'), findsOneWidget);
      expect(find.text('Tea'), findsOneWidget);
    });

    testWidgets('stacked radio buttons render vertically', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.enumJsonSchema,
        uiSchema: UiSchemaControlElementsData.enumRadioStackedUiSchema,
      );

      final radioGroup = tester.widget<FormBuilderRadioGroup>(_findFormControl('favoriteDrink'));
      expect(radioGroup.orientation, OptionsOrientation.vertical);
    });

    testWidgets('select display renders dropdown widget', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.enumJsonSchema,
        uiSchema: UiSchemaControlElementsData.enumSelectUiSchema,
      );

      _expectFormControlType<FormBuilderDropdown<dynamic>>(tester, property: 'favoriteDrink');
    });

    testWidgets('switches display uses segmented button widget', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.enumJsonSchema,
        uiSchema: UiSchemaControlElementsData.enumSwitchesUiSchema,
      );

      expect(
        find.byWidgetPredicate((widget) => widget is FormBuilderSegmentedButton<dynamic>),
        findsOneWidget,
      );
    });

    testWidgets('button variant stays attached to segmented control', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.enumJsonSchema,
        uiSchema: UiSchemaControlElementsData.enumButtonsUiSchema,
      );

      final segmentedControl = tester.widget<FormSegmentedControlField>(find.byType(FormSegmentedControlField));
      expect(segmentedControl.formFieldContext.options?.enumOptions?.buttonVariant, ui.ColorVariants.OUTLINE_SECONDARY);

      final stackedBuilder = tester.widget<FormBuilderSegmentedButton<dynamic>>(
        find.byWidgetPredicate((widget) => widget is FormBuilderSegmentedButton<dynamic>),
      );
      expect(stackedBuilder.stacked, isTrue);
    });
  });

  group('File upload options', () {
    testWidgets('max file size validation rejects oversized files', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.fileUploadJsonSchema,
        uiSchema: UiSchemaControlElementsData.singleUploadWithLimitsUiSchema,
      );

      await _setFilePickerValue(
        tester,
        'profilePicture',
        [
          _createFile('too_large.pdf', sizeInBytes: (1.5 * 1024 * 1024).round()),
        ],
      );

      final pickerState = tester.state<FormFieldState<List<PlatformFile>>>(_findFormControl('profilePicture'));
      final formState = _formState(tester);
      expect(formState.saveAndValidate(), isFalse);
      expect(pickerState.hasError, isTrue);

      await _setFilePickerValue(
        tester,
        'profilePicture',
        [_createFile('valid.pdf', sizeInBytes: 200 * 1024)],
      );
      expect(formState.saveAndValidate(), isTrue);
      expect(pickerState.hasError, isFalse);
    });

    testWidgets('array upload renders repeater by default', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.fileUploadJsonSchema,
        uiSchema: UiSchemaControlElementsData.receiptsDefaultArrayUiSchema,
      );

      expect(find.byType(FormArrayField), findsOneWidget);
    });

    testWidgets('displayAsSingleUploadField collapses array into picker', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.fileUploadJsonSchema,
        uiSchema: UiSchemaControlElementsData.receiptsCollapsedUiSchema,
      );

      final picker = tester.widget<FormBuilderFilePicker>(_findFormControl('receipts'));
      expect(picker.allowMultiple, isTrue);
      expect(picker.maxFiles, 3);
    });

    testWidgets('accepted file type configuration populates allowed extensions', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.fileUploadJsonSchema,
        uiSchema: UiSchemaControlElementsData.singleUploadWithLimitsUiSchema,
      );

      final picker = tester.widget<FormBuilderFilePicker>(_findFormControl('profilePicture'));
      expect(picker.allowedExtensions, equals(['.pdf', '.png']));
    });
  });

  group('Array options', () {
    testWidgets('custom add button text is rendered', (tester) async {
      await pumpForm(
        tester,
        jsonSchema: UiSchemaControlElementsData.arrayJsonSchema,
        uiSchema: UiSchemaControlElementsData.translationsArrayUiSchema,
      );

      expect(find.text('Add translation'), findsOneWidget);
    });
  });

  group('Input options', () {
    testWidgets('date and time formats render specialized pickers', (tester) async {
      await _pumpInputForm(tester);

      _expectFormControlType<FormBuilderDateTimePicker>(tester, property: 'timeInput');
      _expectFormControlType<FormBuilderDateTimePicker>(tester, property: 'dateInput');
      _expectFormControlType<FormBuilderDateTimePicker>(tester, property: 'dateTimeInput');

      final timePicker = tester.widget<FormBuilderDateTimePicker>(_findFormControl('timeInput'));
      final datePicker = tester.widget<FormBuilderDateTimePicker>(_findFormControl('dateInput'));
      final dateTimePicker = tester.widget<FormBuilderDateTimePicker>(_findFormControl('dateTimeInput'));

      expect(timePicker.inputType, InputType.time);
      expect(datePicker.inputType, InputType.date);
      expect(dateTimePicker.inputType, InputType.both);
    });

    testWidgets('text field formats customize keyboards', (tester) async {
      await _pumpInputForm(tester);

      final emailField = tester.widget<FormBuilderTextField>(_findFormControl('emailField'));
      final passwordField = tester.widget<FormBuilderTextField>(_findFormControl('passwordField'));
      final urlField = tester.widget<FormBuilderTextField>(_findFormControl('urlField'));
      final telField = tester.widget<FormBuilderTextField>(_findFormControl('telField'));
      final searchField = tester.widget<FormBuilderTextField>(_findFormControl('searchField'));

      expect(emailField.keyboardType, TextInputType.emailAddress);
      expect(passwordField.obscureText, isTrue);
      expect(urlField.keyboardType, TextInputType.url);
      expect(telField.keyboardType, TextInputType.phone);
      expect(searchField.keyboardType, TextInputType.text);
    });

    testWidgets('color format renders a color picker', (tester) async {
      await _pumpInputForm(tester);
      expect(find.byType(FormColorPickerField), findsOneWidget);
    });

    testWidgets('multi option increases max lines', (tester) async {
      await _pumpInputForm(tester);
      final shortText = tester.widget<FormBuilderTextField>(_findFormControl('multiFreeText'));
      final longText = tester.widget<FormBuilderTextField>(_findFormControl('richDescription'));

      expect(shortText.maxLines, 2);
      expect(longText.maxLines, 5);
    });

    testWidgets('autocomplete hint is forwarded to text field', (tester) async {
      await _pumpInputForm(tester);
      final autocompleteField = tester.widget<FormBuilderTextField>(_findFormControl('autocompleteEmail'));
      expect(autocompleteField.autofillHints, contains(AutofillHints.email));
    });

    testWidgets('range option renders a slider', (tester) async {
      await _pumpInputForm(tester);
      _expectFormControlType<FormBuilderSlider>(tester, property: 'numericRange');
    });

    testWidgets('text alignment option applies to text fields', (tester) async {
      await _pumpInputForm(tester);
      final leftField = tester.widget<FormBuilderTextField>(_findFormControl('leftAligned'));
      final rightField = tester.widget<FormBuilderTextField>(_findFormControl('rightAligned'));

      expect(leftField.textAlign, TextAlign.left);
      expect(rightField.textAlign, TextAlign.right);
    });
  });

  group('Control formatting options', () {
    testWidgets('label false removes label text', (tester) async {
      await _pumpFormattingForm(tester);
      final field = tester.widget<FormBuilderTextField>(_findFormControl('labeledField'));
      expect(field.decoration.labelText, isNull);
    });

    testWidgets('pre and post html blocks are rendered', (tester) async {
      await _pumpFormattingForm(tester);
      final widgets = tester.widgetList<HtmlWidget>(find.byType(HtmlWidget));
      expect(widgets.any((w) => w.html.contains('Rendered before')), isTrue);
      expect(widgets.any((w) => w.html.contains('Rendered after')), isTrue);
    });

    testWidgets('help option displays tooltip trigger', (tester) async {
      await _pumpFormattingForm(tester);
      expect(find.byType(FormHelp), findsOneWidget);
      expect(find.text('i'), findsOneWidget);
    });

    testWidgets('placeholder appears as hint text', (tester) async {
      await _pumpFormattingForm(tester);
      final field = tester.widget<FormBuilderTextField>(_findFormControl('placeholderField'));
      expect(field.decoration.hintText, 'Placeholder text');
    });

    testWidgets('hidden field stays invisible', (tester) async {
      await _pumpFormattingForm(tester);
      expect(_findFormControl('hiddenField'), findsNothing);
    });

    testWidgets('append and prepend text decorate the field', (tester) async {
      await _pumpFormattingForm(tester);
      final field = tester.widget<FormBuilderTextField>(_findFormControl('decoratedField'));
      expect(field.decoration.prefixText, 'USD');
      expect(field.decoration.suffixText, '/kg');
    });

    testWidgets('disabled formatting disables the control', (tester) async {
      await _pumpFormattingForm(tester);
      final fieldState = tester.state<FormBuilderFieldDecorationState<FormBuilderTextField, String>>(
        _findFormControl('disabledField'),
      );
      expect(fieldState.enabled, isFalse);
    });

    testWidgets('forceRequired enforces validation', (tester) async {
      await _pumpFormattingForm(tester);
      final fieldState = tester.state<FormFieldState<String>>(_findFormControl('forceRequiredField'));
      final formState = _formState(tester);
      expect(formState.saveAndValidate(), isFalse);
      expect(fieldState.hasError, isTrue);

      await enterTextAndSettle(tester, _findFormControl('forceRequiredField'), 'filled');
      expect(formState.saveAndValidate(), isTrue);
      expect(fieldState.hasError, isFalse);
    });

    testWidgets('descendant overrides add placeholder inside arrays', (tester) async {
      await _pumpFormattingForm(tester);
      final noteField = tester.widget<FormBuilderTextField>(_findArrayChildControl<FormBuilderTextField>('arrayNotes', 'note'));
      expect(noteField.decoration.hintText, 'Add note inside array');
    });

    testWidgets('descendant showOn toggles array child visibility', (tester) async {
      await _pumpFormattingForm(tester);

      final extraFinder = _findArrayChildControl<FormBuilderTextField>('arrayNotes', 'extraDetails');
      expectShowOnHidden(tester, extraFinder);

      await _setArraySwitchValue(tester, 'arrayNotes', 'showDetails', true);
      expectShowOnVisible(tester, extraFinder);
    });
  });
}

Future<void> _pumpInputForm(WidgetTester tester) async {
  await pumpForm(
    tester,
    jsonSchema: UiSchemaControlElementsData.inputJsonSchema,
    uiSchema: UiSchemaControlElementsData.inputOptionsUiSchema,
  );
}

Future<void> _pumpFormattingForm(WidgetTester tester) async {
  await pumpForm(
    tester,
    jsonSchema: UiSchemaControlElementsData.formattingJsonSchema,
    uiSchema: UiSchemaControlElementsData.formattingOptionsUiSchema,
  );
}

FlutterJsonFormState _formState(WidgetTester tester) {
  return tester.state<FlutterJsonFormState>(find.byType(FlutterJsonForm));
}

Finder _findFormControl(String property) {
  final candidates = <String>{
    property,
    '/properties/$property',
    '#/properties/$property',
  };

  return find.byWidgetPredicate(
    (widget) => widget is FormBuilderField && candidates.contains(widget.name),
    description: 'Form control for $property',
  );
}

Finder _findArrayChildControl<T extends FormBuilderField>(String arrayProperty, String childProperty) {
  final prefix = '${scopePath([arrayProperty])}/items/';
  final suffix = '/properties/$childProperty';
  return find.byWidgetPredicate(
    (widget) => widget is T && widget.name.startsWith(prefix) && widget.name.endsWith(suffix),
    description: 'Array $arrayProperty field $childProperty',
  );
}

void _expectFormControlType<T extends FormBuilderField>(WidgetTester tester, {required String property}) {
  final fieldFinder = _findFormControl(property);
  expect(fieldFinder, findsOneWidget, reason: 'Expected control for $property');
  final widget = tester.widget(fieldFinder);
  expect(widget, isA<T>());
}

Future<void> _setFilePickerValue(WidgetTester tester, String property, List<PlatformFile> files) async {
  final fieldState = tester.state<FormFieldState<List<PlatformFile>>>(_findFormControl(property));
  fieldState.didChange(files);
  await tester.pumpAndSettle();
}

Future<void> _setArraySwitchValue(WidgetTester tester, String arrayProperty, String childProperty, bool value) async {
  final controlFinder = _findArrayChildControl<FormBuilderSwitch>(arrayProperty, childProperty);
  final fieldState = tester.state<FormFieldState<bool>>(controlFinder);
  if (fieldState.value == value) {
    return;
  }

  final switchFinder = find.descendant(of: controlFinder, matching: find.byType(Switch));
  await tester.ensureVisible(switchFinder);
  await tester.tap(switchFinder);
  await tester.pumpAndSettle();
  expect(fieldState.value, value);
}

PlatformFile _createFile(String name, {required int sizeInBytes}) {
  return PlatformFile(
    name: name,
    size: sizeInBytes,
    bytes: Uint8List.fromList(List<int>.filled(sizeInBytes, 1)),
  );
}
