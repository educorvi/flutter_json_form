import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
          onChanged: context.onChanged,
          onSaved: context.onSavedCallback,
          enabled: context.enabled,
          validator: _composeValidator(),
          decoration: _getInputDecoration(),
          orientation: _getOptionsOrientation(),
          options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
        ),
      ),
    );
  }

  FormFieldValidator<dynamic> _composeValidator() {
    return (valueCandidate) {
      if (!context.isShownCallback()) {
        return null;
      }

      if (context.required) {
        final validatorResult = FormBuilderValidators.required().call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }

      return null;
    };
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      labelText: context.showLabel ? _getLabel() : null,
      hintText: context.placeholder,
      border: InputBorder.none,
      helperText: context.description,
      helperMaxLines: 10,
      prefixText: context.options?.formattingOptions?.prepend,
      suffixText: context.options?.formattingOptions?.append,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  OptionsOrientation _getOptionsOrientation() {
    return context.options?.fieldSpecificOptions?.stacked == true ? OptionsOrientation.vertical : OptionsOrientation.wrap;
  }

  String? _getLabel() {
    String? getScope() {
      final lastScopeElement = context.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = context.title ?? getScope();
    return context.required && titleString != null ? ('${titleString}*') : titleString;
  }
}
