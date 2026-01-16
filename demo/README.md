# Flutter Json Forms Demo

This folder contains the code for the demo application of the project. The web version of the demo can be accessed at [https://educorvi.github.io/flutter_json_form/](https://educorvi.github.io/flutter_json_form/).

## Functionality

In the `Example` section, the demo displays a selection of forms varying from simple basic functionality to forms showcasing advanced features of the package. In the `Custom Form` section, own json and ui schemas can be provided to see how the package renders them. The `Settings` section allows toggling theming like dark mode and the design system used.

## Running the Demo

To run the demo application locally, follow these steps:

Ensure you have Flutter installed on your machine. If not, follow the instructions at [flutter.dev](https://flutter.dev/docs/get-started/install). Navigate to the `demo` directory in your terminal. Run the following command to get the required dependencies:
```bash
flutter pub get
```

To run the application on a connected device or emulator, use the command:

```bash
flutter run
```

## Tests

The integration tests of the package are located within the [integration_test](./integration_test) folder within this demo application. To run the integration tests, use the following command:

```bash
flutter test integration_test
```
