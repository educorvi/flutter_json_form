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

A form renderer which automatically creates highly customizable forms based on json input. An Json schema as of [Draft-07](https://json-schema.org/draft-07) has to be provided for the structure of the form and an optional [Ui Schema](https://educorvi.github.io/vue-json-form/ui-schema/) can be set to customize the appearance of the form. This allows defining dynamic dependencies like the visibility of fields depending on the value of other fields.

A [Demo](https://educorvi.github.io/flutter_json_form/) of the renderer exists to play around with the functionality and debug own schemas.

## Features

### Overview

- Automatically create rich forms based on json schema ([Draft-07](https://json-schema.org/draft-07))
- Customize the visual appearance and dynamic dependencies between form elements with an optional [Ui Schema](https://educorvi.github.io/vue-json-form/ui-schema/)
- automatically handle form validation
- resulting form data is represented in json based on json schema as well

TODO: images

### Theming

- Image with default theme of form, then image with heavily customized theming

### Dynamic dependencies

- Simple dependency
- dependency with multiple fields
- within objects
- within array elements

## Getting started

To use the form renderer you need a valid json schema as of ([Draft-07](https://json-schema.org/draft-07)) to define the form. The [Ui Schema](https://educorvi.github.io/vue-json-form/ui-schema/) is optional and gets generated automatically if not provided but to further customize the form and define dynamic dependencies between fields, you have to generate your own Ui Schema.

To use the package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_json_form: ^0.0.1
```

Then, run `flutter pub get` to install the package.

### Usage

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
  final GlobalKey<FlutterJsonFormState> formKey;

  FlutterJsonFormsDemo({super.key}):
        formKey = GlobalKey<FlutterJsonFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterJsonForm(
        key: formKey,
        jsonSchema: {...},
        uiSchema: {...},
        validate: false,
        formData: {...},
      ),
    );
  }

```

Example values for the `jsonSchema`, `uiSchema` and `formData` can be seen here:

<details>
  <summary>Register Form</summary>

```dart
  jsonSchema = {
      "name": "registration",
      "title": "Registration",
      "type": "object",
      "description": "A simple registration form example",
      "$schema": "http://json-schema.org/draft-07/schema#",
      "properties": {
          "firstName": {
              "type": "string",
              "title": "First Name"
          },
          "lastName": {
              "type": "string",
              "title": "Last Name"
          },
          "newsletter": {
              "type": "boolean",
              "default": true,
              "title": "Sign up for newsletter"
          },
          "email": {
              "type": "string",
              "title": "Email",
              "format": "email"
          }
      },
      "required": [
          "firstName",
          "lastName"
      ]
  };

  uiSchema = {
      "version": "2.0",
      "$schema": "https://educorvi.github.io/vue-json-form/schemas/ui.schema.json",
      "layout": {
          "type": "Group",
          "options": {
              "label": "Registration"
          },
          "elements": [
              {
                  "type": "HorizontalLayout",
                  "elements": [
                      {
                          "type": "Control",
                          "scope": "#/properties/firstName",
                          "options": {
                              "placeholder": "First Name"
                          }
                      },
                      {
                          "type": "Control",
                          "scope": "#/properties/lastName",
                          "options": {
                              "placeholder": "Last Name"
                          }
                      }
                  ]
              },
              {
                  "type": "Control",
                  "scope": "#/properties/newsletter",
                  "options": {
                      "label": "Sign up for newsletter"
                  }
              },
              {
                  "type": "Control",
                  "scope": "#/properties/email",
                  "showOn": {
                      "path": "#/properties/newsletter",
                      "type": "EQUALS",
                      "referenceValue": true
                  },
                  "options": {
                      "placeholder": "Email address",
                      "format": "email"
                  }
              },
              {
                  "type": "Button",
                  "buttonType": "submit",
                  "text": "Sign Up",
                  "options": {
                      "variant": "primary"
                  }
              }
          ]
      }
  };

  formData = {
      "firstName": "John",
  };

```

</details>

The formData can be set to prefill the form with existing data. If not provided, the form will be empty (except default values are set in the json schema). For more extensive examples, check the [example](./exampe) directory or the [demo application](TODO).

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## Development

In order to develop the package, you need to have [Flutter](https://flutter.dev/) installed on your machine. You can check if you have it installed by running `flutter doctor` in your terminal.

The next step is to clone the repository to your local machine. Afterwards, open the project and run `flutter pub get` to install the dependencies.

Afterwards, cd into the demo folder and run `flutter run` to start the demo application and play around with the form renderer.

It is recommended to use an IDE like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) for development and install the corresponding Flutter and Dart plugins.

An Devcontainer configuration will be provided in the future to make it easier to get started with development.

## Future features

- appearance of form renderer elements like arrays objects and single elements can be easily themed by providing a custom Theme object
- logic of the renderer can be further customized by providing callback functions


## TODO

- Accessibility Section
- Customization: completely provide own widgets for the elements