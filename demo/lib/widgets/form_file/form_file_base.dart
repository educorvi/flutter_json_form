import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

import '../jsonDialog.dart';

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
          return Center(
              child: Text('Error loading schemas: ${snapshot.error}'));
        } else {
          return Column(
            children: [
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
                validate: false,
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
