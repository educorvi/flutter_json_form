import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';

/// Widget for file-based schema upload
class FileSchemaUpload extends StatelessWidget {
  final File? jsonSchemaFile;
  final File? uiSchemaFile;
  final VoidCallback onPickJsonSchema;
  final VoidCallback onPickUiSchema;
  final VoidCallback onLoadFiles;

  const FileSchemaUpload({
    super.key,
    required this.jsonSchemaFile,
    required this.uiSchemaFile,
    required this.onPickJsonSchema,
    required this.onPickUiSchema,
    required this.onLoadFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.tonal(
          onPressed: onPickJsonSchema,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('JSON Schema File'),
              const SizedBox(width: LayoutConstants.spacingS),
              if (jsonSchemaFile != null) const Icon(Icons.check, color: Colors.green) else const Icon(Icons.upload),
            ],
          ),
        ),
        if (jsonSchemaFile != null)
          Padding(
            padding: const EdgeInsets.only(top: LayoutConstants.spacingS),
            child: Text(
              jsonSchemaFile!.path.split('/').last,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        LayoutConstants.gapM,
        FilledButton.tonal(
          onPressed: onPickUiSchema,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('UI Schema File'),
              const SizedBox(width: LayoutConstants.spacingS),
              if (uiSchemaFile != null) const Icon(Icons.check, color: Colors.green) else const Icon(Icons.upload),
            ],
          ),
        ),
        if (uiSchemaFile != null)
          Padding(
            padding: const EdgeInsets.only(top: LayoutConstants.spacingS),
            child: Text(
              uiSchemaFile!.path.split('/').last,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        LayoutConstants.gapM,
        FilledButton(
          onPressed: onLoadFiles,
          child: const Text('Load Files'),
        ),
      ],
    );
  }
}
