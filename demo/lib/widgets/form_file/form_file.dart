import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

import '../json_dialog.dart';

class FormFileOld {
  final String name;
  final String? filename;
  static String path = "assets/example-schemas";
  static String schemaPostfix = ".schema.json";
  static String uiPostfix = ".ui.json";
  final GlobalKey<FlutterJsonFormState> formKey;
  Map<String, dynamic>? jsonSchema;
  Map<String, dynamic>? uiSchema;
  Map<String, dynamic> formData;

  FormFileOld({
    required this.name,
    required this.filename,
    this.formData = const {},
  }) : formKey = GlobalKey<FlutterJsonFormState>();

  String getFilePath() {
    return "$path/$filename";
  }

  String getSchemaPath() {
    return "${getFilePath()}$schemaPostfix";
  }

  String getUiPath() {
    return "${getFilePath()}$uiPostfix";
  }

  Future<void> loadSchemas() async {
    if (jsonSchema == null || uiSchema == null) {
      print(getSchemaPath());
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

  FutureBuilder getForm() {
    return FutureBuilder(
      future: loadSchemas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading schemas: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton.tonal(
                    onPressed: () =>
                        showJsonDialog(context, 'JSON Schema', jsonSchema),
                    child: const Text('Show JSON Schema'),
                  ),
                  FilledButton.tonal(
                    onPressed: () =>
                        showJsonDialog(context, 'UI Schema', uiSchema),
                    child: const Text('Show UI Schema'),
                  ),
                ],
              ),
              const Divider(),
              FlutterJsonForm(
                key: formKey,
                validate: true,
                jsonSchema: jsonSchema,
                uiSchema: uiSchema,
                formData: formData,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        final formData = formKey.currentState!.value;
                        showJsonDialog(context, 'Form Data', formData);
                      }
                    },
                    child: const Text('Show Form Data'),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      formKey.currentState?.reset();
                    },
                    child: const Text('Reset Form'),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
