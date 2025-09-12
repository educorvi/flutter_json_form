import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../form_field_context.dart';

class FormFieldUtils {
  /// Creates standardized input decoration for form fields
  static InputDecoration getInputDecoration(
    FormFieldContext context,
    BuildContext buildContext, {
    bool border = true,
    Widget? prefix,
    Widget? suffix,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: context.showLabel ? getLabel(context) : null,
      hintText: context.placeholder,
      border: !border ? InputBorder.none : Theme.of(buildContext).inputDecorationTheme.border,
      helperText: context.description,
      helperMaxLines: 10,
      prefix: context.options?.formattingOptions?.prepend == null ? prefix : null,
      prefixText: context.options?.formattingOptions?.prepend,
      suffix: context.options?.formattingOptions?.append == null ? suffix : null,
      suffixText: context.options?.formattingOptions?.append,
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  /// Creates standardized label text for form fields
  static String? getLabel(FormFieldContext context, {bool getLabel = !UIConstants.labelSeparateText}) {
    if (!getLabel) {
      return null;
    }

    String? getScope() {
      final lastScopeElement = context.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = context.title ?? getScope();
    return context.required && titleString != null ? ('$titleString*') : titleString;
  }

  /// Creates standardized validator that respects visibility
  static String? Function(dynamic) createBaseValidator(
    FormFieldContext context, {
    List<FormFieldValidator>? additionalValidators,
  }) {
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

      if (additionalValidators != null) {
        for (final validator in additionalValidators) {
          final validatorResult = validator.call(valueCandidate);
          if (validatorResult != null) {
            return validatorResult;
          }
        }
      }

      return null;
    };
  }
}
