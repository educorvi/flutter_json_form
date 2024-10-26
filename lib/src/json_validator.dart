import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_schema/json_schema.dart' show JsonSchema, RefProvider;

const String _jsonMetaSchemaPath = "packages/flutter_json_forms/lib/src/schemas/json-schema_draft7.json";
const String _uiMetaSchemaPathFolder = "packages/flutter_json_forms/lib/src/schemas/ui";

class SchemaManager {
  static final SchemaManager _instance = SchemaManager._internal();
  late final JsonSchema jsonMetaSchema;
  late final JsonSchema uiMetaSchema;
  bool _isInitialized = false;

  factory SchemaManager() {
    return _instance;
  }

  SchemaManager._internal();

  Future<void> _initialize() async {
    final schemaFile = await jsonFromAsset(_jsonMetaSchemaPath);
    final uiSchemaFile = await jsonFromAsset("$_uiMetaSchemaPathFolder/ui.schema.json");
    jsonMetaSchema = JsonSchema.create(schemaFile);
    uiMetaSchema = await JsonSchema.createAsync(uiSchemaFile, refProvider: refProvider);
    _isInitialized = true;
  }

  Future<void> setup() async {
    if (!_isInitialized) {
      await _initialize();
    }
  }

  Future<JsonSchema> getJsonMetaSchema() async {
    if (!_isInitialized) {
      await _initialize();
    }
    return jsonMetaSchema;
  }

  Future<JsonSchema> getUiMetaSchema() async {
    if (!_isInitialized) {
      await _initialize();
    }
    return uiMetaSchema;
  }
}

final RefProvider refProvider = RefProvider.async((String ref) async {
  return await jsonFromAsset("$_uiMetaSchemaPathFolder$ref");
});

// Loads a json file from the assets
Future<dynamic> jsonFromAsset(String path) async {
  final file = await rootBundle.loadString(path);
  return json.decode(file);
}

/// Setup the dynamic json form validation
/// Important: It is only useful to call this function when you validate your json schema
/// It is also not necessary to call thia function. It just loads the json and UI schema when you call in the function instead of calling it when you first create a instant of the dynamic form renderer
/// In the future this provides mechanisms to cache already loaded schemas and improve performance by running this function in the background instead of when creating the first Form Renderer Instance
Future<void> setupDynamicJsonFormValidation() async {
  await SchemaManager().setup();
}