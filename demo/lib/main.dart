import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
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
  // late final formSelectorKey = GlobalKey<FormSelectorState>();

  @override
  void initState() {
    super.initState();
    // formSelector = FormSelector(onFormSelected: (formFile) {
    //   setState(() {
    //     selectedFormFile = formFile;
    //   });
    // },);
  }

  FormFile? selectedFormFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Json Forms Demo"),
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(8),
        children: [
          // Text(
          //   'Showcase Form',
          //   style: Theme.of(context).textTheme.headlineLarge,
          // ),
          // const SizedBox(height: 16),
          // Text(
          //   'This form showcases the capabilities of the Flutter JSON Forms package. ',
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          // FormSelector(),
          FormSelector(
            // key: formSelectorKey,
            // onFormSelected: (formFile) {
            //   setState(() {
            //     selectedFormFile = formFile;
            //   });
            // },
          ),
          // const SizedBox(height: 16),
          // SafeArea(
          //   child: selectedFormFile != null ? selectedFormFile!.getForm() : const SizedBox(),
          // )
        ],
      ),
    );
  }
}
