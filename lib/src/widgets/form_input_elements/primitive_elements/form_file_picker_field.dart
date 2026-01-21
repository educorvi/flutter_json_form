import 'package:flutter/material.dart';
import 'package:flutter_json_forms/l10n/form_fallback_localizations.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:json_schema/json_schema.dart';

class FormFilePickerField extends StatelessWidget {
  final FormFieldContext formFieldContext;

  const FormFilePickerField({
    super.key,
    required this.formFieldContext,
  });

  @override
  Widget build(BuildContext context) {
    int? maxFiles = 1;
    int? minFiles;
    bool allowMultiple = false;
    if (formFieldContext.options?.fileUploadOptions?.displayAsSingleUploadField == true && formFieldContext.jsonSchema.type == SchemaType.array) {
      allowMultiple = true;
      if (formFieldContext.jsonSchema.maxItems != null) {
        maxFiles = formFieldContext.jsonSchema.maxItems;
      }
      if (formFieldContext.jsonSchema.minItems != null) {
        minFiles = formFieldContext.jsonSchema.minItems;
      }
    }

    return FormBuilderFilePicker(
      name: formFieldContext.id,
      onChanged: formFieldContext.onChanged,
      onSaved: (value, {computedSelfIndices}) {
        // Intercept and convert array to string if not displayAsSingleUploadField
        if (formFieldContext.options?.fileUploadOptions?.displayAsSingleUploadField != true && value is List && value?.isNotEmpty == true) {
          // Example: use first file name, or join all names
          // final fileNames = value?.map((f) => f.name).join(', ');
          formFieldContext.onSavedCallback?.call(value?[0], computedSelfIndices: computedSelfIndices);
        } else {
          formFieldContext.onSavedCallback?.call(value, computedSelfIndices: computedSelfIndices);
        }
      },
      enabled: formFieldContext.enabled,
      decoration: FormFieldUtils.getInputDecoration(formFieldContext, context),
      maxFiles: maxFiles,
      allowMultiple: allowMultiple,
      // maxFiles: formFieldContext.options?.fileUploadOptions?.allowMultipleFiles == true ? null : 1, // TODO: breaking change
      allowedExtensions: _getFileExtensions(),
      validator: (files) {
        // Base validator (required, etc)
        final baseError = FormFieldUtils.createBaseValidator(formFieldContext)(files);
        if (baseError != null) return baseError;
        if (formFieldContext.options?.fileUploadOptions?.maxFileSize != null && files != null) {
          final maxFileSizeInBytes = formFieldContext.options!.fileUploadOptions!.maxFileSize!;
          for (var file in files) {
            if (file.size > maxFileSizeInBytes) {
              final maxFileSizeString = formatFileSize(formFieldContext.options!.fileUploadOptions!.maxFileSize!, context);
              return context.localize((l) => l.validateMaxFileSize(maxFileSizeString));
            }
          }
        }
        if (minFiles != null && (files == null || files.length < minFiles)) {
          return context.localize((l) => l.validateMinItems(minFiles!));
        }
        return null;
      },
    );
  }

  List<String>? _getFileExtensions() {
    if (formFieldContext.options?.fileUploadOptions?.acceptedFileType != null) {
      String acceptedFileType = formFieldContext.options!.fileUploadOptions!.acceptedFileType!;
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

String formatFileSize(double bytes, BuildContext context) {
  final kb = 1024;
  final mb = kb * 1024;
  final gb = mb * 1024;

  if (bytes >= gb) {
    return '${(bytes / gb).toStringAsFixed(2)} GB';
  } else if (bytes >= mb) {
    return '${(bytes / mb).toStringAsFixed(2)} MB';
  } else if (bytes >= kb) {
    return '${(bytes / kb).toStringAsFixed(2)} KB';
  } else {
    return '$bytes B';
  }
}
