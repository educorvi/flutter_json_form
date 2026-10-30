import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class FormColorPickerField extends StatelessWidget {
  final RenderContext ctx;

  /// The style of colour picker dialog to show.
  final ColorPickerType colorPickerType;

  /// Preset colours to show in the picker (empty = none).
  final List<Color> availableColors;

  const FormColorPickerField({
    super.key,
    required this.ctx,
    this.colorPickerType = ColorPickerType.colorPicker,
    this.availableColors = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderColorPickerField(
      name: ctx.id,
      // initialValue: ctx.initialValue,
      onChanged: ctx.onChanged,
      onSaved: ctx.onSavedCallback,
      enabled: ctx.enabled,
      validator: RenderHelpers.createBaseValidator(ctx),
      decoration: RenderHelpers.buildInputDecoration(ctx, context),
      colorPickerType: colorPickerType,
      availableColors: availableColors,
    );
  }
}
