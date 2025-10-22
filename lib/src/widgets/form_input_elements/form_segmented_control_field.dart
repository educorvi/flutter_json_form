import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_builder_segmented_button.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';

class FormSegmentedControlField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final List<String> values;

  const FormSegmentedControlField({
    super.key,
    required this.formFieldContext,
    required this.values,
  });

  @override
  Widget build(BuildContext buildContext) {
    final enumTitles = formFieldContext.options?.fieldSpecificOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);
    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderSegmentedButton<String>(
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        onSaved: formFieldContext.onSavedCallback,
        initialValue: formFieldContext.initialValue,
        enabled: formFieldContext.enabled,
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, buildContext, border: false),
        segments: mapped.map((entry) => ButtonSegment(value: entry.key, label: Text(entry.value))).toList(growable: false),
        showSelectedIcon: true,
        selectedIcon: const Icon(Icons.check),
        stacked: formFieldContext.options?.fieldSpecificOptions?.stacked,
      ),
    );
  }
}
