import 'dart:convert';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/process_form_values.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_rule_evaluator.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/form_layout_factory.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_loader.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/utils/show_on.dart';
import 'package:flutter_json_forms/src/utils/visibility_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/json_validator.dart';

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

  /// [onFormSubmitSaveCallback] is a callback function which gets called when the form is submitted and the save action is defined. See more within the ui Schema specification for a button
  ///
  /// The function gets called with the form values as a `Map<String, dynamic>` as a parameter
  final void Function(Map<String, dynamic>?)? onFormSubmitSaveCallback;

  /// [onFormRequestCallback] is a callback function which gets called when the form is requested to be submitted via a request action. See more within the ui Schema specification for a button
  final void Function(Map<String, dynamic>?, ui.Request?)? onFormRequestCallback;

  /// [OnFormSubmitFormat] specifies the format of the form data when the form is submitted
  // final OnFormSubmitFormat onFormSubmitFormat;

  /// [formData] defines the initial data for the form fields
  final Map<String, dynamic>? formData;

  /// [showLoadingWidget] controls whether a loading indicator should be shown while the form is being initialized
  final bool showLoadingWidget;

  /// [loadingWidget] is the widget displayed while the form is loading
  final Widget? loadingWidget;

  /// TODO: error widget

  const FlutterJsonForm({
    super.key,
    required this.jsonSchema,
    this.uiSchema,
    this.validate = false,
    this.parseJson = false,
    this.formData,
    this.onFormSubmitSaveCallback,
    this.onFormRequestCallback,
    this.showLoadingWidget = true,
    this.loadingWidget,
  });

  @override
  State<FlutterJsonForm> createState() => FlutterJsonFormState();
}

