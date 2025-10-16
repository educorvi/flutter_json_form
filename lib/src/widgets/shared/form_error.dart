import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';

class FormError extends StatelessWidget {
  final String message;

  const FormError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return FormFieldText(
      "Error: $message",
      style: const TextStyle(color: Colors.red),
    );
  }
}
