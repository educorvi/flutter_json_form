import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
        validator: _composeValidator(),
        decoration: _getInputDecoration(context),
        initialValue: formFieldContext.initialValue,
        items: values.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(growable: false),
      ),
    );
  }

  FormFieldValidator<dynamic> _composeValidator() {
    return (valueCandidate) {
      if (!formFieldContext.isShownCallback()) {
        return null;
      }

      if (formFieldContext.required) {
        final validatorResult = FormBuilderValidators.required().call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }

      return null;
    };
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: formFieldContext.showLabel ? _getLabel() : null,
      hintText: formFieldContext.placeholder,
      border: Theme.of(context).inputDecorationTheme.border,
      helperText: formFieldContext.description,
      helperMaxLines: 10,
      prefixText: formFieldContext.options?.formattingOptions?.prepend,
      suffixText: formFieldContext.options?.formattingOptions?.append,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  String? _getLabel() {
    String? getScope() {
      final lastScopeElement = formFieldContext.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = formFieldContext.title ?? getScope();
    return formFieldContext.required && titleString != null ? ('${titleString}*') : titleString;
  }
}
