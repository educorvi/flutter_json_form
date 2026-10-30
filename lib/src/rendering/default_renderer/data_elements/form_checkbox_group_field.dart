import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';

class FormCheckboxGroupField extends StatelessWidget {
  final RenderContext ctx;
  final List<String> values;

  const FormCheckboxGroupField({
    super.key,
    required this.ctx,
    required this.values,
  });

  @override
  Widget build(BuildContext buildContext) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 400),
      child: FormBuilderCheckboxGroup(
        name: ctx.id,
        initialValue: ctx.initialValue,
        onChanged: ctx.onChanged,
        onSaved: ctx.onSavedCallback,
        enabled: ctx.enabled,
        validator: RenderHelpers.createBaseValidator<List<String>>(ctx),
        decoration: RenderHelpers.buildInputDecoration(ctx, buildContext, border: false),
        orientation: RenderHelpers.getOptionsOrientation(ctx.options),
        options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
      ),
    );
  }
}
