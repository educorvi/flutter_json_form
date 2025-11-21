import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'json_dialog.dart';

/// Card widget for schema input with collapse/expand functionality
class SchemaInputCard extends StatelessWidget {
  final bool isCollapsed;
  final bool isFormReady;
  final VoidCallback onToggleCollapse;
  final Widget inputContent;
  final Map<String, dynamic>? jsonSchema;
  final Map<String, dynamic>? uiSchema;

  const SchemaInputCard({
    super.key,
    required this.isCollapsed,
    required this.isFormReady,
    required this.onToggleCollapse,
    required this.inputContent,
    this.jsonSchema,
    this.uiSchema,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: TabBar(
                  tabs: [
                    Tab(text: 'Text Input'),
                    Tab(text: 'File Upload'),
                  ],
                ),
              ),
              if (isFormReady)
                IconButton(
                  icon: Icon(isCollapsed ? Icons.expand_more : Icons.expand_less),
                  onPressed: onToggleCollapse,
                  tooltip: isCollapsed ? 'Expand' : 'Collapse',
                ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isCollapsed
                ? const SizedBox.shrink()
                : Padding(
                    padding: LayoutConstants.paddingAll,
                    child: inputContent,
                  ),
          ),
          if (isFormReady)
            Padding(
              padding: LayoutConstants.paddingButtonBar,
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => showJsonDialog(context, 'JSON Schema', jsonSchema),
                      child: const Text('Show JSON Schema'),
                    ),
                  ),
                  const SizedBox(width: LayoutConstants.spacingM),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => showJsonDialog(context, 'UI Schema', uiSchema),
                      child: const Text('Show UI Schema'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
