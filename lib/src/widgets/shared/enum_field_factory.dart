import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/constants.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

/// Factory for creating enum field widgets based on displayAs option
class PrimitiveEnumFieldFactory {
  static final _logger = FormLogger.fieldFactory;

  /// Creates an enum field widget with optional custom widget builder
  static Widget createEnumField(
    BuildContext buildContext,
    RenderContext ctx,
    Widget Function(dynamic value, String label)? widgetBuilder,
  ) {
    final values = ctx.jsonSchema.enumValues!;
    final displayAs = ctx.options?.enumOptions?.displayAs;
    final renderer = RendererScope.of(buildContext);

    switch (displayAs) {
      case ui.DisplayAs.RADIOBUTTONS:
        _logger.finest('Creating radio group field for ${ctx.scope}');
        return renderer.buildDataRadioGroupControl(buildContext, ctx, values);
      case ui.DisplayAs.SWITCHES:
      case ui.DisplayAs.BUTTONS:
        _logger.finest('Creating segmented control field for ${ctx.scope}');
        return renderer.buildDataSegmentedControl(buildContext, ctx, values);
      case ui.DisplayAs.SELECT:
      case null:
        _logger.finest('Creating dropdown field for ${ctx.scope}');
        return renderer.buildDataDropdownControl(buildContext, ctx, values);
    }
  }
}

/// Builder for enum value widgets
/// Handles rendering of complex enum values (objects and arrays)
class ComplexEnumFieldFactory {
  static final _logger = FormLogger.fieldFactory;

  /// Builds a widget to display an enum value
  static Widget buildEnumValueWidget(
    BuildContext buildContext,
    dynamic value,
    String label,
    RenderContext parentCtx,
  ) {
    // For primitives, just show the label
    if (value == null || value is String || value is num || value is bool) {
      return Text(label);
    }

    // For objects, use the FormObjectField
    if (value is Map) {
      return _buildObjectEnumWidget(buildContext, value, label, parentCtx);
    }

    // For arrays, use FormArrayField
    if (value is List) {
      return _buildArrayEnumWidget(buildContext, value, label, parentCtx);
    }

    // Fallback
    return Text(label);
  }

  /// Builds a widget using FormObjectField for object enum values
  static Widget _buildObjectEnumWidget(
    BuildContext buildContext,
    Map<dynamic, dynamic> objectValue,
    String label,
    RenderContext parentCtx,
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
      final childContext = parentCtx.createChildContext(
        childScope: '${parentCtx.scope}/enum_preview',
        childId: '${parentCtx.id}_enum_preview',
        childJsonSchema: objectSchema,
        childInitialValue: objectValue,
        childShowLabel: false,
        childRequired: false,
      );
      _logger.finest('Creating object enum field for ${parentCtx.scope}');
      return _separateObjectBuilder(buildContext, childContext);
    } catch (e) {
      _logger.warning('Failed to create object enum field for ${parentCtx.scope}: $e. Fallback to simple preview.');
      return _buildSimpleObjectPreview(objectValue, label);
    }
  }

  static Widget _separateObjectBuilder(BuildContext buildContext, RenderContext childContext) {
    final renderer = RendererScope.of(buildContext);
    return Padding(
      padding: const EdgeInsets.only(
          left: UIConstants.groupIndentation, bottom: UIConstants.verticalElementSpacing / 2, top: UIConstants.verticalElementSpacing / 2),
      child: renderer.buildDataObjectControl(buildContext, childContext),
    );
  }

  /// Builds a widget using FormArrayField for array enum values
  static Widget _buildArrayEnumWidget(
    BuildContext buildContext,
    List<dynamic> arrayValue,
    String label,
    RenderContext parentCtx,
  ) {
    try {
      final itemSchema = arrayValue.isNotEmpty ? _inferSchemaForValue(arrayValue.first) : {'type': 'string'};
      final arraySchema = JsonSchema.create({
        'type': 'array',
        'items': itemSchema,
      });
      final childContext = parentCtx.createChildContext(
        childScope: '${parentCtx.scope}/enum_preview',
        childId: '${parentCtx.id}_enum_preview',
        childJsonSchema: arraySchema,
        childInitialValue: arrayValue,
        childShowLabel: false,
        childRequired: false,
      );
      _logger.finest('Creating array enum field for ${parentCtx.scope}');
      return _separateArrayBuilder(buildContext, label, childContext);
    } catch (e) {
      _logger.warning('Failed to create array enum field for ${parentCtx.scope}: $e. Fallback to simple preview.');
      return _buildSimpleArrayPreview(arrayValue, label);
    }
  }

  static Widget _separateArrayBuilder(BuildContext buildContext, String label, RenderContext childContext) {
    final renderer = RendererScope.of(buildContext);
    return Padding(
      padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: UIConstants.verticalElementSpacing),
          renderer.buildDataArrayControl(buildContext, childContext),
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

  ///TODO: ist this even needed? currently not part of rendering interface but should also not be really needed since objects can be rendered with default object rendering
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

  /// TODO: is this needed? currently not part of rendering interface but should also not be really needed since arrays can be rendered with default array rendering
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
