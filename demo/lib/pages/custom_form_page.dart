import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import '../constants/constants.dart';
import '../widgets/file_schema_upload.dart';
import '../widgets/json_dialog.dart';
import '../widgets/schema_input_card.dart';
import '../widgets/text_schema_input.dart';

class CustomFormPage extends StatefulWidget {
  const CustomFormPage({super.key});

  @override
  State<CustomFormPage> createState() => _CustomFormPageState();
}

class _CustomFormPageState extends State<CustomFormPage> {
  final _formKey = GlobalKey<FlutterJsonFormState>();

  // Text input mode
  final _jsonSchemaController = TextEditingController();
  final _uiSchemaController = TextEditingController();

  // File upload mode
  File? _fileJsonSchema;
  File? _fileUiSchema;

  // Form state
  Map<String, dynamic>? _jsonSchema;
  Map<String, dynamic>? _uiSchema;
  bool _formReady = false;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _jsonSchemaController.dispose();
    _uiSchemaController.dispose();
    super.dispose();
  }

  void _loadTextSchemas() {
    try {
      final jsonSchema = json.decode(_jsonSchemaController.text);
      final uiSchema = _uiSchemaController.text.isEmpty ? null : json.decode(_uiSchemaController.text);

      setState(() {
        _jsonSchema = jsonSchema;
        _uiSchema = uiSchema;
        _formReady = true;
        _isCollapsed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schemas loaded successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing JSON: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _loadFileSchemas() async {
    if (_fileJsonSchema == null || _fileUiSchema == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both schema files'), backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      final jsonSchemaString = await _fileJsonSchema!.readAsString();
      final uiSchemaString = await _fileUiSchema!.readAsString();

      final jsonSchema = json.decode(jsonSchemaString);
      final uiSchema = json.decode(uiSchemaString);

      if (!mounted) return;

      setState(() {
        _jsonSchema = jsonSchema;
        _uiSchema = uiSchema;
        _formReady = true;
        _isCollapsed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Files loaded successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading files: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickJsonSchemaFile() async {
    final result = await FilePicker.platform.pickFiles(allowedExtensions: ['json'], type: FileType.custom);
    if (result != null) {
      setState(() {
        _fileJsonSchema = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickUiSchemaFile() async {
    final result = await FilePicker.platform.pickFiles(allowedExtensions: ['json'], type: FileType.custom);
    if (result != null) {
      setState(() {
        _fileUiSchema = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: LayoutConstants.paddingAllS,
      children: [
        Center(
          child: SizedBox(
            width: LayoutConstants.maxPageWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Form',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                LayoutConstants.gapM,
                DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SchemaInputCard(
                        isCollapsed: _isCollapsed,
                        isFormReady: _formReady,
                        onToggleCollapse: () {
                          setState(() {
                            _isCollapsed = !_isCollapsed;
                          });
                        },
                        jsonSchema: _jsonSchema,
                        uiSchema: _uiSchema,
                        inputContent: Builder(
                          builder: (context) {
                            final tabController = DefaultTabController.of(context);
                            return AnimatedBuilder(
                              animation: tabController,
                              builder: (context, child) {
                                return tabController.index == 0
                                    ? TextSchemaInput(
                                        jsonSchemaController: _jsonSchemaController,
                                        uiSchemaController: _uiSchemaController,
                                        onLoadSchemas: _loadTextSchemas,
                                      )
                                    : FileSchemaUpload(
                                        jsonSchemaFile: _fileJsonSchema,
                                        uiSchemaFile: _fileUiSchema,
                                        onPickJsonSchema: _pickJsonSchemaFile,
                                        onPickUiSchema: _pickUiSchemaFile,
                                        onLoadFiles: _loadFileSchemas,
                                      );
                              },
                            );
                          },
                        ),
                      ),
                      if (_formReady) LayoutConstants.gapL,
                      if (_formReady) const Divider(),
                      if (_formReady)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FlutterJsonForm(
                              key: _formKey,
                              validate: false,
                              jsonSchema: _jsonSchema,
                              uiSchema: _uiSchema,
                              formData: const {},
                              onFormSubmitSaveCallback: (formValues) {
                                showJsonDialog(context, 'Form Submitted', formValues);
                              },
                            ),
                            const Divider(),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: LayoutConstants.spacingS,
                                runSpacing: LayoutConstants.spacingM,
                                children: [
                                  FilledButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.saveAndValidate()) {
                                        final formData = _formKey.currentState!.value;
                                        showJsonDialog(context, 'Form Data', formData);
                                      }
                                    },
                                    child: const Text('Show Form Data'),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () {
                                      _formKey.currentState?.reset();
                                    },
                                    child: const Text('Reset Form'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
