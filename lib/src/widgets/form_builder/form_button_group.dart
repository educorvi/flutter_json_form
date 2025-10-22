import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button.dart';
import '../../models/ui_schema.g.dart' as ui;

class FormButtonGroup extends StatelessWidget {
  final ui.Buttongroup buttonGroup;

  const FormButtonGroup({
    super.key,
    required this.buttonGroup,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonGroup.options?.vertical != null && buttonGroup.options!.vertical!) {
      return Column(
        children: buttonGroup.buttons.map((item) {
          return FormButton(button: item);
        }).toList(),
      );
    } else {
      return Wrap(
        spacing: UIConstants.horizontalElementSpacing,
        runSpacing: UIConstants.verticalElementSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: buttonGroup.buttons.map((item) {
          return FormButton(button: item);
        }).toList(),
      );
    }
  }
}
