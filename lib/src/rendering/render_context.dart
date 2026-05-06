import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:json_schema/json_schema.dart';

/// The single context object for both public renderer consumers and internal
/// library implementations.
///
/// **Public fields** (id, scope, jsonSchema, options, format, required, enabled,
/// showLabel, title, description, placeholder, initialValue, type, onChanged,
/// onSaved, isShownCallback, nestingLevel) are stable and safe to use in custom
/// [JsonFormRenderer] implementations.
///
/// **Internal fields** (selfIndices, showObjectLeadingLine, getFullFormData,
/// onSavedCallback, isElementShown, showOn) are used by built-in data elements
/// and should not be relied upon in custom renderer implementations as they may
/// change between versions.
class RenderContext {
  // =========================================================================
  // Public fields
  // =========================================================================

  /// The form-field name used by `flutter_form_builder` as the key.
  final String id;

  /// The JSON-schema path of this field (e.g. `#/properties/name`).
  final String scope;

  /// The resolved JSON Schema node for this field.
  final JsonSchema jsonSchema;

  /// UI-schema options configured for this control.
  final ui.Options? options;

  /// Explicit format override from the UI schema.
  final ui.Format? format;

  /// Whether this field is required by the schema or UI schema.
  final bool required;

  /// Whether this field is interactive (`false` when `options.disabled == true`).
  final bool enabled;

  /// Whether a label should be rendered for this field.
  final bool showLabel;

  /// Human-readable title from the JSON Schema.
  final String? title;

  /// Description text from the JSON Schema.
  final String? description;

  /// Placeholder text from `options.formattingOptions.placeholder`.
  final String? placeholder;

  /// Initial / default value for the field.
  dynamic initialValue;

  /// The primitive schema type.
  final SchemaType? type;

  /// Called when the field value changes.
  final void Function(dynamic)? onChanged;

  /// Called when the form is saved. Array-index tracking is handled internally.
  final void Function(dynamic)? onSaved;

  /// Returns `true` when this field should currently be visible.
  ///
  /// This is a lazy callback (not an eager bool) so validators — which run
  /// after the widget is built — observe the current visibility state.
  final bool Function() isShownCallback;

  /// Nesting depth, starting at 0 for top-level fields.
  final int nestingLevel;

  // =========================================================================
  // Internal fields (library use only)
  // =========================================================================

  /// [internal] Array index tracking for nested array items.
  final Map<String, int>? selfIndices;

  /// [internal] Whether to show a leading line in object fields.
  final bool showObjectLeadingLine;

  /// [internal] Full form data accessor for conditional logic.
  final Map<String, dynamic> Function()? getFullFormData;

  /// [internal] Save callback that also carries array-index information.
  /// For non-array contexts this wraps [onSaved] with no extra logic.
  final void Function(dynamic, {Map<String, int>? computedSelfIndices})? onSavedCallback;

  /// [internal] Low-level visibility evaluation from [FormContext].
  /// Used when creating child contexts that need to evaluate their own showOn
  /// independent of the parent callback.
  final bool Function({
    required ui.ShowOnProperty? showOn,
    Map<String, int>? selfIndices,
    required bool? parentIsShown,
  }) isElementShown;

  /// [internal] The showOn rule for this field (needed for child context creation).
  final ui.ShowOnProperty? showOn;

  // =========================================================================
  // Constructors
  // =========================================================================

  RenderContext._({
    required this.id,
    required this.scope,
    required this.jsonSchema,
    required this.options,
    required this.format,
    required this.required,
    required this.enabled,
    required this.showLabel,
    required this.title,
    required this.description,
    required this.placeholder,
    required this.initialValue,
    required this.type,
    required this.onChanged,
    required this.onSaved,
    required this.isShownCallback,
    required this.nestingLevel,
    required this.selfIndices,
    required this.showObjectLeadingLine,
    required this.getFullFormData,
    required this.onSavedCallback,
    required this.isElementShown,
    required this.showOn,
  });

  // =========================================================================
  // Factory: build from Flutter's BuildContext + FormContext
  // =========================================================================

