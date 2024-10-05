import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_json_forms/flutter_json_forms.dart';

void main() {
  runApp(const MyApp());
  setupDynamicJsonForm();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Json Forms Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? jsonSchema;
  Map<String, dynamic>? uiSchema;
  final GlobalKey<DynamicJsonFormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadSchemas();
  }

  Future<void> loadSchemas() async {
    final jsonSchemaString = await rootBundle.loadString('../lib/src/schemas/examples/showcase/schema.json');
    final uiSchemaString = await rootBundle.loadString('../lib/src/schemas/examples/showcase/ui.json');

    setState(() {
      jsonSchema = json.decode(jsonSchemaString);
      uiSchema = json.decode(uiSchemaString);
    });
  }

  void showJsonDialog(String title, Map<String, dynamic>? jsonData) {
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

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> formData = {
      "name": "John Doe",
      "title": "Mr.",
      "group_selector": "Object",
      // "testArray": [
      //   "Test 1",
      //   "Test 2",
      // ],
      "testObject": {
        "petName": "1",
        "age": "2",
        "flauschig": true,
      },
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Json Forms Demo"),
      ),
      body: jsonSchema == null || uiSchema == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Showcase Form',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'This form showcases the capabilities of the Flutter JSON Forms package. ',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.tonal(
                onPressed: () => showJsonDialog('JSON Schema', jsonSchema),
                child: const Text('Show JSON Schema'),
              ),
              FilledButton.tonal(
                onPressed: () => showJsonDialog('UI Schema', uiSchema),
                child: const Text('Show UI Schema'),
              ),
            ],
          ),
          Divider(),
          DynamicJsonForm(
            key: formKey,
            validate: false,
            jsonSchema: jsonSchema,
            uiSchema: uiSchema,
            formData: formData,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                onPressed: () {
                  if(formKey.currentState!.saveAndValidate()) {
                    final formData = formKey.currentState!.value;
                    showJsonDialog('Form Data', formData);
                  }
                },
                child: const Text('Show Form Data'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  formKey.currentState?.reset();
                },
                child: const Text('Reset Form'),
              ),
            ],
          )
        ],
      ),
    );
  }
}