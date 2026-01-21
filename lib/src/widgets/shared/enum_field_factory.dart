import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_dropdown_fields.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_radio_group_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/primitive_elements/form_segmented_control_field.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/complex_elements/form_array/form_array_field.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/complex_elements/form_object_field.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

/// Factory for creating enum field widgets based on displayAs option
class PrimitiveEnumFieldFactory {
  static final _logger = FormLogger.fieldFactory;

  /// Creates an enum field widget with optional custom widget builder
  static Widget createEnumField(
    FormFieldContext context,
    Widget Function(dynamic value, String label)? widgetBuilder,
  ) {
    final values = context.jsonSchema.enumValues!;
    final displayAs = context.options?.enumOptions?.displayAs;

    switch (displayAs) {
      case ui.DisplayAs.RADIOBUTTONS:
        _logger.finest('Creating radio group field for ${context.scope}');
        return FormRadioGroupField(
          formFieldContext: context,
          values: values,
          optionBuilder: widgetBuilder,
        );
      case ui.DisplayAs.SWITCHES:
      case ui.DisplayAs.BUTTONS:
        _logger.finest('Creating segmented control field for ${context.scope}');
        return FormSegmentedControlField(
          formFieldContext: context,
          values: values,
          segmentBuilder: widgetBuilder,
        );
      case ui.DisplayAs.SELECT:
      case null:
        _logger.finest('Creating dropdown field for ${context.scope}');
        return FormDropdownField(
          formFieldContext: context,
          values: values,
          itemBuilder: widgetBuilder,
        );
    }
  }
}

/// Builder for enum value widgets
/// Handles rendering of complex enum values (objects and arrays)
class ComplexEnumFieldFactory {
  static final _logger = FormLogger.fieldFactory;

  /// Builds a widget to display an enum value
  static Widget buildEnumValueWidget(
    dynamic value,
    String label,
    FormFieldContext parentContext,
  ) {
    // For primitives, just show the label
    if (value == null || value is String || value is num || value is bool) {
      return Text(label);
    }

    // For objects, use the FormObjectField
    if (value is Map) {
      return _buildObjectEnumWidget(value, label, parentContext);
    }

    // For arrays, use FormArrayField
    if (value is List) {
      return _buildArrayEnumWidget(value, label, parentContext);
    }

    // Fallback
    return Text(label);
  }

  /// Builds a widget using FormObjectField for object enum values
  static Widget _buildObjectEnumWidget(
    Map<dynamic, dynamic> objectValue,
    String label,
    FormFieldContext parentContext,
  ) {
    try {
      final objectSchema = JsonSchema.create({
        'type': 'object',
        'properties': objectValue.map(
          (key, value) => MapEntry(
            key.toString(),
            _inferSchemaForValue(value),
          ),
        ),
      });
      final childContext = parentContext.createChildContext(
        childScope: '${parentContext.scope}/enum_preview',
        childId: '${parentContext.id}_enum_preview',
        childJsonSchema: objectSchema,
        childInitialValue: objectValue,
        childShowLabel: false,
        childRequired: false,
      );
      _logger.finest('Creating object enum field for ${parentContext.scope}');
      return _separateObjectBuilder(childContext);
    } catch (e) {
      _logger.warning('Failed to create object enum field for ${parentContext.scope}: $e. Fallback to simple preview.');
      return _buildSimpleObjectPreview(objectValue, label);
    }
  }

  static Widget _separateObjectBuilder(FormFieldContext childContext) {
    return Padding(
      padding: const EdgeInsets.only(
          left: UIConstants.groupIndentation, bottom: UIConstants.verticalElementSpacing / 2, top: UIConstants.verticalElementSpacing / 2),
      child: FormObjectField(formFieldContext: childContext),
    );
  }

  /// Builds a widget using FormArrayField for array enum values
  static Widget _buildArrayEnumWidget(
    List<dynamic> arrayValue,
    String label,
    FormFieldContext parentContext,
  ) {
    try {
      final itemSchema = arrayValue.isNotEmpty ? _inferSchemaForValue(arrayValue.first) : {'type': 'string'};
      final arraySchema = JsonSchema.create({
        'type': 'array',
        'items': itemSchema,
      });
      final childContext = parentContext.createChildContext(
        childScope: '${parentContext.scope}/enum_preview',
        childId: '${parentContext.id}_enum_preview',
        childJsonSchema: arraySchema,
        childInitialValue: arrayValue,
        childShowLabel: false,
        childRequired: false,
      );
      _logger.finest('Creating array enum field for ${parentContext.scope}');
      return _separateArrayBuilder(label, childContext);
    } catch (e) {
      _logger.warning('Failed to create array enum field for ${parentContext.scope}: $e. Fallback to simple preview.');
      return _buildSimpleArrayPreview(arrayValue, label);
    }
  }

  static Widget _separateArrayBuilder(String label, FormFieldContext childContext) {
    return Padding(
      padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: UIConstants.verticalElementSpacing),
          FormArrayField(formFieldContext: childContext),
        ],
      ),
    );
  }

  /// Infers a JSON schema for a given value
  static Map<String, dynamic> _inferSchemaForValue(dynamic value) {
    if (value == null) return {'type': 'null'};
    if (value is String) return {'type': 'string'};
    if (value is int) return {'type': 'integer'};
    if (value is double) return {'type': 'number'};
    if (value is bool) return {'type': 'boolean'};
    if (value is List) {
      final itemSchema = value.isNotEmpty ? _inferSchemaForValue(value.first) : {'type': 'string'};
      return {'type': 'array', 'items': itemSchema};
    }
    if (value is Map) {
      return {
        'type': 'object',
        'properties': value.map(
          (k, v) => MapEntry(k.toString(), _inferSchemaForValue(v)),
        ),
      };
    }
    return {'type': 'string'};
  }

  /// Fallback: Simple object preview without using FormObjectField
  /// just displays key-value pairs and has no additional functionality
  static Widget _buildSimpleObjectPreview(
    Map<dynamic, dynamic> objectValue,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: UIConstants.verticalElementSpacing),
        ...objectValue.entries.take(3).map(
              (entry) => Padding(
                padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
                child: Text(
                  '${entry.key}: ${_formatValue(entry.value)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        if (objectValue.length > 3)
          const Padding(
            padding: EdgeInsets.only(left: UIConstants.groupIndentation),
            child: Text('...', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  /// Fallback: Simple array preview without using FormArrayField
  /// just displays item count and first few items
  static Widget _buildSimpleArrayPreview(
    List<dynamic> arrayValue,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: UIConstants.verticalElementSpacing),
        Padding(
          padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
          child: Text(
            '${arrayValue.length} item${arrayValue.length != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        if (arrayValue.isNotEmpty)
          ...arrayValue.take(2).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
                  child: Text(
                    '• ${_formatValue(item)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
        if (arrayValue.length > 2)
          const Padding(
            padding: EdgeInsets.only(left: UIConstants.groupIndentation),
            child: Text('...', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  /// Formats a value for display in enum previews
  static String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is Map) return '{...}';
    if (value is List) return '[...]';
    return value.toString();
  }
}
