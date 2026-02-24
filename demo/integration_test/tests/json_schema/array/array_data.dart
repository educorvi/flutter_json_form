import 'package:json_schema/json_schema.dart';

class ArrayData {
  // Simple array of strings
  static final jsonSchemaSimpleArray = JsonSchema.create({
    "type": "object",
    "properties": {
      "tags": {
        "type": "array",
        "items": {"type": "string"},
        "default": ["defaultTag"]
      }
    }
  });

  // simple array with minItems and maxItems
  static final jsonSchemaArrayWithMinMax = JsonSchema.create({
    "type": "object",
    "properties": {
      "tags": {
        "type": "array",
        "items": {"type": "string"},
        "minItems": 2,
        "maxItems": 4,
        "default": ["tag1"]
      }
    }
  });

  // Array of objects
  static final jsonSchemaArrayOfObjects = JsonSchema.create({
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
  });

  // Array of arrays
  static final jsonSchemaArrayOfArrays = JsonSchema.create({
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
  });

  // Array of objects with nested arrays
  static final jsonSchemaNestedArray = JsonSchema.create({
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
  });
}
