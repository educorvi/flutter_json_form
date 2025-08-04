<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Flutter Json Form

A form renderer which automatically creates highly customizable forms based on json input.

This packages generates forms based on a [json schema](https://json-schema.org) and an option ui schema.

[Demo](TODO)

## Features

- Automatically create forms based on json schema
- customize the visual appearance and dynamic dependencies between form elements with the ui schema
- easily get the resulting json of the form
- handles validation

TODO: images

## Getting started

To use the form renderer you need a valid json Schema to define the form. The uiSchema is optional and gets generated automatically but to further customize the form and define dynamic dependencies between fields, you have to generate you own uiSchema.

To use the package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_json_form: ^0.0.1
```

Then, run `flutter pub get` to install the package.

## Usage

The form renderer can be used like this:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_json_form/flutter_json_form.dart';

void main() {
  runApp(
    FlutterJsonFormsDemo()
  );
}

class FlutterJsonFormsDemo extends extends StatelessWidget {
  final GlobalKey<DynamicJsonFormState> formKey;

  FlutterJsonFormsDemo({super.key}):
        formKey = GlobalKey<DynamicJsonFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicJsonForm(
        key: formKey,
        jsonSchema: {...},
        uiSchema: {...},
        validate: false,
        formData: {...},
      ),
    );
  }
}
```

Keep in mind to provide a valid jsonSchema and optionally a uiSchema and formData.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## Development

In order to develop the package, you need to have [Flutter](https://flutter.dev/) installed on your machine. You can check if you have it installed by running `flutter doctor` in your terminal.

The next step is to clone the repository to your local machine. Afterwards, open the project and run `flutter pub get` to install the dependencies. 