class ObjectData {
  static final jsonSchema = {
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "switchOuter": {"type": "boolean"},
      "person": {
        "type": "object",
        "properties": {
          "switchObject": {"type": "boolean"},
          "firstName": {"type": "string"},
          "lastName": {"type": "string"}
        }
      }
    }
  };

  // UI schema referencing the whole object
  static final uiSchemaWholeObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Registration Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/person"}
      ]
    }
  };

  // UI schema referencing elements within the object
  static final uiSchemaObjectElements = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Registration Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/person/properties/firstName"},
        {"type": "Control", "scope": "#/properties/person/properties/lastName"}
      ]
    }
  };

  // UI schema for dynamic dependency: button shows person.lastName using showOn form outer scope
  static final uiSchemaDynamicOuterToObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Registration Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/switchOuter"},
        {
          "type": "Control",
          "scope": "#/properties/person/properties/firstName",
          "showOn": {"path": "#/properties/switchOuter", "type": "EQUALS", "referenceValue": true}
        }
      ]
    }
  };

  // UI schema for dynamic dependency: button shows person.lastName using showOn from object
  static final uiSchemaDynamicObjectToObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/person/properties/switchObject"},
        {
          "type": "Control",
          "scope": "#/properties/person/properties/lastName",
          "showOn": {"path": "#/properties/person/properties/switchObject", "type": "EQUALS", "referenceValue": true}
        },
      ]
    }
  };

  // UI schema for dynamic dependency: button shows name using showOn from object to outer scope
  static final uiSchemaDynamicObjectToOuter = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Registration Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/person/properties/switchObject"},
        {
          "type": "Control",
          "scope": "#/properties/name",
          "showOn": {"path": "#/properties/person/properties/switchObject", "type": "EQUALS", "referenceValue": true}
        }
      ]
    }
  };
}

class NestedObjectData {
  static final jsonSchema = {
    "type": "object",
    "properties": {
      "switchOuter": {"type": "boolean"},
      "outerName": {"type": "string"},
      "address": {
        "type": "object",
        "properties": {
          "switchObject": {"type": "boolean"},
          "street": {"type": "string"},
          "city": {"type": "string"},
          "country": {
            "type": "object",
            "properties": {
              "switchNestedObject": {"type": "boolean"},
              "name": {"type": "string"},
              "code": {"type": "string"}
            }
          }
        }
      }
    }
  };

  // UI schema referencing the whole nested object
  static final uiSchemaWholeObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/address"}
      ]
    }
  };

  // UI schema referencing the whole nested object
  static final uiSchemaWholeNestedObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/address/properties/country"}
      ]
    }
  };

  // UI schema referencing elements within the nested object
  static final uiSchemaObjectElements = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/address/properties/street"},
        {"type": "Control", "scope": "#/properties/address/properties/city"},
        {"type": "Control", "scope": "#/properties/address/properties/country/properties/name"},
        {"type": "Control", "scope": "#/properties/address/properties/country/properties/code"}
      ]
    }
  };

  // UI schema for dynamic dependency: switchOuter shows address.street
  static final uiSchemaDynamicOuterToNestedObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/switchOuter"},
        {
          "type": "Control",
          "scope": "#/properties/address/properties/country/properties/name",
          "showOn": {"path": "#/properties/switchOuter", "type": "EQUALS", "referenceValue": true}
        }
      ]
    }
  };

  // UI schema for dynamic dependency: switchObject shows country.name
  static final uiSchemaDynamicObjectToNestedObject = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/address/properties/switchObject"},
        {
          "type": "Control",
          "scope": "#/properties/address/properties/country/properties/name",
          "showOn": {"path": "#/properties/address/properties/switchObject", "type": "EQUALS", "referenceValue": true}
        }
      ]
    }
  };

  // UI schema for dynamic dependency: switchNestedObject shows country.code
  static final uiSchemaDynamicNestedObjectToElement = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/address/properties/country/properties/switchNestedObject"},
        {
          "type": "Control",
          "scope": "#/properties/address/properties/country/properties/code",
          "showOn": {"path": "#/properties/address/properties/country/properties/switchNestedObject", "type": "EQUALS", "referenceValue": true}
        }
      ]
    }
  };

  static final uiSchemaDynamicNestedObjectToOuter = {
    "version": "2.0",
    "\$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
    "layout": {
      "type": "Group",
      "options": {"label": "Address Form"},
      "elements": [
        {"type": "Control", "scope": "#/properties/address/properties/country/properties/switchNestedObject"},
        {
          "type": "Control",
          "scope": "#/properties/outerName",
          "showOn": {"path": "#/properties/address/properties/country/properties/switchNestedObject", "type": "EQUALS", "referenceValue": true}
        }
      ]
    }
  };
}
