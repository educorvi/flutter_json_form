import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import '../../models/ui_schema.g.dart' as ui;

class FormButton extends StatelessWidget {
  final ui.Button button;

  const FormButton({
    super.key,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return RendererScope.of(context).buildUiButton(context, UiButtonContext(button));
  }
}
