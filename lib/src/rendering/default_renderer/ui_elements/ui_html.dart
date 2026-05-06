import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders the HTML content from [html] using [CustomHtmlWidget].
Widget buildDefaultHtml(BuildContext context, UiHtmlContext html) {
  return HtmlWidget(
    enableCaching: true,
    html.htmlData,
    onTapUrl: (url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        // print('Could not launch $url');
      }
      return true;
    },
    renderMode: const ListViewMode(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    ),
  );
}
