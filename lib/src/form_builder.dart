import 'dart:convert';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/process_form_values.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_rule_evaluator.dart';
import 'package:flutter_json_forms/src/utils/show_on.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/shared/css.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/json_validator.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A dynamic form which generates form fields based on a JSON schema and a UI schema
class FlutterJsonForm extends StatefulWidget {
  /// The [jsonSchema] used to generate the JsonForm
  ///
  /// Must be a valid JSON schema according to the JSON schema meta schema draft-07
  /// depending on [parseJson] the [jsonSchema] can be a `Map<String, dynamic>` or a String
  final dynamic jsonSchema;

  /// The [uiSchema] used to generate the JsonForm
  ///
  /// Must be a valid UI Schema according to the UI schema meta schema
  /// depending on [parseJson] the [jsonSchema] can be a `Map<String, dynamic>` or a String
  ///
  /// The [uiSchema] can customize the form fields and the layout of the form in various ways
  /// It is optional to provide a [uiSchema]. If none is provided, a default one will be generated which shows all elements of the [jsonSchema]
  final dynamic uiSchema;

  /// [validate] controls whether the [jsonSchema] and [uiSchema] should be validated before rendering
  ///
  /// Defaults to true
  final bool validate;

  /// [parseJson] controls whether the [jsonSchema] and [uiSchema] should be parsed from a String to a `Map<String, dynamic>`
  ///
  /// Defaults to false
  final bool parseJson;

  /// [onFormSubmitCallback] is a callback function which gets called when the form is submitted
  ///
  /// The function gets called with the form values as a `Map<String, dynamic>` as a parameter
  final void Function(Map<String, dynamic>?)? onFormSubmitCallback;

  /// [OnFormSubmitFormat] specifies the format of the form data when the form is submitted
  // final OnFormSubmitFormat onFormSubmitFormat;

  /// [formData] defines the initial data for the form fields
  final Map<String, dynamic>? formData;

  /// [showLoadingWidget] controls whether a loading indicator should be shown while the form is being initialized
  final bool showLoadingWidget;

  /// [loadingWidget] is the widget displayed while the form is loading
  final Widget? loadingWidget;

  const FlutterJsonForm({
    super.key,
    required this.jsonSchema,
    this.uiSchema,
    this.validate = false,
    this.parseJson = false,
    this.formData,
    this.onFormSubmitCallback,
    this.showLoadingWidget = true,
    this.loadingWidget,
  });

  @override
  State<FlutterJsonForm> createState() => FlutterJsonFormState();
}

