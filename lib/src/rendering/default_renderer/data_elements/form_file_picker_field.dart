import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class FormFilePickerField extends StatelessWidget {
  final RenderContext ctx;

  const FormFilePickerField({super.key, required this.ctx});

  @override
  Widget build(BuildContext context) {
    final config = RenderHelpers.resolveFilePickerConfig(ctx);

    return FormBuilderFilePicker(
      name: ctx.id,
      onChanged: ctx.onChanged,
      onSaved: RenderHelpers.buildFilePickerOnSaved(ctx),
      enabled: ctx.enabled,
      decoration: RenderHelpers.buildInputDecoration(ctx, context),
      maxFiles: config.maxFiles,
      allowMultiple: config.allowMultiple,
      allowedExtensions: RenderHelpers.getFileExtensions(ctx.options),
      validator: RenderHelpers.createFilePickerValidator(ctx, config, context),
    );
  }
}
