import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/ritaRuleEvaluator.dart';
import 'package:json_schema/json_schema.dart';

class FormFieldContext {
  final ui.ControlOptions? options;
  final ui.Format? format;
  final String scope;
  final String id;
  final JsonSchema jsonSchema;
  final bool required;
  final void Function(dynamic)? onChanged;
  final bool Function() isShownCallback;
  dynamic initialValue;
  final int nestingLevel;
  final bool? parentIsShown;
  final Map<String, bool>? ritaDependencies;
  final dynamic Function(String path) checkValueForShowOn;
  final ui.ShowOnProperty? showOn;
  final Map<String, int>? selfIndices;
  final RitaRuleEvaluator? ritaEvaluator;
  final Map<String, dynamic> Function()? getFullFormData;
  final bool showLabel;
  final void Function(dynamic)? onSavedCallback;

  // Computed properties
  late final String? title;
  late final String? description;
  late final SchemaType? type;
  late final String? placeholder;
  late final bool enabled;

  FormFieldContext({
    required this.options,
    required this.format,
    required this.scope,
    required this.id,
    required this.jsonSchema,
    required this.required,
    required this.onChanged,
    required this.isShownCallback,
    required this.initialValue,
    required this.nestingLevel,
    required this.parentIsShown,
    required this.ritaDependencies,
    required this.checkValueForShowOn,
    required this.showOn,
    required this.selfIndices,
    required this.ritaEvaluator,
    required this.getFullFormData,
    required this.showLabel,
    required this.onSavedCallback,
  }) {
    title = jsonSchema.title;
    description = jsonSchema.description;
    try {
      type = jsonSchema.type;
    } catch (e) {
      type = null;
    }
    placeholder = options?.formattingOptions?.placeholder;
    enabled = true;
  }

  /// Factory method to create FormFieldContext from FormContext and form element parameters
  factory FormFieldContext.fromFormContext({
    required BuildContext context,
    required String scope,
    required String id,
    required JsonSchema jsonSchema,
    required bool required,
    required int nestingLevel,
    ui.ControlOptions? options,
    ui.Format? format,
    ui.ShowOnProperty? showOn,
    dynamic initialValue,
    bool showLabel = true,
    bool? parentIsShown,
    Map<String, int>? selfIndices,
    void Function(dynamic)? onChanged,
    void Function(dynamic)? onSavedCallback,
  }) {
    final formContext = FormContext.of(context)!;

    return FormFieldContext(
      options: options,
      format: format,
      scope: scope,
      id: id,
      jsonSchema: jsonSchema,
      required: required,
      onChanged: onChanged,
      isShownCallback: () => formContext.elementShown(
        scope: scope,
        showOn: showOn,
        parentIsShown: parentIsShown,
      ),
      initialValue: initialValue ?? jsonSchema.defaultValue,
      nestingLevel: nestingLevel,
      parentIsShown: parentIsShown,
      ritaDependencies: formContext.ritaDependencies,
      checkValueForShowOn: formContext.checkValueForShowOn,
      showOn: showOn,
      selfIndices: selfIndices,
      ritaEvaluator: formContext.ritaEvaluator,
      getFullFormData: formContext.getFullFormData,
      showLabel: showLabel,
      onSavedCallback: (dynamic value) {
        if (onSavedCallback != null) {
          onSavedCallback(value);
        }
        if (formContext.elementShown(
          scope: scope,
          showOn: showOn,
          parentIsShown: parentIsShown,
        )) {
          formContext.onFormValueSaved(scope, value);
        }
      },
    );
  }

  /// Create a child context for array items
  FormFieldContext createChildContext({
    required String childScope,
    required String childId,
    required JsonSchema childJsonSchema,
    ui.ControlOptions? childOptions,
    ui.ShowOnProperty? childShowOn,
    dynamic childInitialValue,
    bool childRequired = false,
    bool childShowLabel = true,
    Map<String, int>? childSelfIndices,
    void Function(dynamic)? childOnChanged,
    void Function(dynamic)? childOnSavedCallback,
  }) {
    return FormFieldContext(
      options: childOptions ?? options,
      format: format,
      scope: childScope,
      id: childId,
      jsonSchema: childJsonSchema,
      required: childRequired,
      onChanged: childOnChanged,
      isShownCallback: () {
        // Child visibility depends on parent + its own showOn
        final parentShown = isShownCallback();
        if (!parentShown) return false;

        // Check child-specific showOn conditions
        if (childShowOn != null) {
          // Implementation depends on your show logic
          return true; // Placeholder
        }
        return true;
      },
      initialValue: childInitialValue,
      nestingLevel: nestingLevel + 1,
      parentIsShown: isShownCallback(),
      ritaDependencies: ritaDependencies,
      checkValueForShowOn: checkValueForShowOn,
      showOn: childShowOn,
      selfIndices: childSelfIndices,
      ritaEvaluator: ritaEvaluator,
      getFullFormData: getFullFormData,
      showLabel: childShowLabel,
      onSavedCallback: childOnSavedCallback,
    );
  }
}
