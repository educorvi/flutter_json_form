import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';

/// Widget for text-based schema input
class TextSchemaInput extends StatelessWidget {
  final TextEditingController jsonSchemaController;
  final TextEditingController uiSchemaController;
  final VoidCallback onLoadSchemas;

  const TextSchemaInput({
    super.key,
    required this.jsonSchemaController,
    required this.uiSchemaController,
    required this.onLoadSchemas,
  });

  final minLines = 3;
  final maxLines = 8;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: jsonSchemaController,
          decoration: const InputDecoration(
            labelText: 'JSON Schema',
            hintText: 'Paste your JSON schema here',
            border: OutlineInputBorder(),
          ),
          maxLines: maxLines,
          minLines: minLines,
        ),
        LayoutConstants.gapM,
        TextField(
          controller: uiSchemaController,
          decoration: const InputDecoration(
            labelText: 'UI Schema (Optional)',
            hintText: 'Paste your UI schema here',
            border: OutlineInputBorder(),
          ),
          maxLines: maxLines,
          minLines: minLines,
        ),
        LayoutConstants.gapM,
        FilledButton(
          onPressed: onLoadSchemas,
          child: const Text('Load Schemas'),
        ),
      ],
    );
  }
}
