import 'package:flutter/material.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../custom_form_fields/html_widget.dart';

class FormHtml extends StatelessWidget {
  final ui.HtmlRenderer htmlRenderer;

  const FormHtml({
    super.key,
    required this.htmlRenderer,
  });

  @override
  Widget build(BuildContext context) {
    return CustomHtmlWidget(
      htmlData: htmlRenderer.htmlData,
    );
  }
}
