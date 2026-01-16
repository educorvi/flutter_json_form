import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_color_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_date_time_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_file_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_slider_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_switch_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_text_field.dart';
import 'package:json_schema/json_schema.dart';
import '../../models/ui_schema.g.dart' as ui;

/// Factory for creating primitive (non-enum) field widgets
class PrimitiveFieldFactory {
  static Widget createField(FormFieldContext context) {
    // Handle type-specific fields
    switch (context.type) {
      case SchemaType.string:
        return _createStringField(context);
      case SchemaType.integer:
        return _createNumberField(context, int);
      case SchemaType.number:
        return _createNumberField(context, double);
      case SchemaType.boolean:
        return FormSwitchField(formFieldContext: context);
      default:
        return FormFieldText("Unsupported primitive type: ${context.type}");
    }
  }

  static Widget _createStringField(FormFieldContext context) {
    // Handle format-specific fields
    if (context.jsonSchema.format == 'date-time' || context.format == ui.Format.DATETIME_LOCAL) {
      return FormDateTimePickerField(formFieldContext: context, inputType: InputType.both);
    } else if (context.jsonSchema.format == 'date' || context.format == ui.Format.DATE) {
      return FormDateTimePickerField(formFieldContext: context, inputType: InputType.date);
    } else if (context.jsonSchema.format == 'time' || context.format == ui.Format.TIME) {
      return FormDateTimePickerField(formFieldContext: context, inputType: InputType.time);
    } else if (context.jsonSchema.format == 'uri') {
      return FormFilePickerField(formFieldContext: context);
    } else if (context.jsonSchema.format == 'color' || context.format == ui.Format.COLOR) {
      return FormColorPickerField(formFieldContext: context);
    }

    // Default to text field
    return FormTextField(formFieldContext: context, expectedType: String);
  }

  static Widget _createNumberField(FormFieldContext context, Type expectedType) {
    // Check for a slider
    if (context.options?.inputOptions?.range == true) {
      return FormSliderField(formFieldContext: context);
    }

    // Default to text field with number conversion
    return FormTextField(formFieldContext: context, expectedType: expectedType);
  }
}
