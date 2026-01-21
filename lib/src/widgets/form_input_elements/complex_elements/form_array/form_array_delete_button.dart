import 'package:flutter/material.dart';

class FormArrayDeleteButton extends StatelessWidget {
  final ThemeData theme;
  final int index;
  final bool canRemove;
  final double gap;
  final int itemId;
  final String tooltip;
  final void Function(int index) onRemove;

  const FormArrayDeleteButton({
    super.key,
    required this.theme,
    required this.index,
    required this.canRemove,
    required this.gap,
    required this.itemId,
    required this.tooltip,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: gap),
      child: Tooltip(
        message: tooltip,
        child: FilledButton.tonal(
          onPressed: canRemove ? () => onRemove(index) : null,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
