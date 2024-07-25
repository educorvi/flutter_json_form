// To parse this JSON data, do
//
//     final jsonSchema1 = jsonSchema1FromJson(jsonString);

import 'dart:convert';

dynamic jsonSchema1FromJson(String str) => json.decode(str);

String jsonSchema1ToJson(dynamic data) => json.encode(data);

class JsonSchema1Class {
    String? comment;
    String? id;
    String? ref;
    String? schema;
    dynamic additionalItems;
    dynamic additionalProperties;
    List<dynamic>? allOf;
    List<dynamic>? anyOf;
    dynamic jsonSchema1Const;
    dynamic contains;
    String? contentEncoding;
    String? contentMediaType;
    dynamic jsonSchema1Default;
    Map<String, dynamic>? definitions;
    Map<String, dynamic>? dependencies;
    String? description;
    dynamic jsonSchema1Else;
    List<dynamic>? jsonSchema1Enum;
    List<dynamic>? examples;
    double? exclusiveMaximum;
    double? exclusiveMinimum;
    String? format;
    dynamic jsonSchema1If;
    dynamic items;
    double? maximum;
    int? maxItems;
    int? maxLength;
    int? maxProperties;
    double? minimum;
    int? minItems;
    int? minLength;
    int? minProperties;
    double? multipleOf;
    dynamic not;
    List<dynamic>? oneOf;
    String? pattern;
    Map<String, dynamic>? patternProperties;
    Map<String, dynamic>? properties;
    dynamic propertyNames;
    bool? readOnly;
    List<String>? required;
    dynamic then;
    String? title;
    dynamic type;
    bool? uniqueItems;
    bool? writeOnly;

    JsonSchema1Class({
        this.comment,
        this.id,
        this.ref,
        this.schema,
        this.additionalItems,
        this.additionalProperties,
        this.allOf,
        this.anyOf,
        this.jsonSchema1Const,
        this.contains,
        this.contentEncoding,
        this.contentMediaType,
        this.jsonSchema1Default,
        this.definitions,
        this.dependencies,
        this.description,
        this.jsonSchema1Else,
        this.jsonSchema1Enum,
        this.examples,
        this.exclusiveMaximum,
        this.exclusiveMinimum,
        this.format,
        this.jsonSchema1If,
        this.items,
        this.maximum,
        this.maxItems,
        this.maxLength,
        this.maxProperties,
        this.minimum,
        this.minItems,
        this.minLength,
        this.minProperties,
        this.multipleOf,
        this.not,
        this.oneOf,
        this.pattern,
        this.patternProperties,
        this.properties,
        this.propertyNames,
        this.readOnly,
        this.required,
        this.then,
        this.title,
        this.type,
        this.uniqueItems,
        this.writeOnly,
    });

