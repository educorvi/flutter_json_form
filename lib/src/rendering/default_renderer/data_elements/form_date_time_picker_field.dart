import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';

class FormDateTimePickerField extends StatelessWidget {
  final RenderContext ctx;
  final InputType inputType;

  const FormDateTimePickerField({
    super.key,
    required this.ctx,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: FormBuilderDateTimePicker(
        name: ctx.id,
        onChanged: ctx.onChanged,
        enabled: ctx.enabled,
        validator: RenderHelpers.createBaseValidator(ctx),
        decoration: RenderHelpers.buildInputDecoration(
          ctx,
          context,
          suffixIcon: const Icon(Icons.date_range),
          hintText: RenderHelpers.getDateTimeHintText(inputType, context),
        ),
        initialValue: RenderHelpers.parseDefaultDateTime(ctx.initialValue),
        inputType: inputType,
        onSaved: (DateTime? dateTime) => ctx.onSavedCallback?.call(dateTime?.toIso8601String()),
      ),
    );
  }
}
