import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';

/// Helper widget to render an element with an optional label
Widget withHeader(BuildContext context, String? label, String? description, Widget child) {
  if (label == null && description == null) {
    return child;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null) ...[
        FormFieldText(
          label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (description != null) const SizedBox(height: UIConstants.objectTitlePadding / 2),
      ],
      if (description != null)
        FormFieldText(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      const SizedBox(height: UIConstants.objectTitlePadding),
      child,
    ],
  );
}
