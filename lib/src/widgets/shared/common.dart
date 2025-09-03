import 'package:flutter/material.dart';

Container getLineContainer({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    child: child,
  );
}

/// Helper widget to render an element with an optional label
Widget withLabel(BuildContext context, String? label, Widget child) {
  if (label == null) return child;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}
