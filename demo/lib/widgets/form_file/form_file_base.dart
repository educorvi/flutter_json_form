import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

import '../form_display.dart';

abstract class FormFile {
  final String name;
  final GlobalKey<FlutterJsonFormState> formKey;
  Map<String, dynamic>? jsonSchema;
  Map<String, dynamic>? uiSchema;
  Map<String, dynamic> formData;

  FormFile({
    required this.name,
    this.formData = const {},
  }) : formKey = GlobalKey<FlutterJsonFormState>();

  Future<void> loadSchemas();

  FutureBuilder getForm() {
    return FutureBuilder(
      future: loadSchemas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading schemas: ${snapshot.error}'));
        } else {
          return FormDisplay(
            formKey: formKey,
            jsonSchema: jsonSchema,
            uiSchema: uiSchema,
            formData: formData,
          );
        }
      },
    );
  }
}
