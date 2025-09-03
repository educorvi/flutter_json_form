import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/constants.dart';

/// translates simple css styles to flutter widget styling
Widget applyCss(BuildContext context, Widget child, {String? cssClass}) {
  if (cssClass != null) {
    if (cssClass.contains("bg-light greyBackground")) {
      return Card.filled(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Padding(padding: const EdgeInsets.all(UIConstants.groupPadding), child: child),
      );
    }
  }
  return child;
}
