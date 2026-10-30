import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_button.dart';

/// Builds each [ui.Button] as a [FormButton] widget and arranges them in a
/// [Wrap] (horizontal) or [Column] (vertical) depending on [buttonGroup.options?.vertical].
Widget buildDefaultButtonGroup(
  BuildContext context,
  UiButtonGroupContext buttonGroup,
  double horizontalSpacing,
  double verticalSpacing,
) {
  final buttons = buttonGroup.buttonGroup.buttons.map((b) => FormButton(button: b)).toList();
  if (buttonGroup.buttonGroup.options?.vertical == true) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: buttons);
  }
  return Wrap(
    spacing: horizontalSpacing,
    runSpacing: verticalSpacing,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: buttons,
  );
}
