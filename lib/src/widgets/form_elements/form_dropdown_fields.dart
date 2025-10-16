import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';

class FormDropdownField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final List<String> values;

  const FormDropdownField({
    super.key,
    required this.formFieldContext,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderDropdown(
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        onSaved: formFieldContext.onSavedCallback,
        enabled: formFieldContext.enabled,
        validator: FormFieldUtils.createBaseValidator(formFieldContext),
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, context),
        initialValue: formFieldContext.initialValue,
        items: values.map((value) => DropdownMenuItem(value: value, child: FormFieldText(value))).toList(growable: false),
      ),
    );
  }
}
