import 'package:flutter/material.dart';
import 'package:flutter_json_forms/l10n/form_fallback_localizations.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';

class FormArrayAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Key? testKey;
  final String? label;

  const FormArrayAddButton({
    super.key,
    required this.onPressed,
    this.testKey,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (label != null) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: UIConstants.horizontalElementSpacing),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            SizedBox(width: UIConstants.horizontalElementSpacing),
            Text(label!),
          ],
        ),
      );
    } else {
      content = Icon(Icons.add);
    }
    return SizedBox(
      width: double.infinity,
      child: Tooltip(
        message: label ?? context.localize((l) => l.buttonAdd),
        child: FilledButton.tonal(
          key: testKey,
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(48, 48), // or Size.square(40)
            padding: EdgeInsets.zero,
          ),
          child: content,
        ),
      ),
    );
  }
}
