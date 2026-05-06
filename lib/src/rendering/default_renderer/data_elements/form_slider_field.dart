import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:flutter_json_forms/src/utils/validators/validators.dart';

class FormSliderField extends StatelessWidget {
  final RenderContext ctx;

  const FormSliderField({
    super.key,
    required this.ctx,
  });

  @override
  Widget build(BuildContext buildContext) {
    final double min = safeParseDouble(ctx.jsonSchema.minimum);
    final double max = safeParseDouble(ctx.jsonSchema.maximum);
    final double? multiple = ctx.jsonSchema.multipleOf != null ? safeParseDouble(ctx.jsonSchema.multipleOf) : null;

    final int? divisions = RenderHelpers.computeSliderDivisions(min, max, multiple);
    final double initialValue = RenderHelpers.parseNumericInitialValue(ctx.initialValue, min);

    return FormBuilderSlider(
      name: ctx.id,
      onChanged: (value) => ctx.onChanged?.call(value?.toDouble()),
      onSaved: (value) => ctx.onSavedCallback?.call(RenderHelpers.castSliderValue(ctx.type, value)),
      enabled: ctx.enabled,
      validator: RenderHelpers.createBaseValidator(
        ctx,
        additionalValidators: multiple != null && multiple > 0 ? [JsonSchemaValidators.multipleOf<dynamic>(multiple)] : null,
      ),
      decoration: RenderHelpers.buildInputDecoration(ctx, buildContext, border: false),
      min: min,
      max: max,
      divisions: divisions,
      initialValue: initialValue,
    );
  }
}
