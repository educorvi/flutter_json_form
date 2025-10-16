import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';

class AnimatedTooltip extends StatelessWidget {
  final String content;
  final String label;

  const AnimatedTooltip({
    super.key,
    required this.content,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: content,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(content)),
          );
        },
        child: CircleAvatar(
          radius: 14,
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: FormFieldText(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
