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
    return SizedBox(
      width: double.infinity,
      child: Tooltip(
        message: context.localize((l) => l.buttonAdd),
        child: FilledButton.tonal(
          key: testKey,
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(48, 48), // or Size.square(40)
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
