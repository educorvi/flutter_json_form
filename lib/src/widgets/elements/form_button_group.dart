import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import '../../models/ui_schema.g.dart' as ui;

class FormButtonGroup extends StatelessWidget {
  final ui.Buttongroup buttonGroup;

  const FormButtonGroup({
    super.key,
    required this.buttonGroup,
  });

  @override
  Widget build(BuildContext context) {
    return RendererScope.of(context).buildUiButtonGroup(context, UiButtonGroupContext(buttonGroup));
  }
}
