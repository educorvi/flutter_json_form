import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';

class ExampleFormFile extends FormFile{
  final String? filename;
  static String path = "../lib/src/schemas/examples";
  static String schemaPostfix = ".schema.json";
  static String uiPostfix = ".ui.json";

  ExampleFormFile({
    required super.name,
    super.formData,
    required this.filename,
  });

  getFilePath() {
    return "$path/$filename";
  }

  getSchemaPath() {
    return "${getFilePath()}$schemaPostfix";
  }

  getUiPath() {
    return "${getFilePath()}$uiPostfix";
  }

  @override
  Future<void> loadSchemas() async {
    if (jsonSchema == null || uiSchema == null) {
      final jsonSchemaString = await rootBundle.loadString(getSchemaPath());
      final uiSchemaString = await rootBundle.loadString(getUiPath());
      jsonSchema = json.decode(jsonSchemaString);
      uiSchema = json.decode(uiSchemaString);
    }
  }

  void setInitialFormData(Map<String, dynamic> data) {
    formData = data;
    // formKey.currentState?.reset();
  }

  void resetInitialFormData() {
    formData = {};
    // formKey.currentState?.reset();
  }
}
