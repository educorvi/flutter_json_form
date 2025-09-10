import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showJsonDialog(BuildContext context, String title, Map<String, dynamic>? jsonData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            const JsonEncoder.withIndent('  ').convert(jsonData),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Copy'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: const JsonEncoder.withIndent('  ').convert(jsonData)));
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
