import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/form_elements/form_field_text.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormSwitchField extends StatelessWidget {
  final RenderContext ctx;

  const FormSwitchField({
    super.key,
    required this.ctx,
  });

  @override
  Widget build(BuildContext buildContext) {
    final initialValue = RenderHelpers.parseBoolInitialValue(ctx.initialValue);

    return FormBuilderSwitch(
      key: Key(ctx.scope),
      initialValue: initialValue,
      name: ctx.id,
      onChanged: ctx.onChanged,
      enabled: ctx.enabled,
      onSaved: ctx.onSavedCallback,
      validator: RenderHelpers.createBaseValidator(
        ctx,
        additionalValidators: ctx.required ? [FormBuilderValidators.equal(true)] : null,
      ),
      title: FormFieldText(RenderHelpers.getLabel(ctx, forInputDecoration: false) ?? "", required: ctx.required),
      contentPadding: const EdgeInsets.all(0),
      decoration: const InputDecoration(border: InputBorder.none),
      subtitle: ctx.description != null ? FormFieldText(ctx.description!) : null,
    );
  }
}
