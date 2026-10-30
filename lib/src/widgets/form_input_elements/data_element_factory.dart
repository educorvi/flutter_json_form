import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/helpers/common.dart';
import 'package:flutter_json_forms/src/rendering/json_form_renderer.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/widgets/shared/enum_field_factory.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:json_schema/json_schema.dart';

class FormElementFactory {
  static final _logger = FormLogger.fieldFactory;

  /// Creates the widget for [context] by routing through the active
  /// [JsonFormRenderer] read from [RendererScope].
  ///
  /// Uses a [Builder] so that [RendererScope.of] is evaluated at build time,
  /// meaning the renderer can differ per sub-tree without any API change.
  static Widget createFormElement(RenderContext context) {
    return Builder(builder: (buildContext) {
      final renderer = RendererScope.of(buildContext);
      final renderCtx = context;

      Widget child;
      bool? complexElement;
      bool? ignoreLabel;

      // Check for enums first - any type can be an enum
      if (context.jsonSchema.enumValues?.isNotEmpty ?? false) {
        _logger.finest('Creating enum field for ${context.scope}');
        child = _createEnumField(renderCtx, renderer, buildContext);
      } else {
        SchemaType? type;
        try {
          type = context.jsonSchema.type;
        } catch (e, stackTrace) {
          _logger.severe('Failed to determine schema type for ${context.scope}', e, stackTrace);
          type = null;
        }

        switch (type) {
          case SchemaType.array:
            // Handle FileUpload as single file-picker field
            if (context.options?.fileUploadOptions?.displayAsSingleUploadField == true) {
              _logger.finest('Creating file picker field for ${context.scope}');
              child = renderer.buildDataFileControl(buildContext, renderCtx);
              break;
            }
            // Handle CheckboxGroup (array of string enum items)
            if (context.jsonSchema.items != null) {
              late final SchemaType? itemType;
              try {
                itemType = context.jsonSchema.items!.type;
              } catch (e, stackTrace) {
                _logger.severe('Failed to determine item schema type for array ${context.scope}', e, stackTrace);
                child = renderer.buildErrorWidget(buildContext, e.toString());
                break;
              }
              if (itemType != SchemaType.object && itemType != SchemaType.array && context.jsonSchema.items!.enumValues?.isNotEmpty == true) {
                final values = context.jsonSchema.items!.enumValues!.map((e) => e.toString()).toList();
                _logger.finest('Creating checkbox group field for ${context.scope}');
                child = renderer.buildDataCheckboxGroupControl(buildContext, renderCtx, values);
                break;
              }
            }
            // Handle tags
            if (context.options?.tagOptions?.tags?.enabled == true) {
              _logger.finest('Creating tags field for ${context.scope}');
              child = renderer.buildNotImplementedWidget(buildContext, 'tags');
              break;
            }
            _logger.finest('Creating array field for ${context.scope}');
            complexElement = true;
            child = renderer.buildDataArrayControl(buildContext, renderCtx);
            break;

          case SchemaType.object:
            _logger.finest('Creating object field for ${context.scope}');
            child = renderer.buildDataObjectControl(buildContext, renderCtx);
            complexElement = true;
            break;

          case SchemaType.string:
            child = _createStringField(context, renderCtx, renderer, buildContext);
            break;

          case SchemaType.integer:
            if (context.options?.inputOptions?.range == true) {
              _logger.finest('Creating slider field for ${context.scope}');
              child = renderer.buildDataSliderControl(buildContext, renderCtx);
            } else {
              _logger.finest('Creating integer text field for ${context.scope}');
              child = renderer.buildDataNumberControl(buildContext, renderCtx, numType: int);
            }
            break;

          case SchemaType.number:
            if (context.options?.inputOptions?.range == true) {
              _logger.finest('Creating slider field for ${context.scope}');
              child = renderer.buildDataSliderControl(buildContext, renderCtx);
            } else {
              _logger.finest('Creating number text field for ${context.scope}');
              child = renderer.buildDataNumberControl(buildContext, renderCtx, numType: double);
            }
            break;

          case SchemaType.boolean:
            _logger.finest('Creating switch field for ${context.scope}');
            child = renderer.buildDataBooleanControl(buildContext, renderCtx);
            ignoreLabel = true;
            break;

          default:
            _logger.severe('Unsupported field type: $type for ${context.scope}');
            child = renderer.buildNotImplementedWidget(buildContext, type.toString());
        }
      }

      return renderer.buildVisibilityWrapper(buildContext,
          child: withCss(
            buildContext,
            renderer.buildDataFieldWrapper(
              buildContext,
              renderCtx,
              child: child,
              isComplexField: complexElement,
              ignoreLabel: ignoreLabel,
            ),
            cssClass: context.options?.formattingOptions?.cssClass,
          ),
          isVisible: renderCtx.isShownCallback());
    });
  }

