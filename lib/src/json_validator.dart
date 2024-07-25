import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:json_schema/json_schema.dart' show JsonSchema, RefProvider;

const String _jsonMetaSchemaPath = "packages/flutter_json_forms/lib/src/schemas/json-schema_draft7.json";
const String _uiMetaSchemaPathFolder = "packages/flutter_json_forms/lib/src/schemas/ui";

// GetIt getJsonSchema = GetIt.instance;
// GetIt getUiSchema = GetIt.instance;
GetIt getSchemas = GetIt.instance;


/// Setup the dynamic json form
/// This function should be called at the start of the app to load the json schema and ui schema validators
void setupDynamicJsonForm() {
  // setupGetJsonSchema();
  // setupGetUiSchema();
  setupGetSchemas();
}

/// return a pair of json schema and ui schema
/// when both are loaded from the assets in parallel, the function returns the pair
void setupGetSchemas() async {
  final schemaFile = await jsonFromAsset(_jsonMetaSchemaPath);
  final uiSchemaFile = await jsonFromAsset("$_uiMetaSchemaPathFolder/ui.schema.json");
  final uiSchema = await JsonSchema.createAsync(uiSchemaFile, refProvider: refProvider);
  getSchemas.registerLazySingleton<(JsonSchema, JsonSchema)>(() => (JsonSchema.create(schemaFile), uiSchema));
}
// Using LazySingleton to not load the Singleton at app startup but when the function is called for the first time

// void setupGetJsonSchema() async {
//   final schemaFile = await jsonFromAsset(_jsonMetaSchemaPath);
//   getJsonSchema.registerLazySingleton<JsonSchema>(() => JsonSchema.create(schemaFile));
// }

// void setupGetUiSchema() async {
//   final schemaFile = await jsonFromAsset("$_uiMetaSchemaPathFolder/ui.schema.json");
//   final uiSchema = await JsonSchema.createAsync(schemaFile, refProvider: refProvider);
//   getUiSchema.registerLazySingleton<JsonSchema>(() => uiSchema);
// }

final RefProvider refProvider = RefProvider.async((String ref) async {
  return await jsonFromAsset("$_uiMetaSchemaPathFolder$ref");
});

// Loads a json file from the assets
Future<dynamic> jsonFromAsset(String path) async {
  final file = await rootBundle.loadString(path);
  return json.decode(file);
}