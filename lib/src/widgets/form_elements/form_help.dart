import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/shared/common.dart';

/// Renders a help button that shows a tooltip with help text when tapped or hovered.
/// Pass a [ControlFormattingOptionsHelp] as input.
class FormHelp extends StatefulWidget {
  final ui.ControlFormattingOptionsHelp help;

  const FormHelp({super.key, required this.help});

  @override
  State<FormHelp> createState() => _FormHelpState();
}

class _FormHelpState extends State<FormHelp> {
  final GlobalKey _tooltipKey = GlobalKey();

  void _showTooltip() {
    final dynamic tooltip = _tooltipKey.currentState;
    tooltip?.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _tooltipKey,
      message: widget.help.text,
      preferBelow: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        height: 32,
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            minimumSize: const Size(24, 24),
            //padding: EdgeInsets.zero,
          ),
          onPressed: _showTooltip,
          child: Text(
            widget.help.label ?? '?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorForVariant(widget.help.variant, context),
            ),
          ),
        ),
      ),
    );
  }
}
