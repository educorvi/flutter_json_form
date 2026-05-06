import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import '../../models/ui_schema.g.dart' as ui;

class FormDivider extends StatelessWidget {
  final ui.Divider divider;

  const FormDivider({
    super.key,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return RendererScope.of(context).buildUiDivider(context, UiDividerContext(divider));
  }
}
