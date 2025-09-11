import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';
import 'package:flutter_json_forms_demo/widgets/form_selector.dart';

void main() {
  runApp(const MyApp());
  // setupDynamicJsonFormValidation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [FormBuilderLocalizations.delegate],
      title: 'Flutter Json Forms Demo',
      theme: appConstants.theme.getThemeData(Brightness.light),
      darkTheme: appConstants.theme.getThemeData(Brightness.dark),
      home: const FlutterFormDemo(),
    );
  }
}

class FlutterFormDemo extends StatefulWidget {
  const FlutterFormDemo({super.key});

  @override
  State<FlutterFormDemo> createState() => _FlutterFormDemoState();
}

class _FlutterFormDemoState extends State<FlutterFormDemo> {
  late final FormSelector formSelector;

  @override
  void initState() {
    super.initState();
  }

  FormFile? selectedFormFile;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Flutter Json Forms Demo"),
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(8),
          children: [
            Center(
                child: SizedBox(
                    width: 1000, child: SelectionArea(child: FormSelector()))),
          ],
        ),
      ),
    );
  }
}
