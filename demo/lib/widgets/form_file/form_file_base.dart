import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

import '../form_display.dart';

abstract class FormFile {
  final String name;
  final GlobalKey<FlutterJsonFormState> formKey;
  Map<String, dynamic>? jsonSchema;
  Map<String, dynamic>? uiSchema;
  Map<String, dynamic> formData;
  Future<void>? _loadSchemasFuture;

  FormFile({
    required this.name,
    this.formData = const {},
  }) : formKey = GlobalKey<FlutterJsonFormState>();

  Future<void> loadSchemas();

  Widget getForm() {
    // If schemas are already loaded, return FormDisplay directly
    if (jsonSchema != null && uiSchema != null) {
      return get_form_display();
    }

    // Otherwise, load schemas with FutureBuilder
    _loadSchemasFuture ??= loadSchemas();
    return FutureBuilder(
      future: _loadSchemasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading schemass: ${snapshot.error}'));
        } else {
          return get_form_display();
        }
      },
    );
  }

  get_form_display() {
    return FormDisplay(
      key: ValueKey('form_display_$name'),
      formKey: formKey,
      jsonSchema: jsonSchema,
      uiSchema: uiSchema,
      formData: formData,
    );
  }
}
