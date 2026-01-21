import 'package:flutter/material.dart';

class FormArrayReorderButton extends StatelessWidget {
  final ThemeData theme;
  final double gap;
  final int index;
  final String label;
  final bool canReorder;

  const FormArrayReorderButton({
    super.key,
    required this.theme,
    required this.gap,
    required this.index,
    required this.label,
    required this.canReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: gap),
      child: Tooltip(
        message: label,
        child: ReorderableDragStartListener(
          index: index,
          child: FilledButton.tonal(
            onPressed: canReorder ? () {} : null,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.drag_indicator_rounded),
          ),
        ),
      ),
    );
  }
}
