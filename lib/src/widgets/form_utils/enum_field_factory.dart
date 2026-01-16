import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_dropdown_fields.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_radio_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/form_segmented_control_field.dart';
import '../../models/ui_schema.g.dart' as ui;

/// Factory for creating enum field widgets based on displayAs option
class EnumFieldFactory {
  /// Creates an enum field widget with optional custom widget builder
  static Widget createEnumField(
    FormFieldContext context,
    Widget Function(dynamic value, String label)? widgetBuilder,
  ) {
    final values = context.jsonSchema.enumValues!;
    final displayAs = context.options?.enumOptions?.displayAs;

    switch (displayAs) {
      case ui.DisplayAs.RADIOBUTTONS:
        return FormRadioGroupField(
          formFieldContext: context,
          values: values,
          optionBuilder: widgetBuilder,
        );
      case ui.DisplayAs.SWITCHES:
      case ui.DisplayAs.BUTTONS:
        return FormSegmentedControlField(
          formFieldContext: context,
          values: values,
          segmentBuilder: widgetBuilder,
        );
      case ui.DisplayAs.SELECT:
      case null:
        return FormDropdownField(
          formFieldContext: context,
          values: values,
          itemBuilder: widgetBuilder,
        );
    }
  }
}
