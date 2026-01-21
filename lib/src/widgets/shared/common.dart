import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';

Container getLineContainer({Widget? child}) {
  return Container(
    padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
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
Widget withHeader(BuildContext context, String? label, String? description, Widget? child, {bool? required = false}) {
  if (label == null && description == null && child != null) {
    return child;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null) ...[
        FormFieldText(
          label,
          style: Theme.of(context).textTheme.titleLarge,
          required: required,
        ),
        if (description != null) const SizedBox(height: UIConstants.objectTitlePadding / 2),
      ],
      if (description != null)
        FormFieldText(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      if (child != null) child,
    ],
  );
}

Widget withPrimitiveFieldTitle(BuildContext context, String? title, Widget? child, {bool? required = false}) {
  if (title == null && child != null) {
    return child;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null) ...[
        FormFieldText(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
          required: required,
        ),
      ],
      if (child != null) child,
    ],
  );
}

/// translates simple css styles to flutter widget styling
Widget withCss(BuildContext context, Widget child, {String? cssClass}) {
  if (cssClass != null) {
    if (cssClass.contains("bg-light greyBackground")) {
      return Card.filled(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Padding(padding: const EdgeInsets.all(UIConstants.groupIndentation), child: child),
      );
    }
  }
  return child;
}

Color colorForVariant(ui.BaseVariants? variant, BuildContext context) {
  switch (variant) {
    case ui.BaseVariants.DANGER:
      return Colors.red;
    case ui.BaseVariants.DARK:
      return Colors.grey.shade800;
    case ui.BaseVariants.INFO:
      return Colors.blue;
    case ui.BaseVariants.LIGHT:
      return Colors.grey.shade400;
    case ui.BaseVariants.PRIMARY:
      return Theme.of(context).colorScheme.primary;
    case ui.BaseVariants.SECONDARY:
      return Theme.of(context).colorScheme.secondary;
    case ui.BaseVariants.SUCCESS:
      return Colors.green;
    case ui.BaseVariants.WARNING:
      return Colors.orange;
    default:
      return Theme.of(context).colorScheme.primary;
  }
}
