import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

import '../../../../utils/test_utils.dart';

class UiSchemaControlObjectData {
  // UI schema referencing the whole object
  static final uiSchemaWholeObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Registration Form"),
    elements: [
      ui.Control(scope: scopePath(["person"]))
    ],
  );

  // UI schema referencing elements within the object
  static final uiSchemaObjectElements = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Registration Form"),
    elements: [
      ui.Control(scope: scopePath(["person", "firstName"])),
      ui.Control(scope: scopePath(["person", "lastName"])),
    ],
  );

  // UI schema for dynamic dependency: button shows person.lastName using showOn form outer scope
  static final uiSchemaDynamicOuterToObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Registration Form"),
    elements: [
      ui.Control(scope: scopePath(["switchOuter"])),
      ui.Control(
        scope: scopePath(["person", "firstName"]),
        showOn: ui.ShowOnProperty(path: scopePath(["switchOuter"]), type: ui.ShowOnFunctionType.EQUALS, referenceValue: true),
      )
    ],
  );

  // UI schema for dynamic dependency: button shows person.lastName using showOn from object
  static final uiSchemaDynamicObjectToObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["person", "switchObject"])),
      ui.Control(
        scope: scopePath(["person", "lastName"]),
        showOn: ui.ShowOnProperty(path: scopePath(["person", "switchObject"]), type: ui.ShowOnFunctionType.EQUALS, referenceValue: true),
      )
    ],
  );

  // UI schema for dynamic dependency: button shows name using showOn from object to outer scope
  static final uiSchemaDynamicObjectToOuter = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["person", "switchObject"])),
      ui.Control(
        scope: scopePath(["name"]),
        showOn: ui.ShowOnProperty(path: scopePath(["person", "switchObject"]), type: ui.ShowOnFunctionType.EQUALS, referenceValue: true),
      )
    ],
  );
}

class UiSchemaControlNestedObjectData {
  // UI schema referencing the whole nested object
  static final uiSchemaWholeObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["address"]))
    ],
  );

  // UI schema referencing the whole nested object
  static final uiSchemaWholeNestedObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["address", "country"]))
    ],
  );

  // UI schema referencing elements within the nested object
  static final uiSchemaObjectElements = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["address", "street"])),
      ui.Control(scope: scopePath(["address", "city"])),
      ui.Control(scope: scopePath(["address", "country", "name"])),
      ui.Control(scope: scopePath(["address", "country", "code"])),
    ],
  );

  // UI schema for dynamic dependency: switchOuter shows address.street
  static final uiSchemaDynamicOuterToNestedObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["switchOuter"])),
      ui.Control(
        scope: scopePath(["address", "country", "name"]),
        showOn: ui.ShowOnProperty(path: scopePath(["switchOuter"]), type: ui.ShowOnFunctionType.EQUALS, referenceValue: true),
      )
    ],
  );

  // UI schema for dynamic dependency: switchObject shows country.name
  static final uiSchemaDynamicObjectToNestedObject = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["address", "switchObject"])),
      ui.Control(
        scope: scopePath(["address", "country", "name"]),
        showOn: ui.ShowOnProperty(path: scopePath(["address", "switchObject"]), type: ui.ShowOnFunctionType.EQUALS, referenceValue: true),
      )
    ],
  );

  // UI schema for dynamic dependency: switchNestedObject shows country.code
  static final uiSchemaDynamicNestedObjectToElement = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["address", "country", "switchNestedObject"])),
      ui.Control(
        scope: scopePath(["address", "country", "code"]),
        showOn: ui.ShowOnProperty(
          path: scopePath(["address", "country", "switchNestedObject"]),
          type: ui.ShowOnFunctionType.EQUALS,
          referenceValue: true,
        ),
      )
    ],
  );

  // UI schema for dynamic dependency: switchNestedObject shows outerName on outer scope
  static final uiSchemaDynamicNestedObjectToOuter = getBaseUiSchemaLayout(
    options: ui.LayoutOptions(label: "Address Form"),
    elements: [
      ui.Control(scope: scopePath(["address", "country", "switchNestedObject"])),
      ui.Control(
        scope: scopePath(["outerName"]),
        showOn: ui.ShowOnProperty(
          path: scopePath(["address", "country", "switchNestedObject"]),
          type: ui.ShowOnFunctionType.EQUALS,
          referenceValue: true,
        ),
      )
    ],
  );
}
