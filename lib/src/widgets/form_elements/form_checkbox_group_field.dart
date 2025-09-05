import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';

class FormCheckboxGroupField extends StatelessWidget {
  final FormFieldContext context;
  final List<String> values;

  const FormCheckboxGroupField({
    super.key,
    required this.context,
    required this.values,
  });

  @override
  Widget build(BuildContext buildContext) {
    return FormFieldWrapper(
      context: context,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: FormBuilderCheckboxGroup(
          name: context.id,
          initialValue: context.initialValue,
          onChanged: context.onChanged,
          onSaved: context.onSavedCallback,
          enabled: context.enabled,
          validator: FormFieldUtils.createBaseValidator(context),
          decoration: FormFieldUtils.getInputDecoration(context, buildContext, border: false),
          orientation: _getOptionsOrientation(),
          options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
        ),
      ),
    );
  }

  OptionsOrientation _getOptionsOrientation() {
    return context.options?.fieldSpecificOptions?.stacked == true ? OptionsOrientation.vertical : OptionsOrientation.wrap;
  }
}
