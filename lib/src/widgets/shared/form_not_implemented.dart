import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';

class FormNotImplemented extends StatelessWidget {
  final String type;

  const FormNotImplemented(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return FormFieldText(
      "TODO implement $type",
      style: const TextStyle(color: Colors.red),
    );
  }
}
