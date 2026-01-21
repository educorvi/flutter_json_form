import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormSwitchField extends StatelessWidget {
  final FormFieldContext formFieldContext;

  const FormSwitchField({
    super.key,
    required this.formFieldContext,
  });

  @override
  Widget build(BuildContext buildContext) {
    bool initialValue = false;
    if (formFieldContext.initialValue != null) {
      if (formFieldContext.initialValue is bool) {
        initialValue = formFieldContext.initialValue;
      } else if (formFieldContext.initialValue is String) {
        initialValue = formFieldContext.initialValue.toLowerCase() == 'true';
      }
    }

    return FormBuilderSwitch(
      key: Key(formFieldContext.scope),
      initialValue: initialValue,
      name: formFieldContext.id,
      onChanged: formFieldContext.onChanged,
      enabled: formFieldContext.enabled,
      onSaved: formFieldContext.onSavedCallback,
      validator: FormFieldUtils.createBaseValidator(
        formFieldContext,
        additionalValidators: formFieldContext.required ? [FormBuilderValidators.equal(true)] : null,
      ),
      title: FormFieldText(FormFieldUtils.getLabel(formFieldContext, getLabel: true) ?? "", required: formFieldContext.required),
      contentPadding: const EdgeInsets.all(0),
      decoration: const InputDecoration(border: InputBorder.none),
      subtitle: formFieldContext.description != null ? FormFieldText(formFieldContext.description!) : null,
    );
  }
}
