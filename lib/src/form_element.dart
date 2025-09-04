import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_array_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_object_field.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_primitive_field_selector.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_not_implemented.dart';
import 'package:json_schema/json_schema.dart';
import 'form_field_context.dart';

class FormElementFactory {
  static Widget createFormElement(FormFieldContext context) {
    SchemaType? type;
    try {
      type = context.jsonSchema.type;
    } catch (e) {
      type = null;
    }

    Widget child;
    switch (type) {
      case SchemaType.array:
        child = FormArrayField(formFieldContext: context);
      case SchemaType.object:
        child = FormObjectField(formFieldContext: context);
      case SchemaType.string:
      case SchemaType.integer:
      case SchemaType.number:
      case SchemaType.boolean:
        child = PrimitiveFieldFactory.createField(context);
      default:
        child = FormNotImplemented(type.toString());
    }

    // Handle hidden fields
    if (context.options?.formattingOptions?.hidden == true) {
      return Visibility(
        maintainState: true,
        visible: false,
        child: child,
      );
    }

    return child;
  }
}
