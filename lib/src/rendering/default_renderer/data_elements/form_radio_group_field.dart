import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';

class FormRadioGroupField extends StatelessWidget {
  final RenderContext ctx;
  final List<dynamic> values;
  // final Widget Function(dynamic value, String label)? optionBuilder;

  const FormRadioGroupField({
    super.key,
    required this.ctx,
    required this.values,
    // this.optionBuilder,
  });

  @override
  Widget build(BuildContext buildContext) {
    final enumTitles = ctx.options?.enumOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);

    return FormBuilderRadioGroup(
      initialValue: ctx.initialValue,
      name: ctx.id,
      onChanged: ctx.onChanged,
      onSaved: ctx.onSavedCallback,
      enabled: ctx.enabled,
      validator: RenderHelpers.createBaseValidator(ctx),
      decoration: RenderHelpers.buildInputDecoration(ctx, buildContext, border: false),
      options: mapped.map((entry) {
        // final child = optionBuilder != null ? optionBuilder!(entry.key, entry.value) : Text(entry.value);
        return FormBuilderFieldOption(value: entry.key, child: Text(entry.value)); // child
      }).toList(growable: false),
      orientation: RenderHelpers.getOptionsOrientation(ctx.options),
    );
  }
}
