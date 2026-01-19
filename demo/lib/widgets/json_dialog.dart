import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';
import 'package:flutter_json_forms_demo/main.dart';

void showJsonDialog(BuildContext context, String title, Map<String, dynamic>? jsonData) async {
  final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final highlighter = isDark ? jsonDarkHighlighter : jsonLightHighlighter;

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: SelectableText.rich(
              highlighter.highlight(jsonString),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
