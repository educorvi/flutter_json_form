import 'dart:convert';
import 'dart:io';

import 'form_file_base.dart';

class UploadFormFile extends FormFile {
  File? jsonSchemaFile;
  File? uiSchemaFile;

  UploadFormFile({
    required super.name,
    super.formData,
    this.jsonSchemaFile,
    this.uiSchemaFile,
  });

  @override
  Future<void> loadSchemas() async {
    if (jsonSchemaFile != null && uiSchemaFile != null) {
      final jsonSchemaString = await jsonSchemaFile!.readAsString();
      final uiSchemaString = await uiSchemaFile!.readAsString();
      jsonSchema = json.decode(jsonSchemaString);
      uiSchema = json.decode(uiSchemaString);
    }
  }

  bool filesExist() {
    return jsonSchemaFile != null && uiSchemaFile != null;
  }

  void setJsonSchemaFile(String filePath) {
    jsonSchemaFile = File(filePath);
  }

  void setUiSchemaFile(String filePath) {
    uiSchemaFile = File(filePath);
  }
}
