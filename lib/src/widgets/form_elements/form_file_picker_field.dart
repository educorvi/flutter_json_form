import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_wrapper.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
        validator: _composeValidator(),
        decoration: _getInputDecoration(context),
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

  FormFieldValidator<dynamic> _composeValidator() {
    return (valueCandidate) {
      if (!formFieldContext.isShownCallback()) {
        return null;
      }

      if (formFieldContext.required) {
        final validatorResult = FormBuilderValidators.required().call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }

      return null;
    };
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    return InputDecoration(
      labelText: formFieldContext.showLabel ? _getLabel() : null,
      hintText: formFieldContext.placeholder,
      border: Theme.of(context).inputDecorationTheme.border,
      helperText: formFieldContext.description,
      helperMaxLines: 10,
      prefixText: formFieldContext.options?.formattingOptions?.prepend,
      suffixText: formFieldContext.options?.formattingOptions?.append,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  String? _getLabel() {
    String? getScope() {
      final lastScopeElement = formFieldContext.scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = formFieldContext.title ?? getScope();
    return formFieldContext.required && titleString != null ? ('${titleString}*') : titleString;
  }
}
