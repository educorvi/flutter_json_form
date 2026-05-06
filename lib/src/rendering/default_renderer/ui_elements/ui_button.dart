import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/helpers/button_helpers.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';

/// Renders a styled button for [button].
///
/// Press-callback resolution is delegated to [ButtonHelpers.resolveOnPressed]
/// and colour/outline style is resolved via [ButtonHelpers.resolveButtonStyle].
/// Both are pure-logic helpers; only the final widget construction lives here.
Widget buildDefaultButton(BuildContext context, UiButtonContext button) {
  final onPressed = ButtonHelpers.resolveOnPressed(context, button);
  final style = ButtonHelpers.resolveButtonStyle(
    button.button.options?.variant,
    Theme.of(context).colorScheme,
  );

  if (style.isOutline) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: style.color,
        side: BorderSide(color: style.color),
      ),
      onPressed: onPressed,
      child: Text(button.button.text),
    );
  }
  return FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: style.color,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
    onPressed: onPressed,
    child: Text(button.button.text),
  );
}