  /// Creates a [RenderContext] for a top-level or mid-level form control by
  /// reading the current [FormContext] from the widget tree.
  ///
  /// This is the primary entry point used by library code that bridges the
  /// UI-schema `Control` element → data field widget pipeline.
  factory RenderContext.fromFormContext({
    required BuildContext context,
    required String scope,
    required String id,
    required JsonSchema jsonSchema,
    required bool required,
    required int nestingLevel,
    ui.Options? options,
    ui.Format? format,
    ui.ShowOnProperty? showOn,
    dynamic initialValue,
    bool showLabel = true,
    bool showObjectLeadingLine = true,
    bool? parentIsShown,
    Map<String, int>? selfIndices,
    void Function(dynamic)? onChanged,
    void Function(dynamic)? onSavedCallback,
  }) {
    final formContext = FormContext.of(context)!;

    bool isShown() => formContext.elementShown(
          showOn: showOn,
          parentIsShown: parentIsShown,
          selfIndices: selfIndices,
        );

    void saveAndNotify(
      dynamic value, {
      Map<String, int>? computedSelfIndices,
    }) {
      if (onSavedCallback != null) onSavedCallback(value);
      if (formContext.elementShown(
        showOn: showOn,
        parentIsShown: parentIsShown,
        selfIndices: computedSelfIndices ?? selfIndices,
      )) {
        formContext.onFormValueSaved(scope, value);
      }
    }

    final resolvedInitial = initialValue ?? jsonSchema.defaultValue;

    return RenderContext._(
      id: id,
      scope: scope,
      jsonSchema: jsonSchema,
      options: options,
      format: format,
      required: required,
      enabled: options?.formattingOptions?.disabled == true ? false : true,
      showLabel: showLabel,
      title: jsonSchema.title,
      description: jsonSchema.description,
      placeholder: options?.formattingOptions?.placeholder,
      initialValue: resolvedInitial,
      type: _safeType(jsonSchema),
      onChanged: onChanged,
      onSaved: (value) => saveAndNotify(value),
      isShownCallback: isShown,
      nestingLevel: nestingLevel,
      selfIndices: selfIndices,
      showObjectLeadingLine: showObjectLeadingLine,
      getFullFormData: formContext.getFullFormData,
      onSavedCallback: saveAndNotify,
      isElementShown: formContext.elementShown,
      showOn: showOn,
    );
  }

  // =========================================================================
  // Child context creation
  // =========================================================================

  /// Creates a child [RenderContext] for a nested property (object field) or
  /// array item.
  ///
  /// The child's [isShownCallback] automatically incorporates the parent's
  /// visibility: if the parent is hidden the child is always hidden, regardless
  /// of its own [childShowOn] rule.
  RenderContext createChildContext({
    required String childScope,
    required String childId,
    required JsonSchema childJsonSchema,
    ui.Options? childOptions,
    ui.ShowOnProperty? childShowOn,
    dynamic childInitialValue,
    bool childRequired = false,
    bool childShowLabel = true,
    Map<String, int>? childSelfIndices,
    bool? childShowObjectLeadingLine,
    void Function(dynamic)? childOnChanged,
    void Function(dynamic, {Map<String, int>? computedSelfIndices})? childOnSavedCallback,
  }) {
    final effectiveOptions = childOptions ?? options;

    bool childIsShown() {
      // Parent must be visible first
      if (!isShownCallback()) return false;
      if (childShowOn != null) {
        return isElementShown(
          showOn: childShowOn,
          selfIndices: childSelfIndices ?? selfIndices,
          parentIsShown: isShownCallback(),
        );
      }
      return true;
    }

    return RenderContext._(
      id: childId,
      scope: childScope,
      jsonSchema: childJsonSchema,
      options: effectiveOptions,
      format: format,
      required: childRequired,
      enabled: effectiveOptions?.formattingOptions?.disabled == true ? false : true,
      showLabel: childShowLabel,
      title: childJsonSchema.title,
      description: childJsonSchema.description,
      placeholder: effectiveOptions?.formattingOptions?.placeholder,
      initialValue: childInitialValue,
      type: _safeType(childJsonSchema),
      onChanged: childOnChanged,
      onSaved: childOnSavedCallback != null ? (v) => childOnSavedCallback(v) : null,
      isShownCallback: childIsShown,
      nestingLevel: nestingLevel + 1,
      selfIndices: childSelfIndices ?? selfIndices,
      showObjectLeadingLine: childShowObjectLeadingLine ?? showObjectLeadingLine,
      getFullFormData: getFullFormData,
      onSavedCallback: childOnSavedCallback,
      isElementShown: isElementShown,
      showOn: childShowOn,
    );
  }

  // =========================================================================
  // Helpers
  // =========================================================================

  static SchemaType? _safeType(JsonSchema schema) {
    try {
      return schema.type;
    } catch (_) {
      return null;
    }
  }
}
