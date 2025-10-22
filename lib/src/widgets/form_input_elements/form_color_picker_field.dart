import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_utils.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class FormColorPickerField extends StatelessWidget {
  final FormFieldContext formFieldContext;

  const FormColorPickerField({
    super.key,
    required this.formFieldContext,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderColorPickerField(
        name: formFieldContext.id,
        // initialValue: formFieldContext.initialValue, // TODO
        onChanged: formFieldContext.onChanged,
        onSaved: formFieldContext.onSavedCallback,
        enabled: formFieldContext.enabled,
        validator: FormFieldUtils.createBaseValidator(formFieldContext),
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, context),
      ),
    );
  }
}
