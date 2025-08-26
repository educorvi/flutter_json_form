import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CustomHtmlWidget extends StatelessWidget {
  final String htmlData;

  const CustomHtmlWidget({
    Key? key,
    required this.htmlData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      enableCaching: true,
      htmlData,
      onTapUrl: (url) async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          print('Could not launch $url');
        }
        return true;
      },
      renderMode: const ListViewMode(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}
