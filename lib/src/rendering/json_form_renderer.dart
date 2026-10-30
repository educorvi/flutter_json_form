import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_json_forms/src/rendering/data_element_contexts.dart';

/// The rendering interface for [FlutterJsonForm].
///
/// This is the **full contract** — every method must be implemented when you
/// implement this class directly.
///
/// ## Partial overrides (recommended)
///
/// In most cases you only want to replace one or two widgets.  The cleanest
/// way to do that is to **extend [DefaultJsonFormRenderer]** and override only
/// the methods you care about; everything else falls back to the Material /
/// Flutter Form Builder implementation automatically:
///
/// ```dart
/// // Only a custom divider — all other 25+ methods use DefaultJsonFormRenderer.
/// class MyRenderer extends DefaultJsonFormRenderer {
///   const MyRenderer() : super(showErrors: false);
///
///   @override
///   Widget buildUiDivider(BuildContext context, UiDividerContext divider) {
///     return const Padding(
///       padding: EdgeInsets.symmetric(vertical: 12),
///       child: Divider(thickness: 2, color: Colors.indigo),
///     );
///   }
/// }
/// ```
///
/// ## Full custom renderer
///
/// When you use a completely different widget library (e.g. Cupertino) you can
/// implement [JsonFormRenderer] directly.  You must provide all methods.
///
/// Methods are grouped into two namespaces:
///
/// - **`buildData*`** – data / JSON-schema controls (text fields, pickers, …).
///   Each method receives a [RenderContext] with all the schema information.
///   Use [RenderHelpers] for validators, decorations and type conversions.
///
/// - **`buildUi*`** – UI-schema structural elements (layouts, buttons,
///   dividers, wizard, …).  Each method receives a typed context object.
abstract class JsonFormRenderer {
  const JsonFormRenderer();

  // =========================================================================
  // Data / JSON-schema controls
  // =========================================================================

  // ---------------------------------------------------------------------------
  // String-based controls
  // ---------------------------------------------------------------------------

  /// Builds a generic single-line or multi-line text input.
  Widget buildDataStringControl(BuildContext context, RenderContext ctx);

  /// Builds a date picker.
  Widget buildDataDateControl(BuildContext context, RenderContext ctx);

  /// Builds a time picker.
  Widget buildDataTimeControl(BuildContext context, RenderContext ctx);

  /// Builds a combined date-and-time picker.
  Widget buildDataDateTimeControl(BuildContext context, RenderContext ctx);

  /// Builds a colour picker.
  Widget buildDataColorControl(BuildContext context, RenderContext ctx);

  /// Builds a file picker.
  Widget buildDataFileControl(BuildContext context, RenderContext ctx);

  // ---------------------------------------------------------------------------
  // Numeric controls
  // ---------------------------------------------------------------------------

  /// Builds a numeric text input.
  ///
  /// [numType] is either [int] or [double] and should be used when converting
  /// saved/changed values to the correct Dart type.
  Widget buildDataNumberControl(BuildContext context, RenderContext ctx, {Type numType = double});

  /// Builds a slider control for numeric ranges.
  Widget buildDataSliderControl(BuildContext context, RenderContext ctx);

  // ---------------------------------------------------------------------------
  // Boolean control
  // ---------------------------------------------------------------------------

  /// Builds a toggle/switch for boolean fields.
  Widget buildDataBooleanControl(BuildContext context, RenderContext ctx);

  // ---------------------------------------------------------------------------
  // Enum controls
  // ---------------------------------------------------------------------------

  /// Builds a dropdown for single-selection enum fields.
  ///
  /// [values] is the raw list of enum values from the JSON schema. Use
  /// [RenderHelpers.buildEnumEntries] to map them to `(value, label)` pairs.
  Widget buildDataDropdownControl(BuildContext context, RenderContext ctx, List<dynamic> values);

  /// Builds a radio-button group for single-selection enum fields.
  Widget buildDataRadioGroupControl(BuildContext context, RenderContext ctx, List<dynamic> values);

  /// Builds a checkbox group for multi-selection array fields whose items have
  /// an `enum` constraint.
  ///
  /// [values] contains string representations of the allowed item values.
  Widget buildDataCheckboxGroupControl(BuildContext context, RenderContext ctx, List<String> values);

  /// Builds a segmented button control for single-selection enum fields.
  Widget buildDataSegmentedControl(BuildContext context, RenderContext ctx, List<dynamic> values);

  // ---------------------------------------------------------------------------
  // Complex data controls
  // ---------------------------------------------------------------------------

  /// Builds the control for an `object` schema (nested property group).
  ///
  /// Override [buildObjectLayout] to customise only the visual arrangement of
  /// the already-built child widgets without touching any field logic.
  Widget buildDataObjectControl(BuildContext context, RenderContext ctx);

  /// Builds the control for an `array` schema (repeatable item list).
  ///
  /// Override the individual `buildArray*` methods to customise only the
  /// add / reorder / delete buttons and item wrapper without touching any
  /// list-management logic.
  Widget buildDataArrayControl(BuildContext context, RenderContext ctx);

  // ---------------------------------------------------------------------------
  // Data field wrapper
  // ---------------------------------------------------------------------------

  /// Wraps a data control [child] with the standard label, description, help
  /// button, pre/post HTML, CSS class, and animated-visibility logic.
  ///
  /// [isComplexField] is `true` for array and object controls; the wrapper
  /// may use a larger heading style in that case.  [ignoreLabel] suppresses
  /// the label entirely (e.g. for boolean switch fields that render their own
  /// label inline).
  Widget buildDataFieldWrapper(
    BuildContext context,
    RenderContext ctx, {
    required Widget child,
    bool? isComplexField,
    bool? ignoreLabel,
  });

