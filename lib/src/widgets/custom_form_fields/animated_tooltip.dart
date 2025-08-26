import 'package:flutter/material.dart';

class AnimatedTooltip extends StatelessWidget {
  final String content;
  final String label;

  const AnimatedTooltip({
    Key? key,
    required this.content,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: content,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Optionally, you can show a dialog or snackbar as a fallback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(content)),
          );
        },
        child: CircleAvatar(
          radius: 14,
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
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
