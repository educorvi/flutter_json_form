import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/helpers/object_helpers.dart';
import 'package:flutter_json_forms/src/widgets/form_input_elements/data_element_factory.dart';
import '../../../widgets/shared/form_element_loading.dart';
import '../../helpers/spacing_utils.dart';

class FormObjectField extends StatefulWidget {
  final RenderContext ctx;

  const FormObjectField({
    super.key,
    required this.ctx,
  });

  @override
  State<FormObjectField> createState() => _FormObjectFieldState();
}

class _FormObjectFieldState extends State<FormObjectField> {
  final Map<String, dynamic> formSubmitValues = {};
  FormContext? _cachedFormContext;

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context);

    // TODO: investigate what causes FormContext to be null in some cases
    // Cache the FormContext when it's available
    if (formContext != null) {
      _cachedFormContext = formContext;
    }
    // If FormContext is not available and there is no cached one, show a placeholder
    if (formContext == null && _cachedFormContext == null) {
      return const FormElementLoading();
    }

    // Use available FormContext or cached one
    final effectiveFormContext = formContext ?? _cachedFormContext!;

    bool objectIsShown() => widget.ctx.isShownCallback();

    final children = _buildElementsWithSpacing(context, effectiveFormContext, objectIsShown);
    return RendererScope.of(context).buildObjectLayout(context, widget.ctx, children);
  }

  /// Builds a list of widgets with proper spacing using shared utility
  List<Widget> _buildElementsWithSpacing(BuildContext context, FormContext formContext, bool Function() objectIsShown) {
    final propertyKeys = widget.ctx.jsonSchema.properties.keys.toList();

    return SpacingUtils.buildWidgetsWithSpacing<String>(
      // context: context,
      items: propertyKeys,
      widgetBuilder: (key, index) => _buildChildWidget(key, formContext),
      isVisibleChecker: (key, index) => _isChildVisible(key, formContext),
    );
  }

  /// Creates a child widget for the given property key
  Widget _buildChildWidget(String key, FormContext formContext) {
    final childScope = ObjectHelpers.buildChildScope(widget.ctx.scope, key);
    final childId = ObjectHelpers.buildChildId(widget.ctx.id, key);
    final overrides = ObjectHelpers.getDescendantOverrides(widget.ctx.options, childScope);

    return FormElementFactory.createFormElement(widget.ctx.createChildContext(
        childScope: childScope,
        childId: childId,
        childJsonSchema: widget.ctx.jsonSchema.properties[key]!,
        childOptions: overrides?.options ?? widget.ctx.options,
        childShowOn: overrides?.showOn ?? widget.ctx.showOn,
        childInitialValue: _getChildInitialValue(key),
        childRequired: widget.ctx.jsonSchema.propertyRequired(key) || widget.ctx.required,
        childSelfIndices: widget.ctx.selfIndices,
        childOnChanged: (value) {
          if (widget.ctx.onChanged != null) {
            final newValue = Map<String, dynamic>.from(widget.ctx.initialValue is Map<String, dynamic> ? widget.ctx.initialValue : {});
            newValue[key] = value;
            widget.ctx.onChanged!(newValue);
          }
        },
        childOnSavedCallback: (value, {Map<String, int>? computedSelfIndices}) {
          final childIsShown = _isChildVisible(key, formContext, computedSelfIndices: computedSelfIndices);
          if (value != null && value != '' && childIsShown) {
            formSubmitValues[key] = value;
          } else {
            formSubmitValues.remove(key);
          }
          if (widget.ctx.onSavedCallback != null && key == widget.ctx.jsonSchema.properties.keys.last) {
            if (formSubmitValues.isNotEmpty) {
              widget.ctx.onSavedCallback!(formSubmitValues);
            }
          }
        }));
  }

  /// Checks if a child property should be visible
  bool _isChildVisible(String key, FormContext formContext, {Map<String, int>? computedSelfIndices}) {
    final childScope = ObjectHelpers.buildChildScope(widget.ctx.scope, key);
    final overrides = ObjectHelpers.getDescendantOverrides(widget.ctx.options, childScope);

    return widget.ctx.isElementShown(
      showOn: overrides?.showOn,
      parentIsShown: widget.ctx.isShownCallback(),
      selfIndices: computedSelfIndices ?? widget.ctx.selfIndices,
    );
  }

  /// Gets the initial value for a child property, handling both top-level and nested objects
  dynamic _getChildInitialValue(String key) => ObjectHelpers.getChildInitialValue(widget.ctx.initialValue, key);
}
