import 'package:json_schema/json_schema.dart';

class JsonSchemaPrimitiveElementsData {
  static const primitiveFieldNames = [
    "stringProp",
    "numberProp",
    "integerProp",
    "booleanProp",
    "dateTimeProp",
    "dateProp",
    "timeProp",
    "rangeProp",
    "stringEnum",
    "arrayEnumString",
  ];

  static JsonSchema createSchema({List<String> requiredFields = const []}) {
    final schemaMap = {
      "type": "object",
      "properties": {
        "stringProp": {"type": "string"},
        "numberProp": {"type": "number"},
        "integerProp": {"type": "integer"},
        "booleanProp": {"type": "boolean"},
        // TODO: "nullProp": {"type": "null"},
        "dateTimeProp": {"type": "string", "format": "date-time"},
        "dateProp": {"type": "string", "format": "date"},
        "timeProp": {"type": "string", "format": "time"},
        "rangeProp": {"type": "number", "minimum": 0, "maximum": 10, "multipleOf": 0.5},
        "stringEnum": {
          "type": "string",
          "enum": ["Option 1", "Option 2", "Option 3"]
        },
        "arrayEnumString": {
          "type": "array",
          "items": {
            "type": "string",
            "enum": ["Option A", "Option B", "Option C"]
          },
        },
      },
    };

    if (requiredFields.isNotEmpty) {
      schemaMap["required"] = requiredFields;
    }

    return JsonSchema.create(schemaMap);
  }

  static final jsonSchema = createSchema();
}
