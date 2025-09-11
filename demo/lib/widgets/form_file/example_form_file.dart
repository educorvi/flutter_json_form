import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';

class ExampleFormFile extends FormFile {
  final String? filename;
  static String path = "assets/example-schemas";
  static String schemaPostfix = ".schema.json";
  static String uiPostfix = ".ui.json";

  ExampleFormFile({
    required super.name,
    super.formData,
    required this.filename,
  });

  String getFilePath() {
    return "$path/$filename";
  }

  String getSchemaPath() {
    return "${getFilePath()}$schemaPostfix";
  }

  String getUiPath() {
    return "${getFilePath()}$uiPostfix";
  }

  @override
  Future<void> loadSchemas() async {
    if (jsonSchema == null || uiSchema == null) {
      final jsonSchemaString = await rootBundle.loadString(getSchemaPath());
      String? uiSchemaString;
      try {
        uiSchemaString = await rootBundle.loadString(getUiPath());
      } catch (e) {
        // Handle error
      }
      jsonSchema = json.decode(jsonSchemaString);
      if (uiSchemaString != null) {
        uiSchema = json.decode(uiSchemaString);
      }
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
