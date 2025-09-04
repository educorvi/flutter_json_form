import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:flutter_json_forms/src/utils/validators/validators.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
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
        validator: FormFieldUtils.createBaseValidator(
          formFieldContext,
          additionalValidators: multiple != null && multiple > 0 ? [JsonSchemaValidators.multipleOf<dynamic>(multiple)] : null,
        ),
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, buildContext, border: false),
        min: min,
        max: max,
        divisions: divisions,
        initialValue: initialValue,
      ),
    );
  }
}
