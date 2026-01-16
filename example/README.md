# Flutter Json Forms Example

The following sample are provided to render forms based on JSON schema using the `flutter_json_forms` package.

## Simple Example Usage

A minimal working example of the package can be found below:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
      ),
    );
  }
}
```

## More complex demo forms

The demo app included in this repository demonstrates how to render more complex forms using various JSON schema features. The source files can be viewed and edited in the demo but you can also have a look at [demo/assets/example-schemas](./demo/assets/example-schemas) to directly access the json assets used to render the forms.

## Other Form Render Features

