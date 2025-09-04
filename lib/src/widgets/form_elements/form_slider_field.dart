import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:flutter_json_forms/src/utils/validators/validators.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:json_schema/json_schema.dart';

class FormSliderField extends StatelessWidget {
  final FormFieldContext formFieldContext;

  const FormSliderField({
    super.key,
    required this.formFieldContext,
  });

  @override
  Widget build(BuildContext buildContext) {
    final double min = safeParseDouble(formFieldContext.jsonSchema.minimum);
    final double max = safeParseDouble(formFieldContext.jsonSchema.maximum);
    final double? multiple = formFieldContext.jsonSchema.multipleOf != null ? safeParseDouble(formFieldContext.jsonSchema.multipleOf) : null;

    int? divisions;
    if (max > min) {
      if (multiple != null && multiple > 0) {
        final double steps = (max - min) / multiple;
        if (steps.isFinite && steps > 0 && (steps - steps.roundToDouble()).abs() < 1e-6) {
          divisions = steps.round();
        }
      } else {
        divisions = (max - min).toInt();
      }
    }

    double initialValue = min;
    if (formFieldContext.initialValue != null) {
      if (formFieldContext.initialValue is num) {
        initialValue = formFieldContext.initialValue.toDouble();
      } else if (formFieldContext.initialValue is String) {
        initialValue = double.tryParse(formFieldContext.initialValue) ?? min;
      }
    }

    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderSlider(
        name: formFieldContext.id,
        onChanged: (value) => formFieldContext.onChanged?.call(formFieldContext.type == SchemaType.integer ? value?.toInt() : value),
        onSaved: (value) => formFieldContext.onSavedCallback?.call(formFieldContext.type == SchemaType.integer ? value?.toInt() : value),
        enabled: formFieldContext.enabled,
        validator: _composeValidator(),
        decoration: _getInputDecoration(),
        min: min,
        max: max,
        divisions: divisions,
        initialValue: initialValue,
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

      final multiple = formFieldContext.jsonSchema.multipleOf != null ? safeParseDouble(formFieldContext.jsonSchema.multipleOf) : null;

      if (multiple != null && multiple > 0) {
        final validatorResult = JsonSchemaValidators.multipleOf<dynamic>(multiple).call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }

      return null;
    };
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      labelText: formFieldContext.showLabel ? _getLabel() : null,
      hintText: formFieldContext.placeholder,
      border: InputBorder.none,
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