    factory JsonSchema1Class.fromJson(Map<String, dynamic> json) => JsonSchema1Class(
        comment: json["\u0024comment"],
        id: json["\u0024id"],
        ref: json["\u0024ref"],
        schema: json["\u0024schema"],
        additionalItems: json["additionalItems"],
        additionalProperties: json["additionalProperties"],
        allOf: json["allOf"] == null ? [] : List<dynamic>.from(json["allOf"]!.map((x) => x)),
        anyOf: json["anyOf"] == null ? [] : List<dynamic>.from(json["anyOf"]!.map((x) => x)),
        jsonSchema1Const: json["const"],
        contains: json["contains"],
        contentEncoding: json["contentEncoding"],
        contentMediaType: json["contentMediaType"],
        jsonSchema1Default: json["default"],
        definitions: Map.from(json["definitions"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        dependencies: Map.from(json["dependencies"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        description: json["description"],
        jsonSchema1Else: json["else"],
        jsonSchema1Enum: json["enum"] == null ? [] : List<dynamic>.from(json["enum"]!.map((x) => x)),
        examples: json["examples"] == null ? [] : List<dynamic>.from(json["examples"]!.map((x) => x)),
        exclusiveMaximum: json["exclusiveMaximum"]?.toDouble(),
        exclusiveMinimum: json["exclusiveMinimum"]?.toDouble(),
        format: json["format"],
        jsonSchema1If: json["if"],
        items: json["items"],
        maximum: json["maximum"]?.toDouble(),
        maxItems: json["maxItems"],
        maxLength: json["maxLength"],
        maxProperties: json["maxProperties"],
        minimum: json["minimum"]?.toDouble(),
        minItems: json["minItems"],
        minLength: json["minLength"],
        minProperties: json["minProperties"],
        multipleOf: json["multipleOf"]?.toDouble(),
        not: json["not"],
        oneOf: json["oneOf"] == null ? [] : List<dynamic>.from(json["oneOf"]!.map((x) => x)),
        pattern: json["pattern"],
        patternProperties: Map.from(json["patternProperties"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        properties: Map.from(json["properties"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        propertyNames: json["propertyNames"],
        readOnly: json["readOnly"],
        required: json["required"] == null ? [] : List<String>.from(json["required"]!.map((x) => x)),
        then: json["then"],
        title: json["title"],
        type: json["type"],
        uniqueItems: json["uniqueItems"],
        writeOnly: json["writeOnly"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024comment": comment,
        "\u0024id": id,
        "\u0024ref": ref,
        "\u0024schema": schema,
        "additionalItems": additionalItems,
        "additionalProperties": additionalProperties,
        "allOf": allOf == null ? [] : List<dynamic>.from(allOf!.map((x) => x)),
        "anyOf": anyOf == null ? [] : List<dynamic>.from(anyOf!.map((x) => x)),
        "const": jsonSchema1Const,
        "contains": contains,
        "contentEncoding": contentEncoding,
        "contentMediaType": contentMediaType,
        "default": jsonSchema1Default,
        "definitions": Map.from(definitions!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "dependencies": Map.from(dependencies!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "description": description,
        "else": jsonSchema1Else,
        "enum": jsonSchema1Enum == null ? [] : List<dynamic>.from(jsonSchema1Enum!.map((x) => x)),
        "examples": examples == null ? [] : List<dynamic>.from(examples!.map((x) => x)),
        "exclusiveMaximum": exclusiveMaximum,
        "exclusiveMinimum": exclusiveMinimum,
        "format": format,
        "if": jsonSchema1If,
        "items": items,
        "maximum": maximum,
        "maxItems": maxItems,
        "maxLength": maxLength,
        "maxProperties": maxProperties,
        "minimum": minimum,
        "minItems": minItems,
        "minLength": minLength,
        "minProperties": minProperties,
        "multipleOf": multipleOf,
        "not": not,
        "oneOf": oneOf == null ? [] : List<dynamic>.from(oneOf!.map((x) => x)),
        "pattern": pattern,
        "patternProperties": Map.from(patternProperties!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "properties": Map.from(properties!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "propertyNames": propertyNames,
        "readOnly": readOnly,
        "required": required == null ? [] : List<dynamic>.from(required!.map((x) => x)),
        "then": then,
        "title": title,
        "type": type,
        "uniqueItems": uniqueItems,
        "writeOnly": writeOnly,
    };
}

class CoreSchemaMetaSchemaClass {
    String? comment;
    String? id;
    String? ref;
    String? schema;
    dynamic additionalItems;
    dynamic additionalProperties;
    List<dynamic>? allOf;
    List<dynamic>? anyOf;
    dynamic coreSchemaMetaSchemaConst;
    dynamic contains;
    String? contentEncoding;
    String? contentMediaType;
    dynamic coreSchemaMetaSchemaDefault;
    Map<String, dynamic>? definitions;
    Map<String, dynamic>? dependencies;
    String? description;
    dynamic coreSchemaMetaSchemaElse;
    List<dynamic>? coreSchemaMetaSchemaEnum;
    List<dynamic>? examples;
    double? exclusiveMaximum;
    double? exclusiveMinimum;
    String? format;
    dynamic coreSchemaMetaSchemaIf;
    dynamic items;
    double? maximum;
    int? maxItems;
    int? maxLength;
    int? maxProperties;
    double? minimum;
    int? minItems;
    int? minLength;
    int? minProperties;
    double? multipleOf;
    dynamic not;
    List<dynamic>? oneOf;
    String? pattern;
    Map<String, dynamic>? patternProperties;
    Map<String, dynamic>? properties;
    dynamic propertyNames;
    bool? readOnly;
    List<String>? required;
    dynamic then;
    String? title;
    dynamic type;
    bool? uniqueItems;
    bool? writeOnly;

    CoreSchemaMetaSchemaClass({
        this.comment,
        this.id,
        this.ref,
        this.schema,
        this.additionalItems,
        this.additionalProperties,
        this.allOf,
        this.anyOf,
        this.coreSchemaMetaSchemaConst,
        this.contains,
        this.contentEncoding,
        this.contentMediaType,
        this.coreSchemaMetaSchemaDefault,
        this.definitions,
        this.dependencies,
        this.description,
        this.coreSchemaMetaSchemaElse,
        this.coreSchemaMetaSchemaEnum,
        this.examples,
        this.exclusiveMaximum,
        this.exclusiveMinimum,
        this.format,
        this.coreSchemaMetaSchemaIf,
        this.items,
        this.maximum,
        this.maxItems,
        this.maxLength,
        this.maxProperties,
        this.minimum,
        this.minItems,
        this.minLength,
        this.minProperties,
        this.multipleOf,
        this.not,
        this.oneOf,
        this.pattern,
        this.patternProperties,
        this.properties,
        this.propertyNames,
        this.readOnly,
        this.required,
        this.then,
        this.title,
        this.type,
        this.uniqueItems,
        this.writeOnly,
    });

    factory CoreSchemaMetaSchemaClass.fromJson(Map<String, dynamic> json) => CoreSchemaMetaSchemaClass(
        comment: json["\u0024comment"],
        id: json["\u0024id"],
        ref: json["\u0024ref"],
        schema: json["\u0024schema"],
        additionalItems: json["additionalItems"],
        additionalProperties: json["additionalProperties"],
        allOf: json["allOf"] == null ? [] : List<dynamic>.from(json["allOf"]!.map((x) => x)),
        anyOf: json["anyOf"] == null ? [] : List<dynamic>.from(json["anyOf"]!.map((x) => x)),
        coreSchemaMetaSchemaConst: json["const"],
        contains: json["contains"],
        contentEncoding: json["contentEncoding"],
        contentMediaType: json["contentMediaType"],
        coreSchemaMetaSchemaDefault: json["default"],
        definitions: Map.from(json["definitions"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        dependencies: Map.from(json["dependencies"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        description: json["description"],
        coreSchemaMetaSchemaElse: json["else"],
        coreSchemaMetaSchemaEnum: json["enum"] == null ? [] : List<dynamic>.from(json["enum"]!.map((x) => x)),
        examples: json["examples"] == null ? [] : List<dynamic>.from(json["examples"]!.map((x) => x)),
        exclusiveMaximum: json["exclusiveMaximum"]?.toDouble(),
        exclusiveMinimum: json["exclusiveMinimum"]?.toDouble(),
        format: json["format"],
        coreSchemaMetaSchemaIf: json["if"],
        items: json["items"],
        maximum: json["maximum"]?.toDouble(),
        maxItems: json["maxItems"],
        maxLength: json["maxLength"],
        maxProperties: json["maxProperties"],
        minimum: json["minimum"]?.toDouble(),
        minItems: json["minItems"],
        minLength: json["minLength"],
        minProperties: json["minProperties"],
        multipleOf: json["multipleOf"]?.toDouble(),
        not: json["not"],
        oneOf: json["oneOf"] == null ? [] : List<dynamic>.from(json["oneOf"]!.map((x) => x)),
        pattern: json["pattern"],
        patternProperties: Map.from(json["patternProperties"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        properties: Map.from(json["properties"]!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        propertyNames: json["propertyNames"],
        readOnly: json["readOnly"],
        required: json["required"] == null ? [] : List<String>.from(json["required"]!.map((x) => x)),
        then: json["then"],
        title: json["title"],
        type: json["type"],
        uniqueItems: json["uniqueItems"],
        writeOnly: json["writeOnly"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024comment": comment,
        "\u0024id": id,
        "\u0024ref": ref,
        "\u0024schema": schema,
        "additionalItems": additionalItems,
        "additionalProperties": additionalProperties,
        "allOf": allOf == null ? [] : List<dynamic>.from(allOf!.map((x) => x)),
        "anyOf": anyOf == null ? [] : List<dynamic>.from(anyOf!.map((x) => x)),
        "const": coreSchemaMetaSchemaConst,
        "contains": contains,
        "contentEncoding": contentEncoding,
        "contentMediaType": contentMediaType,
        "default": coreSchemaMetaSchemaDefault,
        "definitions": Map.from(definitions!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "dependencies": Map.from(dependencies!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "description": description,
        "else": coreSchemaMetaSchemaElse,
        "enum": coreSchemaMetaSchemaEnum == null ? [] : List<dynamic>.from(coreSchemaMetaSchemaEnum!.map((x) => x)),
        "examples": examples == null ? [] : List<dynamic>.from(examples!.map((x) => x)),
        "exclusiveMaximum": exclusiveMaximum,
        "exclusiveMinimum": exclusiveMinimum,
        "format": format,
        "if": coreSchemaMetaSchemaIf,
        "items": items,
        "maximum": maximum,
        "maxItems": maxItems,
        "maxLength": maxLength,
        "maxProperties": maxProperties,
        "minimum": minimum,
        "minItems": minItems,
        "minLength": minLength,
        "minProperties": minProperties,
        "multipleOf": multipleOf,
        "not": not,
        "oneOf": oneOf == null ? [] : List<dynamic>.from(oneOf!.map((x) => x)),
        "pattern": pattern,
        "patternProperties": Map.from(patternProperties!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "properties": Map.from(properties!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "propertyNames": propertyNames,
        "readOnly": readOnly,
        "required": required == null ? [] : List<dynamic>.from(required!.map((x) => x)),
        "then": then,
        "title": title,
        "type": type,
        "uniqueItems": uniqueItems,
        "writeOnly": writeOnly,
    };
}

enum SimpleTypes {
    ARRAY,
    BOOLEAN,
    INTEGER,
    NULL,
    NUMBER,
    OBJECT,
    STRING
}

final simpleTypesValues = EnumValues({
    "array": SimpleTypes.ARRAY,
    "boolean": SimpleTypes.BOOLEAN,
    "integer": SimpleTypes.INTEGER,
    "null": SimpleTypes.NULL,
    "number": SimpleTypes.NUMBER,
    "object": SimpleTypes.OBJECT,
    "string": SimpleTypes.STRING
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
