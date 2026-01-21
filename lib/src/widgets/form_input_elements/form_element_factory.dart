import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/complex_elements/form_array/form_array_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/complex_elements/form_object_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_checkbox_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_file_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/shared/enum_field_factory.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_error.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_not_implemented.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:json_schema/json_schema.dart';
import '../../form_field_context.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_color_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_date_time_picker_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_slider_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_switch_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_text_field.dart';

class FormElementFactory {
  static final _logger = FormLogger.fieldFactory;

  static Widget createFormElement(FormFieldContext context) {
    Widget child;
    bool? complexElement;
    bool? ignoreLabel;
    // Check for enums first - any type can be an enum
    if (context.jsonSchema.enumValues?.isNotEmpty ?? false) {
      _logger.finest('Creating enum field for ${context.scope}');
      child = _createEnumField(context);
    } else {
      SchemaType? type;
      try {
        type = context.jsonSchema.type;
      } catch (e, stackTrace) {
        _logger.severe('Failed to determine schema type for ${context.scope}', e, stackTrace);
        type = null;
      }

      /// Handle different schema types

      switch (type) {
        case SchemaType.array:
          // Handle FileUpload as single file picker field
          if (context.options?.fileUploadOptions?.displayAsSingleUploadField == true) {
            _logger.finest('Creating file picker field for ${context.scope}');
            child = FormFilePickerField(formFieldContext: context);
            break;
          }
          // Handle CheckboxGroup
          if (context.jsonSchema.items != null) {
            late final SchemaType? itemType;
            try {
              itemType = context.jsonSchema.items!.type;
            } catch (e, stackTrace) {
              _logger.severe('Failed to determine item schema type for array ${context.scope}', e, stackTrace);
              child = FormError(e.toString());
              break;
            }
            if (itemType != SchemaType.object && itemType != SchemaType.array && context.jsonSchema.items!.enumValues?.isNotEmpty == true) {
              List<String> values = context.jsonSchema.items!.enumValues!.map((e) => e.toString()).toList();
              _logger.finest('Creating checkbox group field for ${context.scope}');
              child = FormCheckboxGroupField(context: context, values: values);
              break;
            }
          }

          // Handle tags
          if (context.options?.tagOptions?.tags?.enabled == true) {
            _logger.finest('Creating tags field for ${context.scope}');
            child = FormError("Tags not yet implemented"); // TODO: implement proper tags support
            break;
          }
          _logger.finest('Creating array field for ${context.scope}');
          complexElement = true;
          child = FormArrayField(formFieldContext: context);
          break;
        case SchemaType.object:
          _logger.finest('Creating object field for ${context.scope}');
          child = FormObjectField(formFieldContext: context);
          complexElement = true;
        case SchemaType.string:
          child = _createStringField(context);
          break;
        case SchemaType.integer:
          child = _createNumberField(context, int);
          break;
        case SchemaType.number:
          child = _createNumberField(context, double);
          break;
        case SchemaType.boolean:
          _logger.finest('Creating switch field for ${context.scope}');
          child = FormSwitchField(formFieldContext: context);
          ignoreLabel = true;
          break;
        default:
          _logger.severe('Unsupported field type: $type for ${context.scope}');
          child = FormNotImplemented(type.toString());
      }
    }

    return FormFieldWrapper(
      formFieldContext: context,
      child: child,
      complexElement: complexElement,
      ignoreLabel: ignoreLabel,
    );
  }

  static Widget _createStringField(FormFieldContext context) {
    // Handle format-specific fields
    if (context.jsonSchema.format == 'date-time' || context.format == ui.Format.DATETIME_LOCAL) {
      _logger.finest('Creating date-time picker field for ${context.scope}');
      return FormDateTimePickerField(formFieldContext: context, inputType: InputType.both);
    } else if (context.jsonSchema.format == 'date' || context.format == ui.Format.DATE) {
      _logger.finest('Creating date picker field for ${context.scope}');
      return FormDateTimePickerField(formFieldContext: context, inputType: InputType.date);
    } else if (context.jsonSchema.format == 'time' || context.format == ui.Format.TIME) {
      _logger.finest('Creating time picker field for ${context.scope}');
      return FormDateTimePickerField(formFieldContext: context, inputType: InputType.time);
    } else if (context.jsonSchema.format == 'uri') {
      _logger.finest('Creating file picker field for ${context.scope}');
      return FormFilePickerField(formFieldContext: context);
    } else if (context.jsonSchema.format == 'color' || context.format == ui.Format.COLOR) {
      _logger.finest('Creating color picker field for ${context.scope}');
      return FormColorPickerField(formFieldContext: context);
    }

    // Default to text field
    _logger.finest('Creating text field for ${context.scope}');
    return FormTextField(formFieldContext: context, expectedType: String);
  }

  static Widget _createNumberField(FormFieldContext context, Type expectedType) {
    // Check for a slider
    if (context.options?.inputOptions?.range == true) {
      _logger.finest('Creating primitive FormSliderField for ${context.scope} ($expectedType)');
      return FormSliderField(formFieldContext: context);
    }

    // Default to text field with number conversion
    _logger.finest('Creating number text field for ${context.scope} ($expectedType)');
    return FormTextField(formFieldContext: context, expectedType: expectedType);
  }

  /// Creates an enum field using EnumValueBuilder for value rendering
  static Widget _createEnumField(FormFieldContext context) {
    final values = context.jsonSchema.enumValues!;
    // Use EnumValueBuilder for complex value rendering
    final hasComplexValues = values.any((v) => v is Map || v is List);
    Widget Function(dynamic, String)? widgetBuilder;
    if (hasComplexValues) {
      _logger.finest('Creating complex enum field for ${context.scope}');
      widgetBuilder = (value, label) => ComplexEnumFieldFactory.buildEnumValueWidget(value, label, context);
    }
    _logger.finest('Creating primitive enum field for ${context.scope}');
    return PrimitiveEnumFieldFactory.createEnumField(context, widgetBuilder);
  }
}
