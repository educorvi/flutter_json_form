import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:flutter_json_forms_demo/main.dart';

/// Widget for text-based schema input

class TextSchemaInput extends StatefulWidget {
  final TextEditingController jsonSchemaController;
  final TextEditingController uiSchemaController;
  final VoidCallback onLoadSchemas;

  const TextSchemaInput({
    super.key,
    required this.jsonSchemaController,
    required this.uiSchemaController,
    required this.onLoadSchemas,
  });

  @override
  State<TextSchemaInput> createState() => _TextSchemaInputState();
}

class _TextSchemaInputState extends State<TextSchemaInput> {
  late CodeEditorController _jsonController;
  late CodeEditorController _uiController;

  @override
  void initState() {
    super.initState();
    _jsonController = CodeEditorController(
      text: widget.jsonSchemaController.text,
      lightHighlighter: jsonLightHighlighter,
      darkHighlighter: jsonDarkHighlighter,
    );
    _uiController = CodeEditorController(
      text: widget.uiSchemaController.text,
      lightHighlighter: jsonLightHighlighter,
      darkHighlighter: jsonDarkHighlighter,
    );
    _jsonController.addListener(() {
      widget.jsonSchemaController.text = _jsonController.text;
    });
    _uiController.addListener(() {
      widget.uiSchemaController.text = _uiController.text;
    });
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'JSON Schema',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              SizedBox(
                height: 200,
                child: CodeEditor(
                  controller: _jsonController,
                  textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        LayoutConstants.gapM,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'UI Schema (Optional)',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              SizedBox(
                height: 200,
                child: CodeEditor(
                  controller: _uiController,
                  textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        LayoutConstants.gapM,
        FilledButton(
          onPressed: widget.onLoadSchemas,
          child: const Text('Load Schemas'),
        ),
      ],
    );
  }
}
