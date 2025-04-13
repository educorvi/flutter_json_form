import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_schema/json_schema.dart' show JsonSchema, RefProvider;

const String _jsonMetaSchemaPath = "packages/flutter_json_forms/lib/src/schemas/json-schema_draft7.json";
const String _uiMetaSchemaPathFolder = "packages/flutter_json_forms/lib/src/schemas/ui";

class SchemaManager {
  static final SchemaManager _instance = SchemaManager._internal();
  late final JsonSchema _jsonMetaSchema;
  late final JsonSchema _uiMetaSchema;
  late final Future<void> _isInitialized;

  factory SchemaManager() {
    return _instance;
  }

  SchemaManager._internal() {
    _isInitialized = Future(_initialize);
  }

  FutureOr<void> _initialize() async {
    // set json Schema
    final schemaFile = await jsonFromAsset(_jsonMetaSchemaPath);
    _jsonMetaSchema = await JsonSchema.createAsync(schemaFile);

    // set ui Schema
    final uiSchemaFile = await jsonFromAsset("$_uiMetaSchemaPathFolder/ui.schema.json");
    _uiMetaSchema = await JsonSchema.createAsync(uiSchemaFile, refProvider: refProvider);
  }

  Future<JsonSchema> getJsonMetaSchema() async {
    await isSetup();
    return _jsonMetaSchema;
  }

  Future<JsonSchema> getUiMetaSchema() async {
    await isSetup();
    return _uiMetaSchema;
  }

  Future<void> isSetup() async {
    await _isInitialized;
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
/// It is also often not necessary to call this function. It just loads the json and UI schema when you call in the function instead of calling it when you first create a instance of the dynamic form renderer
/// In the future this provides mechanisms to cache already loaded schemas and improve performance by running this function e.g. on app startup in the background instead of when creating the first Form Renderer Instance
Future<void> setupDynamicJsonFormValidation() async {
  await SchemaManager().isSetup();
}
