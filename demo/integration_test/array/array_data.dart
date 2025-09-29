class ArrayData {
  // Simple array of strings
  static final jsonSchemaSimpleArray = {
    "type": "object",
    "properties": {
      "tags": {
        "type": "array",
        "items": {"type": "string"},
        "default": ["defaultTag"]
      }
    }
  };

  static final uiSchemaSimpleArray = {
    "version": "2.0",
    "layout": {
      "type": "Group",
      "options": {"label": "Tags"},
      "elements": [
        {"type": "Control", "scope": "#/properties/tags"}
      ]
    }
  };

  // Array of objects
  static final jsonSchemaArrayOfObjects = {
    "type": "object",
    "properties": {
      "people": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "firstName": {"type": "string"},
            "lastName": {"type": "string"}
          }
        },
        "default": [
          {"firstName": "John", "lastName": "Doe"}
        ]
      }
    }
  };

  static final uiSchemaArrayOfObjects = {
    "version": "2.0",
    "layout": {
      "type": "Group",
      "options": {"label": "People"},
      "elements": [
        {"type": "Control", "scope": "#/properties/people"}
      ]
    }
  };

  // Array of arrays
  static final jsonSchemaArrayOfArrays = {
    "type": "object",
    "properties": {
      "matrix": {
        "type": "array",
        "items": {
          "type": "array",
          "items": {"type": "number"},
          "default": [1, 2]
        },
        "default": [
          [1, 2],
          [3, 4]
        ]
      }
    }
  };

  static final uiSchemaArrayOfArrays = {
    "version": "2.0",
    "layout": {
      "type": "Group",
      "options": {"label": "Matrix"},
      "elements": [
        {"type": "Control", "scope": "#/properties/matrix"}
      ]
    }
  };
}

class NestedArrayData {
  // Array of objects with nested arrays
  static final jsonSchemaNestedArray = {
    "type": "object",
    "properties": {
      "groups": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "name": {"type": "string"},
            "members": {
              "type": "array",
              "items": {"type": "string"},
              "default": ["member1"]
            }
          }
        },
        "default": [
          {
            "name": "GroupA",
            "members": ["Alice", "Bob"]
          }
        ]
      }
    }
  };

  static final uiSchemaNestedArray = {
    "version": "2.0",
    "layout": {
      "type": "Group",
      "options": {"label": "Groups"},
      "elements": [
        {"type": "Control", "scope": "#/properties/groups"}
      ]
    }
  };
}
