import 'package:json_schema/json_schema.dart';

class JsonSchemaObjectData {
  static final jsonSchema = JsonSchema.create({
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
  });

  static final jsonSchemaWithIndividualDefaults = JsonSchema.create({
    "type": "object",
    "properties": {
      "name": {"type": "string", "default": "John Doe"},
      "person": {
        "type": "object",
        "properties": {
          "firstName": {"type": "string", "default": "John"},
          "lastName": {"type": "string", "default": "Doe"}
        }
      }
    }
  });

  static final jsonSchemaWithObjectDefaults = JsonSchema.create({
    "type": "object",
    "properties": {
      "name": {"type": "string"},
      "person": {
        "type": "object",
        "properties": {
          "firstName": {"type": "string"},
          "lastName": {"type": "string"}
        }
      }
    },
    "default": {
      "name": "John Doe",
      "person": {"firstName": "John", "lastName": "Doe"}
    }
  });

  static final jsonSchemaWithMixedDefaults = JsonSchema.create({
    "type": "object",
    "properties": {
      "name": {"type": "string", "default": "Inner John Doe"},
      "person": {
        "type": "object",
        "properties": {
          "firstName": {"type": "string", "default": "John"},
          "lastName": {"type": "string", "default": "Doe InnerInner"},
          "thirdName": {"type": "string"}
        },
        "default": {"firstName": "John", "lastName": "Doe Inner", "thirdName": "Inner Third Name"}
      }
    },
    "default": {
      "name": "Outer John Doe",
      "person": {"firstName": "John", "lastName": "Doe Outer", "thirdName": "Outer Third Name"}
    }
  });
}

class JsonSchemaNestedObjectData {
  static final jsonSchema = JsonSchema.create({
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
  });

  static final nestedSchemaWithDefaults = JsonSchema.create({
    "type": "object",
    "properties": {
      "switchOuter": {"type": "boolean", "default": false},
      "outerName": {"type": "string", "default": "Outer"},
      "address": {
        "type": "object",
        "properties": {
          "switchObject": {"type": "boolean", "default": true},
          "street": {"type": "string", "default": "Main St"},
          "city": {"type": "string", "default": "Metropolis"},
          "country": {
            "type": "object",
            "properties": {
              "switchNestedObject": {"type": "boolean", "default": true},
              "name": {"type": "string", "default": "Freedonia"},
              "code": {"type": "string", "default": "FR"}
            },
            "default": {"name": "Freedonia", "code": "FR", "switchNestedObject": true}
          }
        },
        "default": {
          "street": "Main St",
          "city": "Metropolis",
          "country": {"name": "Freedonia", "code": "FR", "switchNestedObject": true},
          "switchObject": true
        }
      }
    },
    "default": {
      "switchOuter": false,
      "outerName": "Outer",
      "address": {
        "street": "Main St",
        "city": "Metropolis",
        "country": {"name": "Freedonia", "code": "FR", "switchNestedObject": true},
        "switchObject": true
      }
    }
  });
}