class FlutterJsonFormState extends State<FlutterJsonForm> with SafeSetStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  static final _logger = FormLogger.formBuilder;

  /// The validation errors of the JSON and UI schema
  List<String>? _jsonSchemaValidationErrors;
  List<String>? _uiSchemaValidationErrors;

  /// Json Schemas
  late final JsonSchema jsonMetaSchema;
  late final JsonSchema jsonSchemaModel;

  /// Ui schemas
  late final JsonSchema uiMetaSchema;
  late final ui.UiSchema? uiSchemaModel;

  /// The dependencies of the form fields which are dependent on other fields
  Map<String, dynamic> _showOnDependencies = {};
  Map<String, dynamic>? _processedShowOnValues;

  /// The values which will get submitted
  /// They are not the same as the form data as some fields are e.g. not shown and therefore not submitted but should still be stored (_showOnDependencies)
  final Map<String, dynamic> _formSubmitValues = {};

  late final Map<String, dynamic> formData;

  /// Rita Rule Evaluator
  late final RitaRuleEvaluator ritaRuleEvaluator;

  /// Visibility Manager
  late final VisibilityManager visibilityManager;

  /// return true if the widget is in the loading state (the validation is not finished yet
  bool get isLoading {
    // If still initializing, we're loading
    if (_isInitializing) return true;

    // If validation is enabled and validation errors haven't been set yet, we're loading
    // if (_jsonSchemaValidationErrors == null || _uiSchemaValidationErrors == null) return true;

    // If Rita hasn't been initialized yet, we're loading
    // if (!_ritaInitialized) return true;

    return false;
  }

  /// Flag to track if initial setup is in progress
  bool _isInitializing = true;

  /// return true if the JSON schema is valid
  bool get validJsonSchema {
    // if (isLoading) return false;
    // if (!widget.validate) return true; // Always valid when validation is disabled
    return _jsonSchemaValidationErrors?.isEmpty ?? true;
  }

  /// return true if the UI schema is valid
  bool get validUISchema {
    // if (isLoading) return false;
    // if (!widget.validate) return true; // Always valid when validation is disabled
    return _uiSchemaValidationErrors?.isEmpty ?? true;
  }

  /// return true if the widget has errors in the JSON or UI schema (only if the validation was turned on and is finished)
  bool get hasErrors {
    return !validJsonSchema || !validUISchema || _initializationError != null;
  }

  /// initializationError
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  /// Async initialization to avoid blocking the UI
  Future<void> _initializeAsync() async {
    _logger.info('Starting form initialization');
    try {
      _logger.fine('Initializing JavaScript engine and rule set');
      await _initializeJsEngineAndRuleSetAsync();

      if (widget.validate) {
        _logger.finer('Loading and validating schemas');
        await _initializeSchemas();
      }

      _logger.fine('Initializing form data and rules');
      await _initializeFormAsync();

      safeSetState(() {
        _isInitializing = false;
      });
      _logger.info('Form initialization completed successfully');
    } catch (e, stackTrace) {
      _logger.severe('Form initialization failed', e, stackTrace);
      // Also print to ensure it shows in CI logs
      // ignore: avoid_print
      print('══════════════════════════════════════════════════════════════');
      // ignore: avoid_print
      print('FLUTTER JSON FORM INITIALIZATION FAILED');
      // ignore: avoid_print
      print('Error: $e');
      // ignore: avoid_print
      print('Stack trace: $stackTrace');
      // ignore: avoid_print
      print('══════════════════════════════════════════════════════════════');

      safeSetState(() {
        _initializationError = e.toString();
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    ritaRuleEvaluator.dispose();
    visibilityManager.dispose();
    super.dispose();
  }

  /// Initializes the JavaScript engine and rule set asynchronously
  Future<void> _initializeJsEngineAndRuleSetAsync() async {
    // Use Future.microtask to yield control back to the UI thread
    await Future.microtask(() {
      ritaRuleEvaluator = RitaRuleEvaluator.create();

      // Create visibility manager for array-specific evaluations
      visibilityManager = VisibilityManager(
        ritaEvaluator: ritaRuleEvaluator,
        buildPayloadJson: _buildRitaPayloadJson,
      );

      // Listen to visibility changes and trigger rebuild
      visibilityManager.changes.addListener(() {
        if (mounted) {
          safeSetState(() {
            // Array evaluation completed, trigger rebuild
          });
        }
      });
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
          uiSchemaModel = null;
          return;
        }
        try {
          uiSchemaModel = ui.UiSchema.fromJson(uiSchemaMap);
        } catch (e) {
          _logger.severe('Error parsing UI schema: $uiSchemaMap', e);
          safeSetState(() {
            _uiSchemaValidationErrors = ['Error parsing UI schema: ${e.toString()}'];
          });
          uiSchemaModel = null;
          rethrow;
        }
      }
    });

    // Initialize ShowOnDependencies
    await Future.microtask(() {
      _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, formData);
      _refreshProcessedShowOnValues();
      _logger.fine('Initialized showOn dependencies: $_showOnDependencies');
    });

    // Collect all rita rules
    await Future.microtask(() {
      final ritaRules = collectRitaRules(getFormElements());
      for (final rule in ritaRules) {
        ritaRuleEvaluator.addRule(rule);
      }
      // _ritaInitialized = false;
    });

    // Initialize Rita rules bundle and evaluate
    await ritaRuleEvaluator.initializeWithBundle();

    final processed = _ensureProcessedShowOnValues();
    _logger.fine('Initial Rita payload: $processed');
    await ritaRuleEvaluator.evaluateAll(
      jsonEncode(
        toEncodable(processed),
      ),
    );

    safeSetState(() {
      // Rita evaluator manages its own state now
    });
  }

  List<ui.LayoutElement> getFormElements() {
    final layout = uiSchemaModel!.layout;
    switch (layout) {
      case ui.Layout(:final elements):
        return elements;
      case ui.Wizard(:final pages):
        List<ui.LayoutElement> elements = [];
        for (final page in pages) {
          elements.addAll(page.elements);
        }
        return elements;
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
    void resetPatch() {
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

    safeSetState(() {
      _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, null);
      _refreshProcessedShowOnValues();
      ritaRuleEvaluator.clearResults();
      visibilityManager.clearArrayResults();
      resetPatch();
    });
  }

  /// Returns the saved value only (populated after saveAndValidate is called)
  Map<String, dynamic> get value {
    return processFormValues(_formSubmitValues, skipFiles: false);
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
    final processedValues = processFormValues(currentValues, skipFiles: false);
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
    safeSetState(() {
      _jsonSchemaValidationErrors = result.errors.map((e) => e.toString()).toList();
    });
    return result.errors.isEmpty;
  }

  /// Validates the UI schema against the UI meta schema
  /// sets the validation errors in the state
  /// if the validation is successful, the uiSchema is set
  bool _validateUiSchema(Map<String, dynamic> uiSchemaMap) {
    final result = uiMetaSchema.validate(uiSchemaMap);
    safeSetState(() {
      _uiSchemaValidationErrors = result.errors.map((e) => e.toString()).toList();
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
    if (isLoading) {
      if (!widget.showLoadingWidget) {
        return Container();
      }
      return widget.loadingWidget ?? FormLoader();
    } else if (hasErrors) {
      late List<Widget> errorWidgets = [];

      if (_jsonSchemaValidationErrors != null && _jsonSchemaValidationErrors!.isNotEmpty) {
        _logger.warning('JSON Schema validation errors: $_jsonSchemaValidationErrors');
        errorWidgets.addAll([
          const FormFieldText(
            "There were errors in the JSON schema:",
            style: TextStyle(color: Colors.red),
          ),
          ..._jsonSchemaValidationErrors!.map((error) => Text(error.toString())),
        ]);
      }

      if (_uiSchemaValidationErrors != null && _uiSchemaValidationErrors!.isNotEmpty) {
        _logger.warning('UI Schema validation errors: $_uiSchemaValidationErrors');
        errorWidgets.addAll([
          const FormFieldText(
            "There were errors in the UI schema:",
            style: TextStyle(color: Colors.red),
          ),
          ..._uiSchemaValidationErrors!.map((error) => Text(error.toString())),
        ]);
      }

      if (_initializationError != null) {
        _logger.severe('Initialization error: $_initializationError');
        errorWidgets.add(
          FormFieldText(
            "There was an error during initialization: ${_initializationError.toString()}",
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errorWidgets,
      );
    } else {
      return _getFormBuilder();
    }
  }

  FormBuilder _getFormBuilder() {
    return FormBuilder(
      key: _formKey,
      child: FormContext(
        onFormSubmitSaveCallback: widget.onFormSubmitSaveCallback,
        onFormRequestCallback: widget.onFormRequestCallback,
        showOnDependencies: _showOnDependencies,
        jsonSchemaModel: jsonSchemaModel,
        ritaEvaluator: ritaRuleEvaluator,
        setValueForShowOn: setValueForShowOn,
        checkValueForShowOn: checkValueForShowOn,
        isRequired: (path) => _isRequired(jsonSchemaModel, path),
        getFullFormData: () {
          final data = _ensureProcessedShowOnValues();
          _logger.finest('getFullFormData payload: $data');
          return data;
        },
        onFormValueSaved: _onFormValueSaved,
        onFormValueChanged: _onFormValueChanged,
        saveAndValidate: ({bool focusOnInvalid = true, bool autoScrollWhenFocusOnInvalid = false}) =>
            saveAndValidate(focusOnInvalid: focusOnInvalid, autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid),
        reset: reset,
        getFormValues: () => instantValue,
        elementShown: _isElementShown,
        child: generateForm(uiSchemaModel!.layout),
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
        padding: const EdgeInsets.only(bottom: UIConstants.verticalElementSpacing),
        child: FormFieldText(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ));
    }
    if (description != null && description.isNotEmpty) {
      header.add(Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.verticalElementSpacing),
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
  Widget generateForm(ui.RootLayout layout) {
    Widget child = LayoutFactory.generateRootLayout(layout);

    final Widget? header = _buildFormHeader();
    if (header != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          child,
        ],
      );
    } else {
      return child;
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
    _logger.config('Form value changed: $scope = $value');

    // Update the showOn dependencies
    setValueForShowOn(scope, value);

    // Evaluate global Rita rules with the updated dependencies
    _logger.finer('Evaluating Rita rules for updated dependencies');
    final processed = _refreshProcessedShowOnValues();
    _logger.finer('Rita payload after value change: $processed');
    await ritaRuleEvaluator.evaluateAll(
      jsonEncode(
        toEncodable(processed),
      ),
    );

    // Re-evaluate array-specific rules with fresh data (keeps old values until done)
    await visibilityManager.reEvaluateAll();

    // Update UI once - all evaluations complete, no jumping!
    safeSetState(() {});
    _logger.config('Updated Rita dependencies');
  }

  /// gets a value for a showOn condition
  /// [path] the path of the object in the json schema
  /// returns the value if it is set, otherwise null
  /// it doesn't matter if the path starts with a # or not
  dynamic checkValueForShowOn(String path, {Map<String, int>? selfIndices}) {
    final normalizedPath = getPathWithProperties(path);
    final processedValues = _ensureProcessedShowOnValues();
    return resolveShowOnValue(
      processedValues,
      normalizedPath,
      selfIndices: selfIndices,
    );
  }

  /// Check if an element should be shown based on showOn conditions
  /// Delegates to show_on.dart implementation with array-aware Rita handling
  bool _isElementShown({
    required ui.ShowOnProperty? showOn,
    Map<String, int>? selfIndices,
    required bool? parentIsShown,
  }) {
    _logger.finest('Checking visibility for showOn rule ${showOn?.id} with selfIndices: $selfIndices');

    return isElementShown(
      parentIsShown: parentIsShown,
      showOn: showOn,
      getRitaResult: () {
        if (showOn?.rule == null || showOn?.id == null) return null;

        // Array-specific Rita rule
        if (selfIndices != null && selfIndices.isNotEmpty) {
          final result = visibilityManager.getArrayResult(showOn!.id!, selfIndices);
          _logger.finest('Array Rita result for ${showOn.id} with $selfIndices: $result');
          // If not cached yet, return null so it shows optimistically
          return result;
        }

        // Global Rita rule
        final result = ritaRuleEvaluator.getResult(showOn!.id!);
        _logger.finest('Global Rita result for ${showOn.id}: $result');
        return result;
      },
      checkValueForShowOn: (path) => checkValueForShowOn(path, selfIndices: selfIndices),
    );
  }

  /// sets a value for a showOn condition
  /// [path] the path of the object in the json schema
  /// [value] the value to set
  /// it doesn't matter if the path starts with a # or not
  void setValueForShowOn(String path, dynamic value) {
    final normalizedPath = getPathWithProperties(path);
    _showOnDependencies[normalizedPath] = value;
    _invalidateProcessedShowOnValues();
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

  Map<String, dynamic> _refreshProcessedShowOnValues() {
    _processedShowOnValues = processFormValues(_showOnDependencies);
    return _processedShowOnValues!;
  }

  Map<String, dynamic> _ensureProcessedShowOnValues() {
    return _processedShowOnValues ?? _refreshProcessedShowOnValues();
  }

  void _invalidateProcessedShowOnValues() {
    _processedShowOnValues = null;
  }

  String _buildRitaPayloadJson(Map<String, int>? selfIndices) {
    final evalData = {
      r"$selfIndices": selfIndices ?? <String, int>{},
      ..._ensureProcessedShowOnValues(),
    };
    return jsonEncode(toEncodable(evalData));
  }
}
