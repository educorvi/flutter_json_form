import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

import '../../../../utils/test_utils.dart';

class UiSchemaControlElementsData {
  static final JsonSchema enumJsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'favoriteDrink': {
        'type': 'string',
        'title': 'Favorite Drink',
        'enum': _drinkValues,
      },
    },
  });

  static final JsonSchema fileUploadJsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'profilePicture': {
        'type': 'string',
        'title': 'Profile Picture',
        'format': 'uri',
      },
      'receipts': {
        'type': 'array',
        'title': 'Receipts',
        'items': {
          'type': 'string',
          'format': 'uri',
        },
        'minItems': 0,
        'maxItems': 3,
      },
    },
  });

  static final JsonSchema arrayJsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'translations': {
        'type': 'array',
        'title': 'Translations',
        'items': {
          'type': 'string',
          'title': 'Translation',
        },
      },
    },
  });

  static final JsonSchema inputJsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'timeInput': {'type': 'string', 'title': 'Preferred Time'},
      'dateInput': {'type': 'string', 'title': 'Preferred Date'},
      'dateTimeInput': {'type': 'string', 'title': 'Date & Time'},
      'emailField': {'type': 'string', 'title': 'Email Address'},
      'passwordField': {'type': 'string', 'title': 'Password'},
      'urlField': {'type': 'string', 'title': 'Website'},
      'telField': {'type': 'string', 'title': 'Phone Number'},
      'searchField': {'type': 'string', 'title': 'Search Term'},
      'colorField': {'type': 'string', 'title': 'Accent Color'},
      'multiFreeText': {'type': 'string', 'title': 'Short Message'},
      'richDescription': {'type': 'string', 'title': 'Detailed Description'},
      'autocompleteEmail': {'type': 'string', 'title': 'Account Email'},
      'numericRange': {
        'type': 'number',
        'title': 'Satisfaction',
        'minimum': 0,
        'maximum': 10,
        'multipleOf': 1,
      },
      'leftAligned': {'type': 'string', 'title': 'Left Align'},
      'rightAligned': {'type': 'string', 'title': 'Right Align'},
    },
  });

  static final JsonSchema formattingJsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'labeledField': {'type': 'string', 'title': 'No Label Field'},
      'htmlField': {'type': 'string', 'title': 'Html Target'},
      'helpField': {'type': 'string', 'title': 'Help Target'},
      'placeholderField': {'type': 'string', 'title': 'Placeholder Field'},
      'hiddenField': {'type': 'string', 'title': 'Hidden Field'},
      'decoratedField': {'type': 'string', 'title': 'Decorated Field'},
      'disabledField': {'type': 'string', 'title': 'Disabled Field'},
      'forceRequiredField': {'type': 'string', 'title': 'Force Required'},
      'arrayNotes': {
        'type': 'array',
        'title': 'Notes',
        'minItems': 1,
        'items': {
          'type': 'object',
          'properties': {
            'note': {'type': 'string', 'title': 'Note'},
            'showDetails': {'type': 'boolean', 'title': 'Show Extra Details'},
            'extraDetails': {'type': 'string', 'title': 'Extra Details'},
          },
        },
      },
    },
  });

  static ui.UiSchema enumRadioWithTitlesUiSchema = _singleControl(
    property: 'favoriteDrink',
    options: ui.Options(
      enumOptions: ui.EnumOptions(
        displayAs: ui.DisplayAs.RADIOBUTTONS,
        enumTitles: const {
          'espresso': 'Espresso Shot',
          'tea': 'Tea',
          'water': 'Sparkling Water',
        },
      ),
    ),
  );

  static ui.UiSchema enumRadioStackedUiSchema = _singleControl(
    property: 'favoriteDrink',
    options: ui.Options(
      enumOptions: ui.EnumOptions(
        displayAs: ui.DisplayAs.RADIOBUTTONS,
        stacked: true,
      ),
    ),
  );

  static ui.UiSchema enumSelectUiSchema = _singleControl(
    property: 'favoriteDrink',
    options: ui.Options(
      enumOptions: ui.EnumOptions(
        displayAs: ui.DisplayAs.SELECT,
      ),
    ),
  );

  static ui.UiSchema enumSwitchesUiSchema = _singleControl(
    property: 'favoriteDrink',
    options: ui.Options(
      enumOptions: ui.EnumOptions(displayAs: ui.DisplayAs.SWITCHES),
    ),
  );

  static ui.UiSchema enumButtonsUiSchema = _singleControl(
    property: 'favoriteDrink',
    options: ui.Options(
      enumOptions: ui.EnumOptions(
        displayAs: ui.DisplayAs.BUTTONS,
        stacked: true,
        buttonVariant: ui.ColorVariants.OUTLINE_SECONDARY,
      ),
    ),
  );

  static ui.UiSchema singleUploadWithLimitsUiSchema = _singleControl(
    property: 'profilePicture',
    options: ui.Options(
      fileUploadOptions: ui.FileUploadOptions(
        maxFileSize: _oneMegabyte,
        acceptedFileType: '.pdf, .png',
      ),
    ),
  );

  static ui.UiSchema receiptsDefaultArrayUiSchema = _singleControl(property: 'receipts');

  static ui.UiSchema receiptsCollapsedUiSchema = _singleControl(
    property: 'receipts',
    options: ui.Options(
      fileUploadOptions: ui.FileUploadOptions(displayAsSingleUploadField: true),
    ),
  );

  static ui.UiSchema translationsArrayUiSchema = _singleControl(
    property: 'translations',
    options: ui.Options(
      arrayOptions: ui.ArrayOptions(addButtonText: 'Add translation'),
    ),
  );

  static ui.UiSchema inputOptionsUiSchema = getBaseUiSchemaLayout(
    elements: [
      _control(
        'timeInput',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.TIME)),
      ),
      _control(
        'dateInput',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.DATE)),
      ),
      _control(
        'dateTimeInput',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.DATETIME_LOCAL)),
      ),
      _control(
        'emailField',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.EMAIL)),
      ),
      _control(
        'passwordField',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.PASSWORD)),
      ),
      _control(
        'urlField',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.URL)),
      ),
      _control(
        'telField',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.TEL)),
      ),
      _control(
        'searchField',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.SEARCH)),
      ),
      _control(
        'colorField',
        options: ui.Options(inputOptions: ui.InputOptions(format: ui.Format.COLOR)),
      ),
      _control(
        'multiFreeText',
        options: ui.Options(inputOptions: ui.InputOptions(multi: true)),
      ),
      _control(
        'richDescription',
        options: ui.Options(inputOptions: ui.InputOptions(multi: 5)),
      ),
      _control(
        'autocompleteEmail',
        options: ui.Options(inputOptions: ui.InputOptions(autocomplete: ui.Autocomplete.EMAIL)),
      ),
      _control(
        'numericRange',
        options: ui.Options(inputOptions: ui.InputOptions(range: true)),
      ),
      _control(
        'leftAligned',
        options: ui.Options(inputOptions: ui.InputOptions(textAlign: ui.TextAlign.LEFT)),
      ),
      _control(
        'rightAligned',
        options: ui.Options(inputOptions: ui.InputOptions(textAlign: ui.TextAlign.RIGHT)),
      ),
    ],
  );

  static ui.UiSchema formattingOptionsUiSchema = getBaseUiSchemaLayout(
    elements: [
      _control(
        'labeledField',
        options: ui.Options(formattingOptions: ui.ControlFormattingOptions(label: false)),
      ),
      _control(
        'htmlField',
        options: ui.Options(
          formattingOptions: ui.ControlFormattingOptions(
            preHtml: '<p>Rendered before</p>',
            postHtml: '<p>Rendered after</p>',
          ),
        ),
      ),
      _control(
        'helpField',
        options: ui.Options(
          formattingOptions: ui.ControlFormattingOptions(
            help: ui.ControlFormattingOptionsHelp(
              label: 'i',
              text: 'This is additional help',
              variant: ui.BaseVariants.INFO,
            ),
          ),
        ),
      ),
      _control(
        'placeholderField',
        options: ui.Options(formattingOptions: ui.ControlFormattingOptions(placeholder: 'Placeholder text')),
      ),
      _control(
        'hiddenField',
        options: ui.Options(formattingOptions: ui.ControlFormattingOptions(hidden: true)),
      ),
      _control(
        'decoratedField',
        options: ui.Options(
          formattingOptions: ui.ControlFormattingOptions(
            prepend: 'USD',
            append: '/kg',
          ),
        ),
      ),
      _control(
        'disabledField',
        options: ui.Options(formattingOptions: ui.ControlFormattingOptions(disabled: true)),
      ),
      _control(
        'forceRequiredField',
        options: ui.Options(formattingOptions: ui.ControlFormattingOptions(forceRequired: true)),
      ),
      _arrayControlWithOverrides(),
    ],
  );

  static List<String> get _drinkValues => const ['espresso', 'tea', 'water'];

  static const double _oneMegabyte = 1024 * 1024;

  static ui.UiSchema _singleControl({required String property, ui.Options? options, ui.ShowOnProperty? showOn}) {
    return getBaseUiSchemaLayout(
      elements: [
        _control(property, options: options, showOn: showOn),
      ],
    );
  }

  static ui.Control _control(String property, {ui.Options? options, ui.ShowOnProperty? showOn}) {
    return ui.Control(
      scope: scopePath([property]),
      options: options,
      showOn: showOn,
    );
  }

  static ui.Control _arrayControlWithOverrides() {
    final arrayScope = scopePath(['arrayNotes']);
    final noteScope = _arrayChildScope('arrayNotes', 'note');
    final extraScope = _arrayChildScope('arrayNotes', 'extraDetails');
    final toggleScope = _arrayChildScope('arrayNotes', 'showDetails');

    return ui.Control(
      scope: arrayScope,
      options: ui.Options(
        formattingOptions: ui.ControlFormattingOptions(
          descendantControlOverrides: {
            arrayScope: ui.DescendantControlOverrides(
              options: ui.Options(
                formattingOptions: ui.ControlFormattingOptions(
                  descendantControlOverrides: {
                    noteScope: ui.DescendantControlOverrides(
                      options: ui.Options(
                        formattingOptions: ui.ControlFormattingOptions(
                          placeholder: 'Add note inside array',
                        ),
                      ),
                    ),
                    extraScope: ui.DescendantControlOverrides(
                      showOn: ui.ShowOnProperty(
                        path: toggleScope,
                        type: ui.ShowOnFunctionType.EQUALS,
                        referenceValue: true,
                      ),
                    ),
                  },
                ),
              ),
            ),
          },
        ),
      ),
    );
  }

  static String _arrayChildScope(String arrayProperty, String childProperty) {
    return '${scopePath([arrayProperty])}/items/properties/$childProperty';
  }
}
