import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'json_dialog.dart';

/// Reusable widget for displaying a JSON form with action buttons
class FormDisplay extends StatelessWidget {
  final GlobalKey<FlutterJsonFormState> formKey;
  final Map<String, dynamic>? jsonSchema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic> formData;

  const FormDisplay({
    super.key,
    required this.formKey,
    required this.jsonSchema,
    required this.uiSchema,
    this.formData = const {},
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPresetData = formData.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            runSpacing: LayoutConstants.spacingS,
            spacing: LayoutConstants.spacingM,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () => showJsonDialog(context, 'JSON Schema', jsonSchema),
                child: const Text('JSON Schema'),
              ),
              FilledButton.tonal(
                onPressed: () => showJsonDialog(context, 'UI Schema', uiSchema),
                child: const Text('UI Schema'),
              ),
              if (hasPresetData)
                FilledButton.tonal(
                  onPressed: () => showJsonDialog(context, 'Preset Form Data', formData),
                  child: const Text('Preset Data'),
                ),
            ],
          ),
        ),
        const Divider(),
        FlutterJsonForm(
          key: formKey,
          validate: false,
          jsonSchema: jsonSchema,
          uiSchema: uiSchema,
          formData: formData,
          onFormSubmitSaveCallback: (formValues) {
            showJsonDialog(context, 'Form Submitted', formValues);
          },
        ),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: LayoutConstants.spacingS,
            runSpacing: LayoutConstants.spacingM,
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
        )
      ],
    );
  }
}
