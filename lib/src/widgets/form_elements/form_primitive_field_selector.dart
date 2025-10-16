import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_color_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_date_time_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_dropdown_fields.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_file_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_radio_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_segmented_control_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_slider_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_switch_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_text_field.dart';
import 'package:json_schema/json_schema.dart';
import '../../models/ui_schema.g.dart' as ui;

class PrimitiveFieldFactory {
  static Widget createField(FormFieldContext context) {
    switch (context.type) {
      case SchemaType.string:
        return _createStringField(context);
      case SchemaType.integer:
      case SchemaType.number:
        return _createNumberField(context);
      case SchemaType.boolean:
        return _createBooleanField(context);
      default:
        return FormFieldText("Unsupported primitive type: ${context.type}");
    }
  }

  static Widget _createStringField(FormFieldContext context) {
    // Handle enums first
    if (context.jsonSchema.enumValues?.isNotEmpty ?? false) {
      List<String> values = context.jsonSchema.enumValues!.map((e) => e.toString()).toList();

      switch (context.options?.fieldSpecificOptions?.displayAs) {
        case ui.DisplayAs.RADIOBUTTONS:
          return FormRadioGroupField(formFieldContext: context, values: values);
        case ui.DisplayAs.SWITCHES:
        case ui.DisplayAs.BUTTONS:
          return FormSegmentedControlField(formFieldContext: context, values: values);
        case ui.DisplayAs.SELECT:
        case null:
          return FormDropdownField(formFieldContext: context, values: values);
      }
    }

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

  static Widget _createNumberField(FormFieldContext context) {
    // Check if it should be a slider
    if (context.options?.fieldSpecificOptions?.range == true) {
      return FormSliderField(formFieldContext: context);
    }

    // Default to text field with number conversion
    final expectedType = context.type == SchemaType.integer ? int : double;
    return FormTextField(formFieldContext: context, expectedType: expectedType);
  }

  static Widget _createBooleanField(FormFieldContext context) {
    return FormSwitchField(formFieldContext: context);
  }
}
