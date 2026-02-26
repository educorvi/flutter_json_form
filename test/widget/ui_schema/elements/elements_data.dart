import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

import '../../utils/test_utils.dart';

class UiSchemaElementsData {
  static const _htmlHeadline = 'Welcome to the layout elements demo';

  static final jsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'show': {'type': 'boolean', 'title': 'Show Element'},
      'firstName': {'type': 'string', 'title': 'First Name'},
      'lastName': {'type': 'string', 'title': 'Last Name'},
    },
    'required': ['firstName'],
  });

  static ui.UiSchema htmlRendererUiSchema = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(['show'])),
      ui.HtmlRenderer(
        htmlData: '<h2>$_htmlHeadline</h2>',
        showOn: _showOn(),
      ),
    ],
  );

  static ui.UiSchema dividerUiSchema = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(['show'])),
      ui.Divider(showOn: _showOn()),
    ],
  );

  static ui.UiSchema buttonGroupHorizontalUiSchema = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(['show'])),
      ui.Buttongroup(
        buttons: _groupButtons(),
        showOn: _showOn(),
      ),
    ],
  );

  static ui.UiSchema buttonGroupVerticalUiSchema = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(['show'])),
      ui.Buttongroup(
        buttons: _groupButtons(),
        showOn: _showOn(),
        options: ui.ButtongroupOptions(vertical: true),
      ),
    ],
  );

  static ui.UiSchema buttonUiSchema({
    required ui.TheButtonsType buttonType,
    String text = '',
    ui.ButtonOptions? options,
  }) {
    return getBaseUiSchemaLayout(
      elements: [
        ui.Control(scope: scopePath(['firstName'])),
        ui.Control(scope: scopePath(['show'])),
        ui.Button(
          buttonType: buttonType,
          text: text,
          options: options,
          showOn: _showOn(),
        ),
      ],
    );
  }

  static ui.UiSchema wizardNavigationUiSchema = ui.UiSchema(
    version: '2.0',
    layout: ui.Wizard(
      type: ui.WizardType.WIZARD,
      options: ui.WizardOptions(pageTitles: const ['Step One', 'Step Two']),
      pages: [
        ui.Layout(
          type: ui.LayoutType.VERTICAL_LAYOUT,
          elements: [
            ui.Control(scope: scopePath(['show'])),
            ui.Control(scope: scopePath(['firstName'])),
            ui.Button(
              buttonType: ui.TheButtonsType.NEXT_WIZARD_PAGE,
              text: 'Go Next',
              showOn: _showOn(),
            ),
          ],
        ),
        ui.Layout(
          type: ui.LayoutType.VERTICAL_LAYOUT,
          elements: [
            ui.Control(scope: scopePath(['lastName'])),
            ui.Button(
              buttonType: ui.TheButtonsType.PREVIOUS_WIZARD_PAGE,
              text: 'Go Back',
              showOn: _showOn(),
            ),
            ui.Button(
              buttonType: ui.TheButtonsType.SUBMIT,
              text: 'Finish Wizard',
              showOn: _showOn(),
              options: ui.ButtonOptions(
                submitOptions: ui.SubmitOptions(action: 'save'),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  static List<ui.Button> _groupButtons() {
    return [
      ui.Button(buttonType: ui.TheButtonsType.SUBMIT, text: 'Primary Action'),
      ui.Button(buttonType: ui.TheButtonsType.RESET, text: 'Secondary Action'),
    ];
  }

  static ui.ShowOnProperty _showOn() {
    return ui.ShowOnProperty(
      path: scopePath(['show']),
      type: ui.ShowOnFunctionType.EQUALS,
      referenceValue: true,
    );
  }
}
