import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/json_form_renderer.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_json_forms/src/rendering/data_element_contexts.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/constants.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/form_elements/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_array/form_array_add_button.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_array/form_array_delete_button.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_array/form_array_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_array/form_array_reorder_button.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_object_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_checkbox_group_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_color_picker_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_date_time_picker_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_dropdown_fields.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_file_picker_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_radio_group_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_segmented_control_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_slider_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_switch_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/data_elements/form_text_field.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_button.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_button_group.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_divider.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_html.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_layout.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_wizard.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart' show ColorPickerType;
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/helpers/common.dart';
import 'package:flutter_json_forms/src/rendering/helpers/form_error.dart';
import 'package:flutter_json_forms/src/rendering/helpers/form_not_implemented.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/form_elements/form_help.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/form_elements/form_loader.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/form_elements/form_visibility.dart';

// ---------------------------------------------------------------------------
// Configuration objects – data controls
// ---------------------------------------------------------------------------

/// Extra options forwarded to [FormBuilderTextField] fields.
class TextFieldConfig {
  /// Minimum number of visible lines (multiline fields only).
  final int? minLines;

  /// Maximum number of characters; shows a counter below the field when set.
  final int? maxLength;

  const TextFieldConfig({this.minLines, this.maxLength});
}

/// Extra options for the colour picker field.
class ColorPickerConfig {
  /// The style of colour picker dialog to show.
  final ColorPickerType colorPickerType;

  /// Preset colours to show in the picker (empty = none).
  final List<Color> availableColors;

  const ColorPickerConfig({
    this.colorPickerType = ColorPickerType.colorPicker,
    this.availableColors = const [],
  });
}

// ---------------------------------------------------------------------------
// Configuration objects – UI layout elements
// ---------------------------------------------------------------------------

/// Spacing, padding, and alignment for vertical (column) layouts.
class VerticalLayoutConfig {
  final double elementSpacing;
  final EdgeInsets contentPadding;
  final CrossAxisAlignment crossAxisAlignment;

