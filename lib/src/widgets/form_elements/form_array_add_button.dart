import 'package:flutter/material.dart';
import 'package:flutter_json_forms/l10n/form_fallback_localizations.dart';

class FormArrayAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Key? testKey;

  const FormArrayAddButton({
    super.key,
    required this.onPressed,
    this.testKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      width: double.infinity,
      child: Tooltip(
        message: context.localize((l) => l.buttonAdd),
        child: FilledButton.tonal(
          key: testKey,
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}
