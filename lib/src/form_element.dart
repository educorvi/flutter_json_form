import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_array_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_object_field.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_primitive_field_selector.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_not_implemented.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:json_schema/json_schema.dart';
import 'form_field_context.dart';

class FormElementFactory {
  static final _logger = FormLogger.fieldFactory;

  static Widget createFormElement(FormFieldContext context) {
    SchemaType? type;
    try {
      type = context.jsonSchema.type;
    } catch (e, stackTrace) {
      _logger.severe('Failed to determine schema type for ${context.scope}', e, stackTrace);
      type = null;
    }
    _logger.finer('Creating form element for ${context.scope} with type $type');

    Widget child;
    switch (type) {
      case SchemaType.array:
        _logger.finer('Creating array field for ${context.scope}');
        child = FormArrayField(formFieldContext: context);
      case SchemaType.object:
        _logger.finer('Creating object field for ${context.scope}');
        child = FormObjectField(formFieldContext: context);
      case SchemaType.string:
      case SchemaType.integer:
      case SchemaType.number:
      case SchemaType.boolean:
        _logger.finer('Creating primitive field for ${context.scope} (${type.toString()})');
        child = PrimitiveFieldFactory.createField(context);
      default:
        _logger.severe('Unsupported field type: $type for ${context.scope}');
        child = FormNotImplemented(type.toString());
    }

    if (context.options?.formattingOptions?.hidden == true) {
      _logger.finer('Field ${context.scope} marked as hidden');
      return Visibility(
        maintainState: true,
        visible: false,
        child: child,
      );
    }

    return child;
  }
}
