import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormDateTimePickerField extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final InputType inputType;

  const FormDateTimePickerField({
    super.key,
    required this.formFieldContext,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWrapper(
      context: formFieldContext,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: FormBuilderDateTimePicker(
          name: formFieldContext.id,
          onChanged: formFieldContext.onChanged,
          enabled: formFieldContext.enabled,
          validator: _composeValidator(),
          decoration: _getInputDecoration(context),
          initialValue: _getDefaultDateTime(),
          inputType: inputType,
          onSaved: (DateTime? dateTime) => formFieldContext.onSavedCallback?.call(dateTime?.toIso8601String()),
        ),
      ),
    );
  }

  DateTime? _getDefaultDateTime() {
    if (formFieldContext.initialValue is! String) {
      return null;
    }
    final String initialValueString = formFieldContext.initialValue;
    if (initialValueString == '\$now') {
      return DateTime.now();
    } else {
      return DateTime.tryParse(initialValueString);
    }
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
      suffixIcon: const Icon(Icons.date_range),
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
