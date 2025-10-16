import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_builder_segmented_button.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';

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
    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderSegmentedButton<String>(
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        onSaved: formFieldContext.onSavedCallback,
        initialValue: formFieldContext.initialValue,
        enabled: formFieldContext.enabled,
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, buildContext, border: false),
        segments: values.map((value) => ButtonSegment(value: value, label: FormFieldText(value))).toList(growable: false),
        showSelectedIcon: true,
        selectedIcon: const Icon(Icons.check),
      ),
    );
  }
}
