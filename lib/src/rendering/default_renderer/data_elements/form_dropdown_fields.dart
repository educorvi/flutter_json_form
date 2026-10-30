import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/form_elements/form_field_text.dart';

class FormDropdownField extends StatelessWidget {
  final RenderContext ctx;
  final List<dynamic> values;
  //final Widget Function(dynamic value, String label)? itemBuilder;

  const FormDropdownField({
    super.key,
    required this.ctx,
    required this.values,
    //this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final enumTitles = ctx.options?.enumOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);

    return FormBuilderDropdown(
      name: ctx.id,
      onChanged: ctx.onChanged,
      onSaved: ctx.onSavedCallback,
      enabled: ctx.enabled,
      validator: RenderHelpers.createBaseValidator(ctx),
      decoration: RenderHelpers.buildInputDecoration(ctx, context),
      initialValue: ctx.initialValue,
      items: mapped.map((entry) {
        //final child = itemBuilder != null ? itemBuilder!(entry.key, entry.value) : FormFieldText(entry.value);
        return DropdownMenuItem(value: entry.key, child: FormFieldText(entry.value)); // child
      }).toList(growable: false),
    );
  }
}
