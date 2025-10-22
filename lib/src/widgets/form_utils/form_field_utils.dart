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
    String? hintText,
  }) {
    return InputDecoration(
      labelText: context.showLabel ? getLabel(context) : null,
      hintText: context.placeholder ?? hintText,
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
  static String? getLabel(FormFieldContext context, {bool getLabel = !UIConstants.labelSeparateText, dynamic uiSchemaLabel}) {
    if (!getLabel || uiSchemaLabel == false) {
      return null;
    }

    String? getScope() {
      final lastScopeElement = context.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final uiSchemaString = uiSchemaLabel is String ? uiSchemaLabel : null;
    final titleString = uiSchemaString ?? context.title ?? getScope();
    return titleString;
  }

  /// Creates standardized validator that respects visibility
  static String? Function(dynamic) createBaseValidator(
    FormFieldContext context, {
    List<FormFieldValidator>? additionalValidators,
  }) {
    return (valueCandidate) {
      // if the form element is not shown, no validation has to be done as the field should be ignored
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
