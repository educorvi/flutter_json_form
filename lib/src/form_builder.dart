import 'dart:convert';
import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;
import 'package:flutter_json_forms/src/process_form_values.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/ritaRuleEvaluator.dart';
import 'package:flutter_json_forms/src/utils/show_on.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/shared/css.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/json_validator.dart';

/// A dynamic form which generates form fields based on a JSON schema and a UI schema
class FlutterJsonForm extends StatefulWidget {
  /// The [jsonSchema] used to generate the JsonForm
  ///
  /// Must be a valid JSON schema according to the JSON schema meta schema draft-07
  /// depending on [parseJson] the [jsonSchema] can be a Map<String, dynamic> or a String
  final dynamic jsonSchema;

  /// The [uiSchema] used to generate the JsonForm
  ///
  /// Must be a valid UI Schema according to the UI schema meta schema
  /// depending on [parseJson] the [jsonSchema] can be a Map<String, dynamic> or a String
  ///
  /// The [uiSchema] can customize the form fields and the layout of the form in various ways
  /// It is optional to provide a [uiSchema]. If none is provided, a default one will be generated which shows all elements of the [jsonSchema]
  final dynamic uiSchema;

  /// [validate] controls whether the [jsonSchema] and [uiSchema] should be validated before rendering
  ///
  /// Defaults to true
  final bool validate;

  /// [parseJson] controls whether the [jsonSchema] and [uiSchema] should be parsed from a String to a Map<String, dynamic>
  ///
  /// Defaults to false
  final bool parseJson;

  /// [onFormSubmit] is a callback function which gets called when the form is submitted
  ///
  /// The function gets called with the form values as a Map<String, dynamic> as a parameter
  // final void Function(Map<String, dynamic>?)? onFormSubmit;

  /// [OnFormSubmitFormat] specifies the format of the form data when the form is submitted
  // final OnFormSubmitFormat onFormSubmitFormat;

  // TODO maybe form key, maybe debug (default off, ignore tolerable errors or log them to the debug console, or: show them in the ui)

  /// [formData] defines the initial data for the form fields
  final Map<String, dynamic>? formData;

  const FlutterJsonForm({
    super.key,
    required this.jsonSchema,
    this.uiSchema,
    this.validate = true,
    this.parseJson = false,
    this.formData,
  });

  @override
  State<FlutterJsonForm> createState() => FlutterJsonFormState();
}

