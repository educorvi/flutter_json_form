import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Minimal valid JSON schema for testing
    final jsonSchema = {
      "type": "object",
      "properties": {
        "name": {"type": "string", "title": "Name"}
      },
      "required": ["name"]
    };

    return MaterialApp(
      title: 'FlutterJsonForm Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('FlutterJsonForm Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FlutterJsonForm(
            jsonSchema: jsonSchema,
            validate: true,
          ),
        ),
      ),
    );
  }
}
