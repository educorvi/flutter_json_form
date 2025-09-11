import 'dart:convert';
import 'package:flutter_json_forms/src/process_form_values.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_Rule_evaluator.dart';
import 'package:flutter_json_forms/src/utils/show_on.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/html_widget.dart';
import 'package:flutter_json_forms/src/widgets/shared/css.dart';
import 'package:flutter_json_forms/src/widgets/shared/common.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../models/ui_schema.dart' as ui;
import 'form_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/json_validator.dart';
import 'constants.dart';

/// A dynamic form which generates form fields based on a JSON schema and a UI schema
class DynamicJsonForm extends StatefulWidget {
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

  const DynamicJsonForm(
      {super.key,
      required this.jsonSchema,
      this.uiSchema,
      // this.onFormSubmit,
      this.validate = true,
      this.parseJson = false,
      this.formData});

  @override
  State<DynamicJsonForm> createState() => DynamicJsonFormState();
}

class DynamicJsonFormState extends State<DynamicJsonForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  /// The validation errors of the JSON and UI schema
  List<ValidationError>? _jsonSchemaValidationErrors;
  List<ValidationError>? _uiSchemaValidationErrors;

  // Json Schemas
  late final JsonSchema jsonMetaSchema;
  late final JsonSchema jsonSchemaModel;
  // late final JsonSchemaModel jsonSchemaModel; // TODO most likely not used anymore

  // Ui schemas
  late final JsonSchema uiMetaSchema;
  late final ui.UiSchema uiSchemaModel;

  /// The dependencies of the form fields which are dependent on other fields
  Map<String, dynamic> _showOnDependencies = {};

  /// The values which will get submitted
  /// They are not the same as the form data as some fields are e.g. not shown and therefore not submitted but should still be stored (_showOnDependencies)
  final Map<String, dynamic> _formSubmitValues = {};

  late final Map<String, dynamic> formData;

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
    // _formKey.currentState!.patchValue(removeEmptyKeys(_showOnDependencies));

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
      // formData.clear();
      resetShowOnDependencies(_showOnDependencies);
      _showOnDependencies = initShowOnDependencies(jsonSchemaModel.properties, null);
      // _formKey.currentState!.reset();
      _formKey.currentState!.reset();
      // The problem here is that sometimes integers are integers (e..g as a slider determined by ui schema) and sometimes they are represented as string (like in a Textfield). We can't determine the type here as it is not solely dependent on the json schema but on the combination of ui and json schema. This would mean re-implementing the logic within form_elements which decides which element to render. An easier approach would be to just check which type the element had before and then convert it accordingly
      _formKey.currentState!.patchValue(_showOnDependencies); // convertShowOnDependenciesToFormBuilderValues
      // final arrayElementsToDelete = _resetShowOnDependencies(_showOnDependencies);
      // _showOnDependencies = _initShowOnDependencies(_properties, null);
      // _formKey.currentState!.patchValue(convertShowOnDependenciesToFormBuilderValues(_showOnDependencies));
    });
  }

  /// Returns the saved value only
  Map<String, dynamic> get value {
    // TODO here, preprocessing can be done in order to e.g. sort array correctly, return a nested object instead of a flat one, etc.
    // TODO when doing this, all operation have to be implemented in reverse when a state is being set for the form. See form_builder for reference on how to do this
    // TODO not visible fields should be filtered out here. Also, array field preprocessing should happen.
    // return processFormValuesEllaV2(_formKey.currentState!.value);
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
        return const Center(child: CircularProgressIndicator()); //  TODO: customizable loading indicator
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

  /// Returns the FormBuilder widget with the form fields and submit buttons
  FormBuilder _getFormBuilder() {
    return FormBuilder(
      initialValue: _showOnDependencies,
      key: _formKey,
      child: _generateLayout(),
    );
  }

  /// Generates the form fields based on the elements of the UI schema
  Widget _generateLayout() {
    const nestingLevel = 0;
    Widget child;
    ui.Layout layout = uiSchemaModel.layout;
    switch (layout.type) {
      case ui.LayoutType.VERTICAL_LAYOUT:
        child = _generateVerticalLayout(layout, nestingLevel);
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        child = _generateHorizontalLayout(layout, nestingLevel);
      case ui.LayoutType.GROUP:
        child = _generateGroupFromLayout(layout, nestingLevel);
    }
    return applyCss(context, child, cssClass: layout.options?.cssClass);
  }

  /// Generates a group of elements from a layout element
  Widget _generateGroupFromLayoutElement(ui.Layout item, int nestingLevel) {
    List<ui.LayoutElement> elements = item.elements;
    String? label = item.options?.label;
    ui.ShowOnProperty? showOn = item.showOn;
    return _generateGroup(elements, label, showOn, nestingLevel);
  }

  /// Generates a group of elements from a layout
  Widget _generateGroupFromLayout(ui.Layout item, int nestingLevel) {
    List<ui.LayoutElement> elements = item.elements;
    String? label = item.options?.label;
    ui.ShowOnProperty? showOn = item.showOn;
    return _generateGroup(elements, label, showOn, nestingLevel);
  }

  /// generates a group of elements with an optional label at the top
  Widget _generateGroup(List<ui.LayoutElement> elements, String? label, ui.ShowOnProperty? showOn, int nestingLevel) {
    bool? isShown = isElementShown(showOn: showOn, ritaDependencies: _ritaDependencies, checkValueForShowOn: checkValueForShowOn);

    // _evaluateCondition(showOn.type, checkValueForShowOn(showOn.path ?? ""), showOn.referenceValue);
    Column generateGroupElements() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //shrinkWrap: true,
        //physics: const ClampingScrollPhysics(),
        children: elements.map((item) {
          return _generateItem(item, nestingLevel, isShownFromParent: isShown, layoutDirection: LayoutDirection.vertical);
        }).toList(),
      );
    }

    Widget groupElement = getLineContainer(
        child: Padding(
      padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
      child: generateGroupElements(),
    ));

    return label != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              groupElement,
            ],
          )
        : groupElement;
  }

  /// generates a horizontal layout with the elements in a row. A Wrap is used to warp the elements around
  /// if they need more horizontal space than available
  LayoutBuilder _generateHorizontalLayout(ui.Layout item, int nestingLevel) {
    final elements = item.elements;
    final label = item.options?.label;
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: elements.map((item) {
          return Expanded(child: _generateItem(item, nestingLevel, layoutDirection: LayoutDirection.horizontal));
        }).toList(),
      );
      return withLabel(context, label, row);
    });
  }

  /// generates a vertical layout with the elements in a column
  Widget _generateVerticalLayout(ui.Layout item, int nestingLevel) {
    final elements = item.elements;
    final label = item.options?.label;
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements.map((item) {
        return _generateItem(item, nestingLevel, layoutDirection: LayoutDirection.vertical);
      }).toList(),
    );
    return withLabel(context, label, column);
  }

  /// generates an Layoutelement based on the type of the element
  Widget _generateItem(ui.LayoutElement item, int nestingLevel, {bool? isShownFromParent, LayoutDirection? layoutDirection}) {
    Widget child;

    switch (item.type) {
      case ui.LayoutElementType.BUTTON:
        return _generateButtonControl(ui.Button.fromJson(item.toJson()));
      case ui.LayoutElementType.BUTTONGROUP:
        return _generateButtonGroupControl(ui.Buttongroup.fromJson(item.toJson()));
      case ui.LayoutElementType.CONTROL:
        child = _generateControl(ui.Control.fromJson(item.toJson()), nestingLevel, isShownFromParent: isShownFromParent);
      case ui.LayoutElementType.DIVIDER:
        child = _generateDivider(ui.Divider.fromJson(item.toJson()));
      case ui.LayoutElementType.GROUP:
        child = _generateGroupFromLayoutElement(ui.Layout.fromJson(item.toJson()), nestingLevel + 1);
      case ui.LayoutElementType.HORIZONTAL_LAYOUT:
        child = _generateHorizontalLayout(ui.Layout.fromJson(item.toJson()), nestingLevel + 1);
      case ui.LayoutElementType.HTML:
        child = _generateHtml(ui.HtmlRenderer.fromJson(item.toJson()));
      case ui.LayoutElementType.VERTICAL_LAYOUT:
        child = _generateVerticalLayout(ui.Layout.fromJson(item.toJson()), nestingLevel + 1);
      case null:
        child = getNotImplementedWidget("No type defined for LayoutElementType $item");
    }

    return applyCss(
      context,
      handleShowOn(
          showOn: item.showOn,
          child: child,
          ritaDependencies: _ritaDependencies,
          ritaEvaluator: ritaRuleEvaluator,
          checkValueForShowOn: checkValueForShowOn,
          layoutDirection: layoutDirection),
      cssClass: item.options?.cssClass,
    );
  }

  /// generates a button group control based on the type of the button group
  Widget _generateButtonGroupControl(ui.Buttongroup element) {
    if (element.options?.vertical != null && element.options!.vertical!) {
      return Column(
        children: element.buttons.map((item) {
          return _generateButtonControl(item);
        }).toList(),
      );
    } else {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: element.buttons.map((item) {
          return _generateButtonControl(item);
        }).toList(),
      );
    }
  }

  /// Renders a styled button based on the provided variant
  Widget renderStyledButton({
    required BuildContext context,
    required ui.ColorVariant? variant,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;

    // Map enum to color and style
    late final Color color;
    late final bool isOutline;
    late final bool isLight;

    switch (variant) {
      case ui.ColorVariant.PRIMARY:
        color = scheme.primary;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.SECONDARY:
        color = scheme.secondary;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.SUCCESS:
        color = Colors.green;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.WARNING:
        color = Colors.orange;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.DANGER:
        color = scheme.error;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.INFO:
        color = Colors.blue;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.LIGHT:
        color = scheme.surfaceContainerHighest;
        isOutline = false;
        isLight = true;
        break;
      case ui.ColorVariant.DARK:
        color = Colors.black87;
        isOutline = false;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_PRIMARY:
        color = scheme.primary;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_SECONDARY:
        color = scheme.secondary;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_SUCCESS:
        color = Colors.green;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_WARNING:
        color = Colors.orange;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_DANGER:
        color = scheme.error;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_INFO:
        color = Colors.blue;
        isOutline = true;
        isLight = false;
        break;
      case ui.ColorVariant.OUTLINE_LIGHT:
        color = scheme.surfaceContainerHighest;
        isOutline = true;
        isLight = true;
        break;
      case ui.ColorVariant.OUTLINE_DARK:
        color = Colors.black87;
        isOutline = true;
        isLight = false;
        break;
      case null:
        color = scheme.primary;
        isOutline = false;
        isLight = false;
        break;
    }

    if (isOutline) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
        ),
        onPressed: onPressed,
        child: child,
      );
    } else {
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: isLight ? Colors.black : Colors.white,
        ),
        onPressed: onPressed,
        child: child,
      );
    }
  }

  /// Generates a button control based on the provided button configuration
  Widget _generateButtonControl(ui.Button button) {
    final formNoValidate = button.options?.formnovalidate ?? false;
    final submitOptions = button.options?.submitOptions;

    String getMethod(ui.Method? method) {
      switch (method) {
        case ui.Method.GET:
          return 'GET';
        case ui.Method.POST:
          return 'POST';
        case ui.Method.PUT:
          return 'PUT';
        case ui.Method.DELETE:
          return 'DELETE';
        case null:
          return 'POST';
      }
    }

    Future<void> handleSubmit() async {
      // If formnovalidate is true, skip validation
      bool valid = formNoValidate ? true : saveAndValidate();

      if (!valid) return;

      final action = submitOptions?.action ?? 'submit';

      switch (action) {
        case 'request':
          final request = submitOptions?.request;
          if (request != null) {
            final url = Uri.parse(request.url);

            final method = getMethod(request.method);
            final headers = request.headers;
            final body = jsonEncode(value);

            http.Response response;
            switch (method) {
              case 'GET':
                response = await http.get(url, headers: headers);
                break;
              case 'POST':
                response = await http.post(url, headers: headers, body: body);
                break;
              case 'PUT':
                response = await http.put(url, headers: headers, body: body);
                break;
              case 'DELETE':
                response = await http.delete(url, headers: headers, body: body);
                break;
              default:
                throw Exception('Unsupported HTTP method: $method');
            }
            // You can handle the response here, e.g., show a snackbar or call a callback
            debugPrint('Request response: ${response.statusCode} ${response.body}');
          }
          break;
        case 'save':
          // Implement your save logic here
          debugPrint('Save action: ${jsonEncode(value)}');
          break;
        case 'print':
          // Implement your print logic here
          debugPrint('Print action: ${jsonEncode(value)}');
          break;
        default:
          // Default submit: just validate and do nothing else
          debugPrint('Default submit: ${jsonEncode(value)}');
      }
    }

    VoidCallback? onPressed;
    switch (button.buttonType) {
      case ui.TheButtonsType.RESET:
        onPressed = reset;
        break;
      case ui.TheButtonsType.SUBMIT:
        onPressed = handleSubmit;
        break;
    }

    return renderStyledButton(
      context: context,
      variant: button.options?.variant,
      onPressed: onPressed,
      child: Text(button.text),
    );
  }

  /// renders a simple Divider Widget
  Divider _generateDivider(ui.Divider item) {
    return const Divider();
  }

  /// renders the HTML data in the UI schema
  CustomHtmlWidget _generateHtml(ui.HtmlRenderer item) {
    return CustomHtmlWidget(
      htmlData: item.htmlData,
    );
  }

  /// generates a control element based on the type of the property
  /// TODO use typing here for the referenced elements in schema.json
  Widget _generateControl(ui.Control item, int nestingLevel, {bool? isShownFromParent}) {
    String scope = item.scope.startsWith("#") ? item.scope.substring(1) : item.scope;
    final ui.ControlOptions? options = item.options;
    final JsonSchema? jsonSchemaFromScope = _getJsonSchemaFromScope(scope);
    if (jsonSchemaFromScope == null) {
      return _getErrorTextWidget("Control element must have a valid scope. Scope $scope not found in json schema.");
    }

    final format = item.options?.fieldSpecificOptions?.format;
    // dynamic formDataForScope = _getObjectFromJsonFormData;
    // if isShownFromParent == false then the field is not shown
    // if isShownFromParent == true or not set, check if showOn condition exists. If so, evaluate it
    // bool isShown = isShownFromParent == false ? false : item.showOn == null ? true : _evaluateCondition(item.showOn!.type, checkValueForShowOn(item.showOn!.scope), item.showOn!.referenceValue);

    final bool parentIsShown = isShownFromParent ?? true;

    // Helper for this control's visibility
    bool isShown() => isElementShown(
          parentIsShown: parentIsShown,
          showOn: item.showOn,
          ritaDependencies: _ritaDependencies,
          checkValueForShowOn: checkValueForShowOn,
        );

    return FormElementFormControl(
      options: options,
      format: format,
      scope: scope,
      id: scope,
      nestingLevel: nestingLevel + 1,
      required: _isRequired(jsonSchemaModel, scope),
      jsonSchema: jsonSchemaFromScope,
      initialValue: checkValueForShowOn(scope),
      isShownCallback: isShown,
      onChanged: (value) async {
        setValueForShowOn(scope, value);
        final ritaDependencies = await ritaRuleEvaluator.evaluateAll(jsonEncode(toEncodable(processFormValuesEllaV2(_showOnDependencies))));
        setState(() {
          _ritaDependencies = ritaDependencies;
          setValueForShowOn(scope, value);
        });
      },
      // formDataForScope, // TODO: rita rule evaluation
      onSavedCallback: (value) {
        if (value != null && value != "" && isShown()) {
          _formSubmitValues[scope] = value;
        } else {
          _formSubmitValues.remove(scope);
        }
      },
      parentIsShown: parentIsShown,
      ritaDependencies: _ritaDependencies,
      checkValueForShowOn: checkValueForShowOn,
      showOn: item.showOn,
      // Rita/selfIndices support
      ritaEvaluator: ritaRuleEvaluator,
      getFullFormData: () => processFormValuesEllaV2(_showOnDependencies),
      selfIndices: const {},
    );
  }

  /// gets an object from the jsonSchema
  /// [path] the path of the object in the json schema
  JsonSchema? _getJsonSchemaFromScope(String path) {
    JsonSchema? object = getObjectFromJson(jsonSchemaModel, path);
    return object;
  }

  /// gets a value for a showOn condition
  /// [path] the path of the object in the json schema
  /// returns the value if it is set, otherwise null
  /// it doesn't matter if the path starts with a # or not
  dynamic checkValueForShowOn(String path) {
    return _showOnDependencies[getPathWithProperties(path)]; //  ?? (path.startsWith("#") ? _showOnDependencies[path.substring(1)] : null);
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

  Text _getErrorTextWidget(String message) {
    return Text(
      "Error: $message",
      style: const TextStyle(color: Colors.red),
    );
  }

  Text getNotImplementedWidget(String type) {
    return Text(
      "TODO implement $type",
      style: const TextStyle(color: Colors.red),
    );
  }
}
