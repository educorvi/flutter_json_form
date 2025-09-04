import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
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

    return FormFieldWrapper(
      context: formFieldContext,
      showLabel: false,
      child: FormBuilderSwitch(
        initialValue: initialValue,
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        enabled: formFieldContext.enabled,
        onSaved: formFieldContext.onSavedCallback,
        validator: _composeValidator(),
        title: Text(_getLabel() ?? ""),
        contentPadding: const EdgeInsets.all(0),
        decoration: _getInputDecoration(),
        subtitle: formFieldContext.description != null ? Text(formFieldContext.description!) : null,
      ),
    );
  }

  FormFieldValidator<dynamic> _composeValidator() {
    return (valueCandidate) {
      if (!formFieldContext.isShownCallback()) {
        return null;
      }

      if (formFieldContext.required) {
        final validatorResult = FormBuilderValidators.equal(true).call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }

      return null;
    };
  }

  InputDecoration _getInputDecoration() {
    return const InputDecoration(
      border: InputBorder.none,
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
