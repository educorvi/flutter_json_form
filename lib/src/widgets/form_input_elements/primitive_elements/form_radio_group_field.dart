import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';

class FormRadioGroupField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final List<dynamic> values;
  final Widget Function(dynamic value, String label)? optionBuilder;

  const FormRadioGroupField({
    super.key,
    required this.formFieldContext,
    required this.values,
    this.optionBuilder,
  });

  @override
  Widget build(BuildContext buildContext) {
    final enumTitles = formFieldContext.options?.enumOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);

    return FormBuilderRadioGroup(
      initialValue: formFieldContext.initialValue,
      name: formFieldContext.id,
      onChanged: formFieldContext.onChanged,
      onSaved: formFieldContext.onSavedCallback,
      enabled: formFieldContext.enabled,
      validator: FormFieldUtils.createBaseValidator(formFieldContext),
      decoration: FormFieldUtils.getInputDecoration(formFieldContext, buildContext, border: false),
      options: mapped.map((entry) {
        final child = optionBuilder != null ? optionBuilder!(entry.key, entry.value) : Text(entry.value);
        return FormBuilderFieldOption(value: entry.key, child: child);
      }).toList(growable: false),
      orientation: _getOptionsOrientation(),
    );
  }

  OptionsOrientation _getOptionsOrientation() {
    return formFieldContext.options?.enumOptions?.stacked == true ? OptionsOrientation.vertical : OptionsOrientation.wrap;
  }
}
