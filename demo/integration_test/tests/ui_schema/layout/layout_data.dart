import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import '../../../utils/test_utils.dart';

class UiSchemaLayoutData {
  static final jsonSchema = JsonSchema.create({
    "type": "object",
    "properties": {
      "stringProp": {"type": "string"},
      "objectProp": {
        "type": "object",
        "properties": {
          "nestedString": {"type": "string"}
        }
      },
      "numberProp": {"type": "number"},
      "conditionalString": {"type": "string"},
      "showLayout": {"type": "boolean"},
    }
  });

  static final uiSchema = getBaseUiSchemaLayout(elements: [
    ui.Control(scope: scopePath(["stringProp"])),
    ui.Layout(
        type: ui.LayoutType.VERTICAL_LAYOUT,
        elements: [
          ui.Control(scope: scopePath(["objectProp", "nestedString"])),
          ui.Divider(),
          ui.Control(scope: scopePath(["numberProp"])),
        ],
        options: ui.LayoutOptions(label: "Nested Layout Label", description: "Nested Layout Description"))
  ], options: ui.LayoutOptions(label: "Outer Layout Label", description: "Outer Layout description"));

  static final uiSchemaHorizontal = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(["stringProp"])),
      ui.Control(scope: scopePath(["numberProp"])),
    ],
    type: ui.LayoutType.HORIZONTAL_LAYOUT,
    options: ui.LayoutOptions(label: "Horizontal Layout"),
  );

  static final uiSchemaGroup = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(["stringProp"])),
      ui.Control(scope: scopePath(["numberProp"])),
    ],
    type: ui.LayoutType.GROUP,
    options: ui.LayoutOptions(
      label: "Group Layout Label",
      description: "Group Layout Description",
    ),
  );

  static final uiSchemaLayoutShowOn = getBaseUiSchemaLayout(
    elements: [
      ui.Control(scope: scopePath(["showLayout"])),
      ui.Layout(
        type: ui.LayoutType.VERTICAL_LAYOUT,
        options: ui.LayoutOptions(label: "Conditional Layout Label"),
        showOn: ui.ShowOnProperty(
          path: scopePath(["showLayout"]),
          type: ui.ShowOnFunctionType.EQUALS,
          referenceValue: true,
        ),
        elements: [
          ui.Control(scope: scopePath(["conditionalString"])),
        ],
      ),
    ],
  );

  static final uiSchemaLayoutOnObject = getBaseUiSchemaLayout(elements: [
    ui.Control(scope: scopePath(["objectProp"])),
  ], options: ui.LayoutOptions(label: "Layout Label"));
}
