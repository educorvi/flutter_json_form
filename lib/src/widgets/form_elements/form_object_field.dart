import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import '../../models/ui_schema.dart' as ui;
import '../../utils/show_on.dart';
import '../shared/common.dart';
import '../shared/form_element_loading.dart';
import '../shared/spacing_utils.dart';

class FormObjectField extends StatefulWidget {
  final FormFieldContext formFieldContext;

  const FormObjectField({
    super.key,
    required this.formFieldContext,
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

    // Cache the FormContext when it's available
    if (formContext != null) {
      _cachedFormContext = formContext;
    }

    // If FormContext is not available and we don't have a cached one, show a placeholder
    if (formContext == null && _cachedFormContext == null) {
      return const FormElementLoading();
    }

    // Use available FormContext or cached one
    final effectiveFormContext = formContext ?? _cachedFormContext!;

    bool objectIsShown() => widget.formFieldContext.isShownCallback();

    Widget objectElements = getLineContainer(
      child: Padding(
        padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildElementsWithSpacing(context, effectiveFormContext, objectIsShown),
        ),
      ),
    );

    String? label = FormFieldUtils.getLabel(widget.formFieldContext, getLabel: true);

    Widget objectWidget = label != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: UIConstants.objectTitlePadding),
              objectElements,
            ],
          )
        : objectElements;

    return handleShowOn(
      child: objectWidget,
      checkValueForShowOn: effectiveFormContext.checkValueForShowOn,
      parentIsShown: widget.formFieldContext.parentIsShown,
      showOn: widget.formFieldContext.showOn,
      ritaDependencies: effectiveFormContext.ritaDependencies,
      selfIndices: widget.formFieldContext.selfIndices,
      ritaEvaluator: widget.formFieldContext.ritaEvaluator,
      getFullFormData: widget.formFieldContext.getFullFormData,
    );
  }

  /// Builds a list of widgets with proper spacing using shared utility
  List<Widget> _buildElementsWithSpacing(BuildContext context, FormContext formContext, bool Function() objectIsShown) {
    final propertyKeys = widget.formFieldContext.jsonSchema.properties.keys.toList();

    return SpacingUtils.buildObjectPropertiesWithSpacing(
      context: context,
      propertyKeys: propertyKeys,
      widgetBuilder: (key, index) => _buildChildWidget(key, formContext),
      isVisibleChecker: (key, index) => _isChildVisible(key, formContext),
    );
  }

  /// Creates a child widget for the given property key
  Widget _buildChildWidget(String key, FormContext formContext) {
    bool childRequired = widget.formFieldContext.jsonSchema.propertyRequired(key) || widget.formFieldContext.required;
    String childScope = "${widget.formFieldContext.scope}/properties/$key";

    ui.DescendantControlOverrides? descendantControlOverrides =
        widget.formFieldContext.options?.formattingOptions?.descendantControlOverrides?[childScope];

    final childOptions = descendantControlOverrides?.options ?? widget.formFieldContext.options;
    final childShowOn = descendantControlOverrides?.showOn ?? widget.formFieldContext.showOn;

    return FormElementFactory.createFormElement(widget.formFieldContext.createChildContext(
        childScope: childScope,
        childId: '${widget.formFieldContext.id}/properties/$key',
        childJsonSchema: widget.formFieldContext.jsonSchema.properties[key]!,
        childOptions: childOptions,
        childShowOn: childShowOn,
        childInitialValue: _getChildInitialValue(key),
        childRequired: childRequired,
        childSelfIndices: widget.formFieldContext.selfIndices,
        childOnChanged: (value) {
          if (widget.formFieldContext.onChanged != null) {
            final newValue =
                Map<String, dynamic>.from(widget.formFieldContext.initialValue is Map<String, dynamic> ? widget.formFieldContext.initialValue : {});
            newValue[key] = value;
            widget.formFieldContext.onChanged!(newValue);
          }
        },
        childOnSavedCallback: (value, {Map<String, int>? computedSelfIndices}) {
          final childIsShown = _isChildVisible(key, formContext, computedSelfIndices: computedSelfIndices);
          if (value != null && value != "" && childIsShown) {
            formSubmitValues[key] = value;
          } else {
            formSubmitValues.remove(key);
          }
          if (widget.formFieldContext.onSavedCallback != null && key == widget.formFieldContext.jsonSchema.properties.keys.last) {
            if (formSubmitValues.isNotEmpty) {
              widget.formFieldContext.onSavedCallback!(formSubmitValues);
            }
          }
        }));
  }

  /// Checks if a child property should be visible
  bool _isChildVisible(String key, FormContext formContext, {Map<String, int>? computedSelfIndices}) {
    String childScope = "${widget.formFieldContext.scope}/properties/$key";

    ui.DescendantControlOverrides? descendantControlOverrides =
        widget.formFieldContext.options?.formattingOptions?.descendantControlOverrides?[childScope];

    // // Check if element is explicitly hidden
    // if (descendantControlOverrides?.options?.formattingOptions?.hidden == true) {
    //   return false;
    // }

    final childShowOn = descendantControlOverrides?.showOn ?? widget.formFieldContext.showOn;

    return formContext.elementShown(
      scope: childScope,
      showOn: childShowOn,
      parentIsShown: true,
      selfIndices: computedSelfIndices ?? widget.formFieldContext.selfIndices,
    );

    // return isElementShown(
    //   parentIsShown: true,
    //   showOn: childShowOn,
    //   ritaDependencies: formContext.ritaDependencies,
    //   checkValueForShowOn: formContext.checkValueForShowOn,
    // );
  }

  /// Gets the initial value for a child property, handling both top-level and nested objects
  dynamic _getChildInitialValue(String key) {
    if (widget.formFieldContext.initialValue is! Map<String, dynamic>) {
      return null;
    }

    final Map<String, dynamic> initialValue = widget.formFieldContext.initialValue;

    // First try direct key access (for objects in arrays)
    if (initialValue.containsKey(key)) {
      return initialValue[key];
    }

    // Then try with /properties/ prefix (for top-level objects)
    final prefixedKey = "/properties/$key";
    if (initialValue.containsKey(prefixedKey)) {
      return initialValue[prefixedKey];
    }

    return null;
  }
}