class FlutterJsonFormState extends State<FlutterJsonForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  /// The validation errors of the JSON and UI schema
  List<ValidationError>? _jsonSchemaValidationErrors;
  List<ValidationError>? _uiSchemaValidationErrors;

  /// Json Schemas
  late final JsonSchema jsonMetaSchema;
  late final JsonSchema jsonSchemaModel;

  /// Ui schemas
  late final JsonSchema uiMetaSchema;
  late final ui.UiSchema uiSchemaModel;

  /// The dependencies of the form fields which are dependent on other fields
  Map<String, dynamic> _showOnDependencies = {};

  /// The values which will get submitted
  /// They are not the same as the form data as some fields are e.g. not shown and therefore not submitted but should still be stored (_showOnDependencies)
  final Map<String, dynamic> _formSubmitValues = {};

  late final Map<String, dynamic> formData;

  /// Rita Rule Evaluator
  late final RitaRuleEvaluator ritaRuleEvaluator;
  Map<String, bool> _ritaDependencies = {};
  bool _ritaInitialized = false;

  /// return true if the widget is in the loading state (the validation is not finished yet
  /// (async part comes form reading the files. The validation is done synchronously))
  get isLoading {
    return (_jsonSchemaValidationErrors == null || _uiSchemaValidationErrors == null) && !_ritaInitialized;
  }

  /// return true if the JSON schema is valid
  get validJsonSchema {
    return !isLoading && _jsonSchemaValidationErrors!.isEmpty;
  }

  /// return true if the UI schema is valid
  get validUISchema {
    return !isLoading && _uiSchemaValidationErrors!.isEmpty;
  }

  /// return true if the widget has errors in the JSON or UI schema (only if the validation was turned on and is finished)
  get hasErrors {
    return !validJsonSchema || !validUISchema;
  }

  @override
  void initState() {
    _initializeJsEngineAndRuleSet();
    if (widget.validate) {
      _initializeSchemas().then((_) {
        _initializeForm();
      });
    } else {
      _initializeForm();
    }
    super.initState();
  }

  /// Initializes the JavaScript engine and rule set
  void _initializeJsEngineAndRuleSet() {
    ritaRuleEvaluator = RitaRuleEvaluator.create();
  }

  /// get the json and ui meta schema
  /// only needed if json und ui schema should get validated
  Future<void> _initializeSchemas() async {
    jsonMetaSchema = await SchemaManager().getJsonMetaSchema();
    uiMetaSchema = await SchemaManager().getUiMetaSchema();
  }

  /// Initializes the form by creating jsonSchema and uiSchema objects, setting the defaultDependencies and ritaRules
  void _initializeForm() {
    // Initialize data
    if (widget.formData != null) {
      formData = widget.formData!;
    } else {
      formData = {};
    }

    // Initialize json Schema
    final Map<String, dynamic> jsonSchemaMap = _getMap(widget.jsonSchema, "jsonSchema");
    if (widget.validate && !_validateJsonSchema(jsonSchemaMap)) {
      return;
    }
    jsonSchemaModel = JsonSchema.create(jsonSchemaMap);

    // initialize Ui Schema
    if (widget.uiSchema == null) {
      uiSchemaModel = generateDefaultUISchema(jsonSchemaModel.properties);
    } else {
      final Map<String, dynamic> uiSchemaMap = _getMap(widget.uiSchema, "uiSchema");
      if (widget.validate && !_validateUiSchema(uiSchemaMap)) {
        return;
      }
      uiSchemaModel = ui.UiSchema.fromJson(uiSchemaMap);
    }

    // Initialize ShowOnDependencies
    _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, formData);

    // Collect all rita rules
    final ritaRules = collectRitaRules(uiSchemaModel.layout.elements);
    for (final rule in ritaRules) {
      ritaRuleEvaluator.addRule(rule);
    }
    _ritaInitialized = false;
    ritaRuleEvaluator.initializeWithBundle().then(
      (_) {
        ritaRuleEvaluator.evaluateAll(jsonEncode(toEncodable(processFormValuesEllaV2(_showOnDependencies)))).then((value) {
          _ritaDependencies = value;
          setState(() {
            _ritaInitialized = true;
          });
        });
      },
    );
  }

  /// Save form values and validate all fields of form
  ///
  /// Focus to first invalid field when has field invalid, if [focusOnInvalid] is `true`.
  /// By default `true`
  ///
  /// Auto scroll to first invalid field focused if [autoScrollWhenFocusOnInvalid] is `true`.
  /// By default `false`.
  ///
  /// Note: If a invalid field is from type **TextField** and will focused,
  /// the form will auto scroll to show this invalid field.
  /// In this case, the automatic scroll happens because is a behavior inside the framework,
  /// not because [autoScrollWhenFocusOnInvalid] is `true`.
  bool saveAndValidate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    _formSubmitValues.clear();
    return _formKey.currentState!.saveAndValidate(
      focusOnInvalid: focusOnInvalid,
      autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
    );
  }

  /// Reset form to `initialValue` set on FormBuilder or on each field.
  void reset() {
    setState(() {
      resetShowOnDependencies(_showOnDependencies);
      _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, null);
      _formKey.currentState!.reset();
      _formKey.currentState!.patchValue(_showOnDependencies);
    });
  }

  /// Returns the saved value only
  Map<String, dynamic> get value {
    return processFormValuesEllaV2(_formSubmitValues);
  }

  void patchValue(Map<String, dynamic> value) {
    _formKey.currentState?.patchValue(value);
  }

  /// [instance] can be a Map<String, dynamic> or a String
  /// if the instance is a String and [parseJson] is true, the instance is parsed to a Map<String, dynamic>
  /// if [parseJson] is false, the instance is used as is
  dynamic _getMap(dynamic instance, String argumentName) {
    dynamic data = instance;
    if (widget.parseJson && instance is String) {
      try {
        data = json.decode(instance);
      } catch (e) {
        throw ArgumentError('JSON instance of $argumentName provided to validate is not valid JSON.');
      }
    } else {
      if (instance is! Map<String, dynamic>) {
        throw ArgumentError('JSON instance of $argumentName provided to validate is not a Map<String, dynamic>.');
      }
    }
    return data;
  }

  /// Validates the JSON schema against the JSON meta schema
  /// sets the validation errors in the state
  /// if the validation is successful, the jsonSchema is set
  bool _validateJsonSchema(Map<String, dynamic> jsonSchemaMap) {
    final result = jsonMetaSchema.validate(jsonSchemaMap);
    setState(() {
      _jsonSchemaValidationErrors = result.errors;
    });
    return result.errors.isEmpty;
  }

  /// Validates the UI schema against the UI meta schema
  /// sets the validation errors in the state
  /// if the validation is successful, the uiSchema is set
  bool _validateUiSchema(Map<String, dynamic> uiSchemaMap) {
    final result = uiMetaSchema.validate(uiSchemaMap);
    setState(() {
      _uiSchemaValidationErrors = result.errors;
    });
    return result.errors.isEmpty;
  }

  /// if the form should not be validated, it gets rendered directly
  /// if it should be validated:
  /// Returns a CircularProgressIndicator if the validation is not finished yet (async part comes from reading the files. The validation is done synchronously)
  /// Returns the validation errors if there are any
  /// Returns the form if there are no validation errors
  @override
  Widget build(BuildContext context) {
    if (widget.validate) {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (hasErrors) {
        return Column(
          children: [
            if (_jsonSchemaValidationErrors!.isNotEmpty) ...[
              const Text(
                "There were errors in the JSON schema:",
                style: TextStyle(color: Colors.red),
              ),
              ..._jsonSchemaValidationErrors!.map((error) => Text(error.toString())),
            ],
            if (_uiSchemaValidationErrors!.isNotEmpty) ...[
              const Text(
                "There were errors in the UI schema:",
                style: TextStyle(color: Colors.red),
              ),
              ..._uiSchemaValidationErrors!.map((error) => Text(error.toString())),
            ],
          ],
        );
      }
    }
    return _getFormBuilder();
  }

  /// Creates the FormBuilder widget
  FormBuilder _getFormBuilder() {
    return FormBuilder(
      initialValue: _showOnDependencies,
      key: _formKey,
      child: FormContext(
        showOnDependencies: _showOnDependencies,
        ritaDependencies: _ritaDependencies,
        jsonSchemaModel: jsonSchemaModel,
        ritaEvaluator: ritaRuleEvaluator,
        setValueForShowOn: setValueForShowOn,
        checkValueForShowOn: checkValueForShowOn,
        isRequired: (path) => _isRequired(jsonSchemaModel, path),
        getFullFormData: () => processFormValuesEllaV2(_showOnDependencies),
        onFormValueSaved: _onFormValueSaved,
        onFormValueChanged: _onFormValueChanged,
        saveAndValidate: ({bool focusOnInvalid = true, bool autoScrollWhenFocusOnInvalid = false}) =>
            saveAndValidate(focusOnInvalid: focusOnInvalid, autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid),
        reset: reset,
        getFormValues: () => value,
        child: _generateLayout(),
      ),
    );
  }

  /// Generates the form fields based on the elements of the UI schema
  Widget _generateLayout() {
    const nestingLevel = 0;
    ui.Layout layout = uiSchemaModel.layout;

    Widget child;
    switch (layout.type) {
      case ui.LayoutType.VERTICAL_LAYOUT:
        child = FormLayout.vertical(
          layout: layout,
          nestingLevel: nestingLevel,
        );
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        child = FormLayout.horizontal(
          layout: layout,
          nestingLevel: nestingLevel,
        );
      case ui.LayoutType.GROUP:
        child = FormGroup(layout: layout, nestingLevel: nestingLevel);
    }

    return applyCss(context, child, cssClass: layout.options?.cssClass);
  }

  void _onFormValueSaved(String scope, dynamic value) {
    // This is called when a form field is saved and determines if it should be in submit values
    final formContext = FormContext.of(context);
    if (formContext != null) {
      final isShown = isElementShown(
        parentIsShown: true,
        showOn: null, // You might need to pass showOn info here if needed
        ritaDependencies: _ritaDependencies,
        checkValueForShowOn: checkValueForShowOn,
      );

      if (value != null && value != "" && isShown) {
        _formSubmitValues[scope] = value;
      } else {
        _formSubmitValues.remove(scope);
      }
    }
  }

  void _onFormValueChanged(String scope, dynamic value) async {
    setValueForShowOn(scope, value);
    final ritaDependencies = await ritaRuleEvaluator.evaluateAll(jsonEncode(toEncodable(processFormValuesEllaV2(_showOnDependencies))));
    setState(() {
      _ritaDependencies = ritaDependencies;
      setValueForShowOn(scope, value);
    });
  }

  /// gets a value for a showOn condition
  /// [path] the path of the object in the json schema
  /// returns the value if it is set, otherwise null
  /// it doesn't matter if the path starts with a # or not
  dynamic checkValueForShowOn(String path) {
    return _showOnDependencies[getPathWithProperties(path)];
  }

  /// sets a value for a showOn condition
  /// [path] the path of the object in the json schema
  /// [value] the value to set
  /// it doesn't matter if the path starts with a # or not
  void setValueForShowOn(String path, dynamic value) {
    if (path.startsWith("#")) {
      _showOnDependencies[path.substring(1)] = value;
    } else {
      _showOnDependencies[path] = value;
    }
  }

  /// checks if a field is required
  /// [path] the path of the field in the json schema
  bool _isRequired(JsonSchema jsonSchemaModel, String path) {
    String parentPath = path.substring(0, path.lastIndexOf('/', path.lastIndexOf('/') - 1));

    if (parentPath == "#" || parentPath.isEmpty) {
      return jsonSchemaModel.propertyRequired(_getFieldNameFromPath(path));
    } else {
      JsonSchema? object = getObjectFromJson(jsonSchemaModel, parentPath);
      if (object == null) {
        return false;
      }
      return object.propertyRequired(_getFieldNameFromPath(path));
    }
  }

  String _getFieldNameFromPath(String path) {
    return path.split('/').last;
  }
}
