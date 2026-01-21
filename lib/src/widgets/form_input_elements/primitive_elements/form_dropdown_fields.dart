import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';

class FormDropdownField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final List<dynamic> values;
  final Widget Function(dynamic value, String label)? itemBuilder;

  const FormDropdownField({
    super.key,
    required this.formFieldContext,
    required this.values,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final enumTitles = formFieldContext.options?.enumOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);

    return FormBuilderDropdown(
      name: formFieldContext.id,
      onChanged: formFieldContext.onChanged,
      onSaved: formFieldContext.onSavedCallback,
      enabled: formFieldContext.enabled,
      validator: FormFieldUtils.createBaseValidator(formFieldContext),
      decoration: FormFieldUtils.getInputDecoration(formFieldContext, context),
      initialValue: formFieldContext.initialValue,
      items: mapped.map((entry) {
        final child = itemBuilder != null ? itemBuilder!(entry.key, entry.value) : FormFieldText(entry.value);
        return DropdownMenuItem(value: entry.key, child: child);
      }).toList(growable: false),
    );
  }
}
