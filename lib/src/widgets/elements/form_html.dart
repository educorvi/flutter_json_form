import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import '../../models/ui_schema.g.dart' as ui;

class FormHtml extends StatelessWidget {
  final ui.HtmlRenderer htmlRenderer;

  const FormHtml({
    super.key,
    required this.htmlRenderer,
  });

  @override
  Widget build(BuildContext context) {
    return RendererScope.of(context).buildUiHtml(context, UiHtmlContext(htmlRenderer));
  }
}
