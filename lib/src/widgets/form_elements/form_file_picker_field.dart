import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class FormFilePickerField extends StatelessWidget {
  final FormFieldContext formFieldContext;

  const FormFilePickerField({
    super.key,
    required this.formFieldContext,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldWrapper(
      context: formFieldContext,
      child: FormBuilderFilePicker(
        name: formFieldContext.id,
        onChanged: formFieldContext.onChanged,
        onSaved: formFieldContext.onSavedCallback,
        enabled: formFieldContext.enabled,
        validator: FormFieldUtils.createBaseValidator(formFieldContext),
        decoration: FormFieldUtils.getInputDecoration(formFieldContext, context),
        maxFiles: formFieldContext.options?.fieldSpecificOptions?.allowMultipleFiles == true ? null : 1,
        allowedExtensions: _getFileExtensions(),
      ),
    );
  }

  List<String>? _getFileExtensions() {
    if (formFieldContext.options?.fieldSpecificOptions?.acceptedFileType != null) {
      String acceptedFileType = formFieldContext.options!.fieldSpecificOptions!.acceptedFileType!;
      List<String> fileTypes = acceptedFileType.split(', ');
      if (fileTypes.contains("*")) {
        return null;
      } else {
        return fileTypes;
      }
    }
    return null;
  }
}