  const VerticalLayoutConfig({
    this.elementSpacing = UIConstants.elementSpacing,
    this.contentPadding = EdgeInsets.zero,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
}

/// Spacing, padding, and alignment for horizontal (row) layouts.
class HorizontalLayoutConfig {
  final double elementSpacing;
  final EdgeInsets contentPadding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const HorizontalLayoutConfig({
    this.elementSpacing = UIConstants.horizontalElementSpacing,
    this.contentPadding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
}

/// Visual styling for group layouts (indented / bordered sections).
class GroupLayoutConfig {
  final double indentation;
  final Color borderColor;
  final double borderWidth;
  final double elementSpacing;
  final EdgeInsets contentPadding;

  const GroupLayoutConfig({
    this.indentation = UIConstants.groupIndentation,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.elementSpacing = UIConstants.elementSpacing,
    this.contentPadding = EdgeInsets.zero,
  });
}

/// Visual options for button-group containers.
class ButtonGroupConfig {
  final double horizontalSpacing;
  final double verticalSpacing;

  const ButtonGroupConfig({
    this.horizontalSpacing = UIConstants.horizontalElementSpacing,
    this.verticalSpacing = UIConstants.verticalElementSpacing,
  });
}

/// Visual options for the wizard (multi-step form).
class WizardConfig {
  /// Scroll physics passed to the inner [Stepper].
  final ScrollPhysics physics;

  const WizardConfig({
    this.physics = const NeverScrollableScrollPhysics(),
  });
}

// ---------------------------------------------------------------------------
// Default renderer
// ---------------------------------------------------------------------------

/// The default [JsonFormRenderer] used by [FlutterJsonForm].
///
/// ### Configuring built-in widgets
/// ```dart
/// FlutterJsonForm(
///   renderer: DefaultJsonFormRenderer(
///     colorPickerConfig: ColorPickerConfig(colorPickerType: ColorPickerType.materialPicker),
///     verticalLayoutConfig: VerticalLayoutConfig(elementSpacing: 12),
///   ),
/// )
/// ```
///
/// ### Overriding individual controls
/// ```dart
/// class MyRenderer extends DefaultJsonFormRenderer {
///   @override
///   Widget buildDataColorControl(BuildContext context, RenderContext ctx) =>
///       MyColorPicker(ctx: ctx);
///   @override
///   Widget buildUiDivider(BuildContext context) => const SizedBox(height: 24);
/// }
/// ```
class DefaultJsonFormRenderer extends JsonFormRenderer {
  final TextFieldConfig textFieldConfig;
  final ColorPickerConfig colorPickerConfig;
  final VerticalLayoutConfig verticalLayoutConfig;
  final HorizontalLayoutConfig horizontalLayoutConfig;
  final GroupLayoutConfig groupLayoutConfig;
  final ButtonGroupConfig buttonGroupConfig;
  final WizardConfig wizardConfig;

  /// When `false`, [buildErrorWidget] and [buildNotImplementedWidget] return
  /// [SizedBox.shrink] instead of a visible error widget.
  ///
  /// Useful for production forms where broken schema entries should be silently
  /// ignored rather than shown as red error placeholders.
  final bool showErrors;

  const DefaultJsonFormRenderer({
    this.textFieldConfig = const TextFieldConfig(),
    this.colorPickerConfig = const ColorPickerConfig(),
    this.verticalLayoutConfig = const VerticalLayoutConfig(),
    this.horizontalLayoutConfig = const HorizontalLayoutConfig(),
    this.groupLayoutConfig = const GroupLayoutConfig(),
    this.buttonGroupConfig = const ButtonGroupConfig(),
    this.wizardConfig = const WizardConfig(),
    this.showErrors = true,
  });

  // =========================================================================
  // Data / JSON-schema controls
  // =========================================================================

  @override
  Widget buildDataStringControl(BuildContext context, RenderContext ctx) {
    return FormTextField(ctx: ctx, expectedType: String);
  }

  @override
  Widget buildDataDateControl(BuildContext context, RenderContext ctx) {
    return FormDateTimePickerField(ctx: ctx, inputType: InputType.date);
  }

  @override
  Widget buildDataTimeControl(BuildContext context, RenderContext ctx) {
    return FormDateTimePickerField(ctx: ctx, inputType: InputType.time);
  }

  @override
  Widget buildDataDateTimeControl(BuildContext context, RenderContext ctx) {
    return FormDateTimePickerField(ctx: ctx, inputType: InputType.both);
  }

  @override
  Widget buildDataColorControl(BuildContext context, RenderContext ctx) {
    return FormColorPickerField(
      ctx: ctx,
      colorPickerType: colorPickerConfig.colorPickerType,
      availableColors: colorPickerConfig.availableColors,
    );
  }

  @override
  Widget buildDataFileControl(BuildContext context, RenderContext ctx) {
    return FormFilePickerField(ctx: ctx);
  }

  @override
  Widget buildDataNumberControl(BuildContext context, RenderContext ctx, {Type numType = double}) {
    return FormTextField(ctx: ctx, expectedType: numType);
  }

  @override
  Widget buildDataSliderControl(BuildContext context, RenderContext ctx) {
    return FormSliderField(ctx: ctx);
  }

  @override
  Widget buildDataBooleanControl(BuildContext context, RenderContext ctx) {
    return FormSwitchField(ctx: ctx);
  }

  @override
  Widget buildDataDropdownControl(BuildContext context, RenderContext ctx, List<dynamic> values) {
    return FormDropdownField(ctx: ctx, values: values);
  }

  @override
  Widget buildDataRadioGroupControl(BuildContext context, RenderContext ctx, List<dynamic> values) {
    return FormRadioGroupField(ctx: ctx, values: values);
  }

  @override
  Widget buildDataCheckboxGroupControl(BuildContext context, RenderContext ctx, List<String> values) {
    return FormCheckboxGroupField(ctx: ctx, values: values);
  }

  @override
  Widget buildDataSegmentedControl(BuildContext context, RenderContext ctx, List<dynamic> values) {
    return FormSegmentedControlField(ctx: ctx, values: values);
  }

  @override
  Widget buildDataObjectControl(BuildContext context, RenderContext ctx) {
    return FormObjectField(ctx: ctx);
  }

  @override
  Widget buildDataArrayControl(BuildContext context, RenderContext ctx) {
    return FormArrayField(ctx: ctx);
  }

  @override
  Widget buildDataFieldWrapper(
    BuildContext context,
    RenderContext ctx, {
    required Widget child,
    bool? isComplexField,
    bool? ignoreLabel,
  }) {
    return FormFieldWrapper(
      formFieldContext: ctx,
      complexElement: isComplexField,
      ignoreLabel: ignoreLabel,
      child: child,
    );
  }

  // =========================================================================
  // Array sub-component renderers
  // =========================================================================

  @override
  Widget buildArrayAddButton(BuildContext context, ArrayAddButtonContext ctx) {
    return FormArrayAddButton(
      testKey: ctx.testKey,
      onPressed: ctx.canAdd ? ctx.onAdd : null,
      label: ctx.label,
    );
  }

  @override
  Widget buildArrayReorderButton(BuildContext context, ArrayReorderButtonContext ctx) {
    return FormArrayReorderButton(
      theme: Theme.of(context),
      gap: UIConstants.verticalElementSpacing,
      index: ctx.index,
      label: ctx.label,
      canReorder: ctx.canReorder,
      testKey: ctx.testKey,
    );
  }

  @override
  Widget buildArrayDeleteButton(BuildContext context, ArrayDeleteButtonContext ctx) {
    return FormArrayDeleteButton(
      theme: Theme.of(context),
      index: ctx.index,
      gap: UIConstants.verticalElementSpacing,
      itemId: ctx.itemId,
      canRemove: ctx.canRemove,
      tooltip: ctx.tooltip,
      onRemove: ctx.onRemove,
      testKey: ctx.testKey,
    );
  }

  @override
  Widget buildArrayItemLayout(
    BuildContext context,
    ArrayItemContext ctx, {
    required Widget child,
    required Widget reorderButton,
    required Widget deleteButton,
  }) {
    const double sideActionWidth = UIConstants.verticalSpacingForArrayControlItems;
    final topPadding = ctx.isFirst ? 0.0 : UIConstants.verticalElementSpacing / 2;
    final bottomPadding = ctx.isLast ? 0.0 : UIConstants.verticalElementSpacing / 2;

    return Container(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sideActionWidth),
            child: child,
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: sideActionWidth,
            child: reorderButton,
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: sideActionWidth,
            child: deleteButton,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Object layout renderer
  // =========================================================================

  @override
  Widget buildObjectLayout(BuildContext context, RenderContext ctx, List<Widget> children) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    return ctx.showObjectLeadingLine ? getLineContainer(child: column) : column;
  }

  // =========================================================================
  // UI-schema structural elements
  // =========================================================================

  @override
  Widget buildUiVerticalLayout(BuildContext context, UiLayoutContext layout, List<Widget> children) =>
      buildDefaultVerticalLayout(context, layout, children, verticalLayoutConfig.contentPadding, verticalLayoutConfig.crossAxisAlignment);

  @override
  Widget buildUiHorizontalLayout(BuildContext context, UiLayoutContext layout, List<Widget> children) => buildDefaultHorizontalLayout(
        context,
        layout,
        children,
        horizontalLayoutConfig.contentPadding,
        horizontalLayoutConfig.mainAxisAlignment,
        horizontalLayoutConfig.crossAxisAlignment,
      );

  @override
  Widget buildUiGroup(BuildContext context, UiLayoutContext layout, List<Widget> children) => buildDefaultGroup(
        context,
        layout,
        children,
        groupLayoutConfig.indentation,
        groupLayoutConfig.borderColor,
        groupLayoutConfig.borderWidth,
        groupLayoutConfig.contentPadding,
      );

  @override
  Widget buildUiDivider(BuildContext context, UiDividerContext divider) => buildDefaultDivider(context, divider);

  @override
  Widget buildUiHtml(BuildContext context, UiHtmlContext html) => buildDefaultHtml(context, html);

  @override
  Widget buildUiButton(BuildContext context, UiButtonContext button) => buildDefaultButton(context, button);

  @override
  Widget buildUiButtonGroup(BuildContext context, UiButtonGroupContext buttonGroup) =>
      buildDefaultButtonGroup(context, buttonGroup, buttonGroupConfig.horizontalSpacing, buttonGroupConfig.verticalSpacing);

  @override
  Widget buildUiWizard(BuildContext context, UiWizardContext wizard) => buildDefaultWizard(context, wizard, wizardConfig.physics);

  // =========================================================================
  // Meta-widgets
  // =========================================================================

  @override
  Widget buildLoadingWidget(BuildContext context) => const FormLoader();

  @override
  Widget buildErrorWidget(BuildContext context, String message) => showErrors ? FormError(message) : const SizedBox.shrink();

  @override
  Widget buildNotImplementedWidget(BuildContext context, String type) => showErrors ? FormNotImplemented(type) : const SizedBox.shrink();

  @override
  Widget buildHelpWidget(BuildContext context, ui.ControlFormattingOptionsHelp help) => FormHelp(help: help);

  @override
  Widget buildVisibilityWrapper(
    BuildContext context, {
    required Widget child,
    required bool isVisible,
  }) =>
      buildAnimatedVisibility(child: child, isVisible: isVisible);
}
