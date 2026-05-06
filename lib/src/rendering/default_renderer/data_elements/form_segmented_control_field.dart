import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/custom_form_input_fields/form_builder_segmented_button.dart';

class FormSegmentedControlField extends StatelessWidget {
  final RenderContext ctx;
  final List<dynamic> values;
  // final Widget Function(dynamic value, String label)? segmentBuilder;

  const FormSegmentedControlField({
    super.key,
    required this.ctx,
    required this.values,
    // this.segmentBuilder,
  });

  @override
  Widget build(BuildContext buildContext) {
    final enumTitles = ctx.options?.enumOptions?.enumTitles;
    final mapped = mapEnumValuesToTitles(values, enumTitles);

    return FormBuilderSegmentedButton<dynamic>(
      name: ctx.id,
      onChanged: ctx.onChanged,
      onSaved: ctx.onSavedCallback,
      initialValue: ctx.initialValue,
      enabled: ctx.enabled,
      decoration: RenderHelpers.buildInputDecoration(ctx, buildContext, border: false),
      segments: mapped.map((entry) {
        // final label = segmentBuilder != null ? segmentBuilder!(entry.key, entry.value) : Text(entry.value);
        return ButtonSegment(value: entry.key, label: Text(entry.value)); // label
      }).toList(growable: false),
      showSelectedIcon: true,
      selectedIcon: const Icon(Icons.check),
      stacked: ctx.options?.enumOptions?.stacked,
    );
  }
}