  static Widget _createStringField(
    RenderContext context,
    RenderContext renderCtx,
    JsonFormRenderer renderer,
    BuildContext buildContext,
  ) {
    if (context.jsonSchema.format == 'date-time' || context.format == ui.Format.DATETIME_LOCAL) {
      _logger.finest('Creating date-time picker field for ${context.scope}');
      return renderer.buildDataDateTimeControl(buildContext, renderCtx);
    } else if (context.jsonSchema.format == 'date' || context.format == ui.Format.DATE) {
      _logger.finest('Creating date picker field for ${context.scope}');
      return renderer.buildDataDateControl(buildContext, renderCtx);
    } else if (context.jsonSchema.format == 'time' || context.format == ui.Format.TIME) {
      _logger.finest('Creating time picker field for ${context.scope}');
      return renderer.buildDataTimeControl(buildContext, renderCtx);
    } else if (context.jsonSchema.format == 'uri') {
      _logger.finest('Creating file picker field for ${context.scope}');
      return renderer.buildDataFileControl(buildContext, renderCtx);
    } else if (context.jsonSchema.format == 'color' || context.format == ui.Format.COLOR) {
      _logger.finest('Creating color picker field for ${context.scope}');
      return renderer.buildDataColorControl(buildContext, renderCtx);
    }
    _logger.finest('Creating text field for ${context.scope}');
    return renderer.buildDataStringControl(buildContext, renderCtx);
  }

  /// Routes top-level enum fields to dropdown / radio / segmented controls
  /// based on `displayAs`.  Complex enum values (objects/arrays) are handled
  /// by [ComplexEnumFieldFactory] in [DefaultJsonFormRenderer].
  static Widget _createEnumField(
    RenderContext renderCtx,
    JsonFormRenderer renderer,
    BuildContext buildContext,
  ) {
    final values = renderCtx.jsonSchema.enumValues!;
    // For DefaultJsonFormRenderer, complex enum values need their own widget
    // builder.  We pass them through via _createEnumFieldForDefault so that
    // custom renderers simply receive the raw values list and can decide
    // themselves how to render complex entries.
    final hasComplexValues = values.any((v) => v is Map || v is List);
    if (hasComplexValues) {
      _logger.finest('Creating complex enum field for ${renderCtx.scope}');
      // Fall back to the legacy factory so complex enum rendering is preserved
      // for the default renderer.  Custom renderers receive raw values.
      Widget widgetBuilder(value, String label) => ComplexEnumFieldFactory.buildEnumValueWidget(buildContext, value, label, renderCtx);
      _logger.finest('Creating primitive enum field for ${renderCtx.scope}');
      return PrimitiveEnumFieldFactory.createEnumField(buildContext, renderCtx, widgetBuilder);
    }

    final displayAs = renderCtx.options?.enumOptions?.displayAs;
    _logger.finest('Creating primitive enum field for ${renderCtx.scope} displayAs=$displayAs');
    switch (displayAs) {
      case ui.DisplayAs.RADIOBUTTONS:
        return renderer.buildDataRadioGroupControl(buildContext, renderCtx, values);
      case ui.DisplayAs.SWITCHES:
      case ui.DisplayAs.BUTTONS:
        return renderer.buildDataSegmentedControl(buildContext, renderCtx, values);
      case ui.DisplayAs.SELECT:
      case null:
        return renderer.buildDataDropdownControl(buildContext, renderCtx, values);
    }
  }
}
