import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';
import '../../utils/test_utils.dart';

class BaseData {
  //  static JsonSchema getJsonSchema() {
  //   final schema = JsonSchema.empty();
  //   schema.title = "Registration";
  //   return schema;
  // }

  static final jsonSchema = JsonSchema.create({
    "name": "registration",
    "title": "Registration",
    "type": "object",
    "description": "A simple registration form example",
    "\$schema": "http://json-schema.org/draft-07/schema#",
    "properties": {
      "name": {"type": "string", "title": "Name"},
      "newsletter": {"type": "boolean", "default": true, "title": "Newsletter"},
      "email": {"type": "string", "format": "email"},
      "timeMissingInUiSchema": {"type": "string", "format": "date-time"}
    },
    "required": ["name", "email"]
  });

  static final uiSchema = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: "#/properties/name", options: ui.Options(formattingOptions: ui.ControlFormattingOptions(placeholder: "Full Name"))),
      ui.Control(scope: "#/properties/newsletter", options: ui.Options(formattingOptions: ui.ControlFormattingOptions(label: true))),
      ui.Control(
        scope: "#/properties/email",
        showOn: ui.ShowOnProperty(path: "#/properties/newsletter", type: ui.ShowOnFunctionType.EQUALS, referenceValue: true),
      ),
      ui.Button(
          buttonType: ui.TheButtonsType.SUBMIT,
          text: "Sign Up",
          options: ui.ButtonOptions(variant: ui.ColorVariants.PRIMARY, submitOptions: ui.SubmitOptions(action: "save")))
    ],
  );

  static final uiSchemaOld = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Registration Form"},
      "elements": [
        {
          "type": "Control",
          "scope": "#/properties/name",
          "options": {"placeholder": "Full Name"}
        },
        {
          "type": "Control",
          "scope": "#/properties/newsletter",
          "options": {"label": "Sign up for newsletter"}
        },
        {
          "type": "Control",
          "scope": "#/properties/email",
          "showOn": {"path": "#/properties/newsletter", "type": "EQUALS", "referenceValue": true},
        },
        {
          "type": "Button",
          "buttonType": "submit",
          "text": "Sign Up",
          "options": {
            "variant": "primary",
            "submitOptions": {"action": "save"}
          }
        }
      ]
    }
  };
}