class FlutterJsonFormState extends State<FlutterJsonForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  static final _logger = FormLogger.formBuilder;

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
  final Map<String, bool> _ritaDependencies = {};
  bool _ritaInitialized = false;

  /// Storage for Rita rule results with array indices
  /// Key format: "ruleId|selfIndicesJson" -> bool result
  final Map<String, bool> _ritaArrayDependencies = {};

  /// Revision counter to track when Rita dependencies change
  /// This helps FutureBuilder know when to re-evaluate array elements
  int _ritaDependenciesRevision = 0;

  /// Revision counter to track when form is reset
  /// This helps array fields know when to re-initialize their items
  int _formResetRevision = 0;

  /// return true if the widget is in the loading state (the validation is not finished yet
  bool get isLoading {
    // If still initializing, we're loading
    if (_isInitializing) return true;

    // If validation is enabled and validation errors haven't been set yet, we're loading
    if (widget.validate && (_jsonSchemaValidationErrors == null || _uiSchemaValidationErrors == null)) return true;

    // If Rita hasn't been initialized yet, we're loading
    if (!_ritaInitialized) return true;

    return false;
  }

  /// Flag to track if initial setup is in progress
  bool _isInitializing = true;

  /// return true if the JSON schema is valid
  bool get validJsonSchema {
    if (isLoading) return false;
    if (!widget.validate) return true; // Always valid when validation is disabled
    return _jsonSchemaValidationErrors?.isEmpty ?? false;
  }

  /// return true if the UI schema is valid
  bool get validUISchema {
    if (isLoading) return false;
    if (!widget.validate) return true; // Always valid when validation is disabled
    return _uiSchemaValidationErrors?.isEmpty ?? false;
  }

  /// return true if the widget has errors in the JSON or UI schema (only if the validation was turned on and is finished)
  bool get hasErrors {
    return !validJsonSchema || !validUISchema || _initializationError != null;
  }

  /// initializationError
  Object? _initializationError;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  /// Async initialization to avoid blocking the UI
  Future<void> _initializeAsync() async {
    _logger.config('Starting form initialization');
    try {
      _logger.finer('Initializing JavaScript engine and rule set');
      await _initializeJsEngineAndRuleSetAsync();

      if (widget.validate) {
        _logger.finer('Loading and validating schemas');
        await _initializeSchemas();
      }

      _logger.finer('Initializing form data and rules');
      await _initializeFormAsync();

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        _logger.config('Form initialization completed successfully');
      }
    } catch (e, stackTrace) {
      _logger.severe('Form initialization failed', e, stackTrace);
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initializationError = e;
        });
      }
    }
  }

  @override
  void dispose() {
    ritaRuleEvaluator.dispose();
    super.dispose();
  }

  /// Initializes the JavaScript engine and rule set asynchronously
  Future<void> _initializeJsEngineAndRuleSetAsync() async {
    // Use Future.microtask to yield control back to the UI thread
    await Future.microtask(() {
      ritaRuleEvaluator = RitaRuleEvaluator.create();
    });
  }

  /// get the json and ui meta schema
  /// only needed if json und ui schema should get validated
  Future<void> _initializeSchemas() async {
    jsonMetaSchema = await SchemaManager().getJsonMetaSchema();
    uiMetaSchema = await SchemaManager().getUiMetaSchema();
  }

  /// Initializes the form by creating jsonSchema and uiSchema objects, setting the defaultDependencies and ritaRules
  Future<void> _initializeFormAsync() async {
    // Initialize data
    if (widget.formData != null) {
      formData = widget.formData!;
    } else {
      formData = {};
    }

    // Initialize json Schema
    await Future.microtask(() {
      final Map<String, dynamic> jsonSchemaMap = _getMap(widget.jsonSchema, "jsonSchema");
      if (widget.validate && !_validateJsonSchema(jsonSchemaMap)) {
        _logger.severe('Invalid JSON schema: $jsonSchemaMap');
        return;
      }
      jsonSchemaModel = JsonSchema.create(jsonSchemaMap);
    });

    // initialize Ui Schema
    await Future.microtask(() {
      if (widget.uiSchema == null) {
        uiSchemaModel = generateDefaultUISchema(jsonSchemaModel.properties);
      } else {
        final Map<String, dynamic> uiSchemaMap = _getMap(widget.uiSchema, "uiSchema");
        if (widget.validate && !_validateUiSchema(uiSchemaMap)) {
          _logger.severe('Invalid UI schema: $uiSchemaMap');
          return;
        }
        uiSchemaModel = ui.UiSchema.fromJson(uiSchemaMap);
      }
    });

    // Initialize ShowOnDependencies
    await Future.microtask(() {
      _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, formData);
    });

    // Collect all rita rules
    await Future.microtask(() {
      final ritaRules = collectRitaRules(uiSchemaModel.layout.elements);
      for (final rule in ritaRules) {
        ritaRuleEvaluator.addRule(rule);
      }
      _ritaInitialized = false;
    });

    // Initialize Rita rules bundle and evaluate
    await ritaRuleEvaluator.initializeWithBundle();

    final ritaDependencies = await ritaRuleEvaluator.evaluateAll(jsonEncode(toEncodable(processFormValues(_showOnDependencies))));

    if (mounted) {
      setState(() {
        _ritaDependencies.clear();
        _ritaDependencies.addAll(ritaDependencies);
        _ritaDependenciesRevision++;
        _ritaInitialized = true;
      });
    }
  }

  /// Save form values and validate all fields of form
  ///
  /// Focus to first invalid field when has field invalid, if [focusOnInvalid] is `true`.
  /// By default `true`
  ///
  /// Auto scroll to first invalid field focused if [autoScrollWhenFocusOnInvalid] is `true`.
  /// By default `false`.
  ///
  /// Note: If an invalid field is from type **TextField** and will focused,
  /// the form will auto scroll to show this invalid field.
  /// In this case, the automatic scroll happens because it is a behavior inside the framework,
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
  /// if initial formData was provided and [resetFormData] is true (default), the provided formData gets also reset and only default values from the jsonSchema are present in the form after reset
  void reset({bool resetFormData = true}) {
    void customResetPatch() {
      final formKeyState = _formKey.currentState?.instantValue ?? {};
      final patchState = Map<String, dynamic>.from(_showOnDependencies);
      formKeyState.forEach((key, value) {
        if (patchState.containsKey(key)) {
          final targetType = value?.runtimeType;
          final patchValue = patchState[key];
          if (targetType == String) {
            patchState[key] = patchValue?.toString();
          } else if (targetType == int) {
            patchState[key] = patchValue is int ? patchValue : int.tryParse(patchValue?.toString() ?? '');
          } else if (targetType == double) {
            patchState[key] = patchValue is double ? patchValue : double.tryParse(patchValue?.toString() ?? '');
          } else if (targetType == bool) {
            if (patchValue is bool) {
              patchState[key] = patchValue;
            } else if (patchValue is String) {
              patchState[key] = patchValue.toLowerCase() == 'true';
            } else {
              patchState[key] = false;
            }
          } else if (targetType == List) {
            // TODO
            // Use schema to determine minItems if possible, otherwise []
            patchState[key] = patchValue is List ? patchValue : []; // Or use schema/minItems if available
          }
        } else {
          // Key not in patchState, set to null
          patchState[key] = null;
        }
      });
      _formKey.currentState?.patchValue(patchState);
    }

    setState(() {
      _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, null);
      _ritaDependencies.clear();
      _ritaDependenciesRevision++;
      _formResetRevision++; // Increment reset counter for array fields
      // if (formData.isNotEmpty && resetFormData) {
      //   _customResetPatch();
      // } else {
      //   _formKey.currentState?.reset();
      // }
      customResetPatch();
    });
  }

  /// Returns the saved value only (populated after saveAndValidate is called)
  Map<String, dynamic> get value {
    return processFormValues(_formSubmitValues);
  }

  /// Returns the current form values (regardless of validation state)
  // Map<String, dynamic> get currentValue {
  //   final currentValues = _formKey.currentState?.value ?? {};
  //   return processFormValuesEllaV2(currentValues);
  // }

  Map<String, dynamic> get instantValue {
    _logger.config('Getting instant form values');
    final currentValues = _formKey.currentState?.instantValue ?? {};
    _logger.finer('Instant form values: $currentValues');
    final processedValues = processFormValues(currentValues);
    _logger.finer('Processed instant form values: $processedValues');
    return processedValues;
  }

  void patchValue(Map<String, dynamic> value) {
    _logger.config('Patching form values: $value');
    _formKey.currentState?.patchValue(value);
    _logger.finer('Form values patched to ${_formKey.currentState?.instantValue}');
  }

  /// [instance] can be a `Map<String, dynamic>` or a String
  /// if the instance is a String and [parseJson] is true, the instance is parsed to a `Map<String, dynamic>`
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
    if (widget.validate || _isInitializing) {
      if (isLoading) {
        if (!widget.showLoadingWidget) {
          return Container();
        }
        return widget.loadingWidget ?? buildSkeletonForm();
      } else if (hasErrors) {
        return Column(children: [
          if (_jsonSchemaValidationErrors!.isNotEmpty) ...[
            const FormFieldText(
              "There were errors in the JSON schema:",
              style: TextStyle(color: Colors.red),
            ),
            ..._jsonSchemaValidationErrors!.map((error) => Text(error.toString())),
          ],
          if (_uiSchemaValidationErrors!.isNotEmpty) ...[
            const FormFieldText(
              "There were errors in the UI schema:",
              style: TextStyle(color: Colors.red),
            ),
            ..._uiSchemaValidationErrors!.map((error) => Text(error.toString())),
          ],
          if (_initializationError != null) ...[
            FormFieldText(
              "There was an error during initialization: ${_initializationError.toString()}",
              style: TextStyle(color: Colors.red),
            )
          ],
        ]);
      }
    }

    if (!widget.showLoadingWidget) {
      return _getFormBuilder();
    }

    return _getFormBuilder();
  }

  FormBuilder _getFormBuilder() {
    return FormBuilder(
      key: _formKey,
      child: FormContext(
        onFormSubmitCallback: widget.onFormSubmitCallback,
        showOnDependencies: _showOnDependencies,
        ritaDependencies: _ritaDependencies,
        ritaDependenciesRevision: _ritaDependenciesRevision,
        formResetRevision: _formResetRevision,
        jsonSchemaModel: jsonSchemaModel,
        ritaEvaluator: ritaRuleEvaluator,
        setValueForShowOn: setValueForShowOn,
        checkValueForShowOn: checkValueForShowOn,
        isRequired: (path) => _isRequired(jsonSchemaModel, path),
        getFullFormData: () => processFormValues(_showOnDependencies),
        onFormValueSaved: _onFormValueSaved,
        onFormValueChanged: _onFormValueChanged,
        saveAndValidate: ({bool focusOnInvalid = true, bool autoScrollWhenFocusOnInvalid = false}) =>
            saveAndValidate(focusOnInvalid: focusOnInvalid, autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid),
        reset: reset,
        getFormValues: () => instantValue,
        storeRitaArrayResult: _storeRitaArrayResult,
        checkElementShownWithRita: isElementShownWithRita,
        child: _generateLayout(),
      ),
    );
  }

  /// Builds the form header (title and description) if present
  Widget? _buildFormHeader() {
    final String? title = jsonSchemaModel.schemaMap?['title'] as String?;
    final String? description = jsonSchemaModel.schemaMap?['description'] as String?;
    List<Widget> header = [];
    if (title != null && title.isNotEmpty) {
      header.add(Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FormFieldText(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ));
    }
    if (description != null && description.isNotEmpty) {
      header.add(Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FormFieldText(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ));
    }
    if (header.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: header,
      );
    }
    return null;
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

    final Widget? header = _buildFormHeader();
    if (header != null) {
      return applyCss(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            child,
          ],
        ),
        cssClass: layout.options?.cssClass,
      );
    } else {
      return applyCss(context, child, cssClass: layout.options?.cssClass);
    }
  }

  void _onFormValueSaved(String scope, dynamic value) {
    // This is called when a form field is saved and determines if it should be in submit values

    // For now, always include if value is not null/empty
    // The Rita visibility will be handled by the widgets themselves
    if (value != null && value != "") {
      _formSubmitValues[scope] = value;
    } else {
      _formSubmitValues.remove(scope);
    }
  }

  void _onFormValueChanged(String scope, dynamic value) async {
    _logger.fine('Form value changed: $scope = $value');

    // Update the showOn dependencies
    setValueForShowOn(scope, value);

    // Evaluate Rita rules with the updated dependencies
    _logger.finer('Evaluating Rita rules for updated dependencies');
    final ritaDependencies = await ritaRuleEvaluator.evaluateAll(jsonEncode(toEncodable(processFormValues(_showOnDependencies))));

    // Update UI
    if (mounted) {
      setState(() {
        _ritaDependencies.clear();
        _ritaDependencies.addAll(ritaDependencies);
        _ritaDependenciesRevision++;
      });
      _logger.finer('Updated ${ritaDependencies.length} Rita dependencies');
    }
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

  /// Generate a key for Rita array dependencies that includes selfIndices
  String _generateRitaArrayKey(String ruleId, Map<String, int>? selfIndices) {
    if (selfIndices == null || selfIndices.isEmpty) {
      return ruleId;
    }
    final sortedIndices = Map.fromEntries(selfIndices.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    final indicesJson = jsonEncode(sortedIndices);
    return '$ruleId|$indicesJson';
  }

  /// Store Rita rule result for array elements with selfIndices
  void _storeRitaArrayResult(String ruleId, Map<String, int>? selfIndices, bool result) {
    final key = _generateRitaArrayKey(ruleId, selfIndices);
    _ritaArrayDependencies[key] = result;
  }

  /// Get Rita rule result for array elements with selfIndices
  bool? _getRitaArrayResult(String ruleId, Map<String, int>? selfIndices) {
    final key = _generateRitaArrayKey(ruleId, selfIndices);
    return _ritaArrayDependencies[key];
  }

  /// Check if an element with Rita rules is shown (handles both global and array-specific rules)
  bool isElementShownWithRita(ui.ShowOnProperty? showOn, Map<String, int>? selfIndices, bool? parentIsShown) {
    if (parentIsShown == false) return false;
    if (showOn == null) return true;

    if (showOn.rule != null && showOn.id != null) {
      // For array elements with selfIndices, check the array-specific storage
      if (selfIndices != null && selfIndices.isNotEmpty) {
        final result = _getRitaArrayResult(showOn.id!, selfIndices);
        if (result != null) {
          return result;
        }
      }
      // Fall back to global Rita dependencies
      return _ritaDependencies[showOn.id!] == true;
    }

    // Fallback: classic showOn evaluation using existing utility
    return isElementShown(
      parentIsShown: parentIsShown,
      showOn: showOn,
      ritaDependencies: _ritaDependencies,
      checkValueForShowOn: checkValueForShowOn,
    );
  }
}

/// Creates a skeleton form while loading
Widget buildSkeletonForm() {
  return Skeletonizer(
    enabled: true,
    child: SingleChildScrollView(
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small loading indicator at top
          const Bone.text(words: 2, fontSize: 24),
          const SizedBox(height: 24),

          // Form title skeleton
          for (int i = 0; i < 10; i++) ...[
            const Bone.text(words: 1, fontSize: 18),
            const SizedBox(height: 16),
            const Bone.text(words: 4, fontSize: 14),
            const SizedBox(height: 24),
          ],

          // Button skeleton
          const Bone.button(width: 120, height: 48),
          const SizedBox(height: 20), // Extra space at bottom
        ],
      ),
    ),
  );
}
