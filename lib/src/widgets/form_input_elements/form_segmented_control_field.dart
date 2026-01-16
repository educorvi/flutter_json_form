import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_builder_segmented_button.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/utils/enum_utils.dart';

class FormSegmentedControlField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final List<dynamic> values;
  final Widget Function(dynamic value, String label)? segmentBuilder;

  const FormSegmentedControlField({
    super.key,
    required this.formFieldContext,
    required this.values,
    this.segmentBuilder,
  });

  @override
  Widget build(BuildContext buildContext) {
    final enumTitles = formFieldContext.options?.enumOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);

    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderSegmentedButton<dynamic>(
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        onSaved: formFieldContext.onSavedCallback,
        initialValue: formFieldContext.initialValue,
        enabled: formFieldContext.enabled,
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, buildContext, border: false),
        segments: mapped.map((entry) {
          final label = segmentBuilder != null ? segmentBuilder!(entry.key, entry.value) : Text(entry.value);
          return ButtonSegment(value: entry.key, label: label);
        }).toList(growable: false),
        showSelectedIcon: true,
        selectedIcon: const Icon(Icons.check),
        stacked: formFieldContext.options?.enumOptions?.stacked,
      ),
    );
  }
}
