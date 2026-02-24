import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

import '../../../utils/test_utils.dart';

class WizardTestData {
  static const stepTitles = ['Personal Info', 'Additional Details', 'Review & Submit'];

  static final jsonSchema = JsonSchema.create({
    'type': 'object',
    'properties': {
      'firstName': {'type': 'string', 'title': 'First Name'},
      'age': {'type': 'integer', 'title': 'Age'},
      'email': {'type': 'string', 'format': 'email', 'title': 'Email'},
      'notes': {'type': 'string', 'title': 'Notes'},
    },
    'required': ['firstName', 'age', 'email'],
  });

  static final uiSchema = ui.UiSchema(
    version: '2.0',
    layout: ui.Wizard(
      type: ui.WizardType.WIZARD,
      options: ui.WizardOptions(pageTitles: stepTitles),
      pages: [
        _wizardPage(
          controls: [
            ui.Control(scope: scopePath(['firstName']))
          ],
        ),
        _wizardPage(
          controls: [
            ui.Control(scope: scopePath(['age']))
          ],
        ),
        _wizardPage(
          controls: [
            ui.Control(scope: scopePath(['email'])),
            ui.Control(scope: scopePath(['notes'])),
          ],
          includeSubmit: true,
        ),
      ],
    ),
  );

  static ui.Layout _wizardPage({required List<ui.LayoutElement> controls, bool includeSubmit = false}) {
    final pageElements = <ui.LayoutElement>[
      ...controls,
      _navigationRow(includeSubmit: includeSubmit),
    ];

    return ui.Layout(
      type: ui.LayoutType.VERTICAL_LAYOUT,
      elements: pageElements,
    );
  }

  static ui.Layout _navigationRow({bool includeSubmit = false}) {
    final buttons = <ui.LayoutElement>[
      _backButton(),
      _nextButton(),
    ];

    if (includeSubmit) {
      buttons.add(_submitButton());
    }

    return ui.Layout(
      type: ui.LayoutType.HORIZONTAL_LAYOUT,
      elements: buttons,
    );
  }

  static ui.Button _backButton() {
    return ui.Button(
      buttonType: ui.TheButtonsType.PREVIOUS_WIZARD_PAGE,
      text: 'Back',
      options: ui.ButtonOptions(variant: ui.ColorVariants.OUTLINE_PRIMARY),
    );
  }

  static ui.Button _nextButton() {
    return ui.Button(
      buttonType: ui.TheButtonsType.NEXT_WIZARD_PAGE,
      text: 'Next',
      options: ui.ButtonOptions(variant: ui.ColorVariants.PRIMARY),
    );
  }

  static ui.Button _submitButton() {
    return ui.Button(
      buttonType: ui.TheButtonsType.SUBMIT,
      text: 'Submit Wizard',
      options: ui.ButtonOptions(
        variant: ui.ColorVariants.SUCCESS,
        submitOptions: ui.SubmitOptions(action: 'save'),
      ),
    );
  }
}