  // =========================================================================
  // UI-schema structural elements
  // =========================================================================

  // ---------------------------------------------------------------------------
  // Layout containers
  // ---------------------------------------------------------------------------

  /// Builds a vertical (column) layout.
  ///
  /// [children] are the already-built child widgets in their visual order.
  /// [layout] exposes the label, description, and CSS class from the schema.
  ///
  /// When [layout.hasHeader] is `true`, the default renderer wraps [children]
  /// in a [LayoutHeaderScope] so nested data-field wrappers can suppress their
  /// own heading.  Custom renderers that keep the default data-field wrapper
  /// should do the same.
  Widget buildUiVerticalLayout(BuildContext context, UiLayoutContext layout, List<Widget> children);

  /// Builds a horizontal (row) layout.
  ///
  /// Each child in [children] should be wrapped in an [Expanded] widget (or
  /// equivalent) so the row fills the available width.  The default renderer
  /// does this automatically.
  Widget buildUiHorizontalLayout(BuildContext context, UiLayoutContext layout, List<Widget> children);

  /// Builds a grouped layout (visually indented / bordered section).
  Widget buildUiGroup(BuildContext context, UiLayoutContext layout, List<Widget> children);

  // ---------------------------------------------------------------------------
  // Simple UI elements
  // ---------------------------------------------------------------------------

  /// Builds a visual divider / separator.
  Widget buildUiDivider(BuildContext context, UiDividerContext divider);

  /// Builds an HTML content block.
  Widget buildUiHtml(BuildContext context, UiHtmlContext html);

  // ---------------------------------------------------------------------------
  // Buttons
  // ---------------------------------------------------------------------------

  /// Builds a single action button.
  ///
  /// The renderer implementation is responsible for resolving the press
  /// callback from [UiButtonContext.button] via [ButtonHelpers.resolveOnPressed].
  Widget buildUiButton(BuildContext context, UiButtonContext button);

  /// Builds a group of action buttons.
  ///
  /// The renderer implementation is responsible for creating individual button
  /// widgets from [UiButtonGroupContext.buttonGroup.buttons].
  Widget buildUiButtonGroup(BuildContext context, UiButtonGroupContext buttonGroup);

  // ---------------------------------------------------------------------------
  // Wizard
  // ---------------------------------------------------------------------------

  /// Builds the wizard (multi-step form) shell.
  ///
  /// The renderer implementation is responsible for computing visible pages,
  /// building step content, and wrapping the output in a [FormWizardScope].
  Widget buildUiWizard(BuildContext context, UiWizardContext wizard);

  // =========================================================================
  // Array sub-component renderers
  // =========================================================================
  //
  // These are called by the stateful array widget after all list-management
  // logic (adding, removing, reordering) has been resolved.  Implement these
  // methods to control UI only — the logic lives in [ArrayHelpers].

  /// Builds the button that adds a new item to the array.
  ///
  /// [ctx.canAdd] is `false` when `maxItems` has been reached — the
  /// implementation should disable or hide the button accordingly.
  Widget buildArrayAddButton(BuildContext context, ArrayAddButtonContext ctx);

  /// Builds the drag-handle that lets users reorder array items.
  ///
  /// [ctx.canReorder] is `false` when only one item is present.
  Widget buildArrayReorderButton(BuildContext context, ArrayReorderButtonContext ctx);

  /// Builds the button that removes an array item.
  ///
  /// [ctx.canRemove] is `false` when removing would violate `minItems`.
  Widget buildArrayDeleteButton(BuildContext context, ArrayDeleteButtonContext ctx);

  /// Wraps a single array item together with its reorder and delete controls.
  ///
  /// [child] is the already-built content widget for this item.
  /// [reorderButton] and [deleteButton] are already built via
  /// [buildArrayReorderButton] and [buildArrayDeleteButton].
  ///
  /// The implementation decides how to position the controls relative to the
  /// item content (e.g. side-by-side, overlaid, above/below).
  Widget buildArrayItemLayout(
    BuildContext context,
    ArrayItemContext ctx, {
    required Widget child,
    required Widget reorderButton,
    required Widget deleteButton,
  });

  // =========================================================================
  // Object layout renderer
  // =========================================================================

  /// Arranges the already-built child widgets of an object field.
  ///
  /// [children] is the list of pre-built child form elements (with spacing
  /// already applied by [SpacingUtils]).  The implementation only needs to
  /// specify the visual arrangement — for example a [Column] — without
  /// knowing anything about the underlying schema or form state.
  ///
  /// Use [ctx.showObjectLeadingLine] and the [RenderContext] accessors if you
  /// need schema-level information (title, description, etc.).
  Widget buildObjectLayout(BuildContext context, RenderContext ctx, List<Widget> children);

  // =========================================================================
  // Meta-widgets
  // =========================================================================

  /// Builds the loading/skeleton widget shown while the form initialises.
  Widget buildLoadingWidget(BuildContext context);

  /// Builds a widget that displays an error [message] inside the form.
  Widget buildErrorWidget(BuildContext context, String message);

  /// Builds a placeholder for a field type that is not yet implemented.
  Widget buildNotImplementedWidget(BuildContext context, String type);

  /// Builds the help button shown next to a field label when the schema
  /// specifies `formattingOptions.help`.
  Widget buildHelpWidget(
    BuildContext context,
    ui.ControlFormattingOptionsHelp help,
  );

  /// Wraps [child] in a visibility widget driven by [isVisible].
  Widget buildVisibilityWrapper(
    BuildContext context, {
    required Widget child,
    required bool isVisible,
  });
}
