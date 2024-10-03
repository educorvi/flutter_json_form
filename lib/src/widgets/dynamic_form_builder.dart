import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../../flutter_json_forms.dart';
import 'form_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:json_schema/json_schema.dart';
import 'package:flutter_json_forms/src/json_validator.dart';
import '../constants.dart';
import '../models/json_schema.dart';
import '../models/ui_schema.dart';

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

  /// The required fields of the JSON schema which are marked as required and needed so the form can be submitted successfully
  late final List<String> _requiredFields;

  /// The properties of the JSON schema which are used to generate the form fields
  late final Map<String, dynamic> _properties;

  /// The validation errors of the JSON and UI schema
  List<ValidationError>? _jsonSchemaValidationErrors;
  List<ValidationError>? _uiSchemaValidationErrors;

  /// TODO only validate form (json and ui schema) once and then store its hash and validate it only if it is unknown

  /// Singleton instances of the JSON and UI meta schemas
  // JsonSchema jsonMetaSchema = getJsonSchema<JsonSchema>();
  // JsonSchema uiMetaSchema = getUiSchema<JsonSchema>();
  JsonSchema jsonMetaSchema = getSchemas<(JsonSchema, JsonSchema)>().$1;
  JsonSchema uiMetaSchema = getSchemas<(JsonSchema, JsonSchema)>().$2;

  /// model classes for the JSON and UI schema
  late final JsonSchemaModel jsonSchemaModel;
  late final UiSchemaModel uiSchemaModel;

  /// The dependencies of the form fields which are dependent on other fields
  final Map<String, dynamic> _showOnDependencies = {};

  final Map<String, dynamic> _formSubmitValues = {};

  late final Map<String, dynamic> formData;

  /// return true if the widget is in the loading state (the validation is not finished yet
  /// (async part comes form reading the files. The validation is done synchronously))
  get isLoading {
    return _jsonSchemaValidationErrors == null || _uiSchemaValidationErrors == null;
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
  initState() {
    super.initState();
    if (widget.formData != null) {
      // _formKey.currentState?.patchValue(widget.formData!);
      formData = widget.formData!;
    }
    // parse and validate the json Schema
    final Map<String, dynamic> jsonSchemaMap = _getMap(widget.jsonSchema, "jsonSchema");
    if (widget.validate && !_validateJsonSchema(jsonSchemaMap)) {
      return;
    }
    jsonSchemaModel = JsonSchemaModel.fromJson(jsonSchemaMap);
    _requiredFields = jsonSchemaModel.required ?? [];
    _properties = jsonSchemaModel.properties ?? {};

    // parse and validate the ui Schema
    if (widget.uiSchema == null) {
      uiSchemaModel = _generateDefaultUISchema();
    } else {
      final Map<String, dynamic> uiSchemaMap = _getMap(widget.uiSchema, "uiSchema");
      if (widget.validate && !_validateUiSchema(uiSchemaMap)) {
        return;
      }
      uiSchemaModel = UiSchemaModel.fromJson(uiSchemaMap);
    }

    // initialize the _showOnDependencies with the default values in order
    // to correctly render form field which are dependent on other fields
    _initShowOnDependencies(_properties, "/properties");
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
  bool saveAndValidate() {
    return _formKey.currentState!.saveAndValidate();
  }

  /// Reset form to `initialValue`
  void reset() {
    setState(() {
      formData.clear();
      for (String key in _showOnDependencies.keys) {
        _showOnDependencies[key] = null;
      }
      // _showOnDependencies.clear();
      _initShowOnDependencies(_properties, "/properties");
      _formKey.currentState!.patchValue(_showOnDependencies);
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

  /// generates a default UI schema which shows all fields of the JSON schema
  /// The Layout Type is a vertical one and for each element a Control Element with the scope of the JSON Schema Element is created
  UiSchemaModel _generateDefaultUISchema() {
    // generates the default UI schema elements based on the properties of the JSON schema
    List<LayoutElement> generateDefaultUISchemaElements(Map<String, dynamic> properties, {String path = ""}) {
      List<LayoutElement> elements = [];
      for (String key in properties.keys) {
        final element = properties[key];
        if (element["type"] == "object") {
          elements.add(LayoutElement(
            type: LayoutElementType.GROUP,
            elements: generateDefaultUISchemaElements(element['properties'], path: "$path/$key/properties"),
            label: key,
          ));
        } else {
          elements.add(LayoutElement(
            type: LayoutElementType.CONTROL,
            scope: "$path/$key",
          ));
        }
      }
      return elements;
    }

    // traverse the json schema and generate a default ui schema. This schema has a control element for every element in the json schema
    return UiSchemaModel(
      layout: Layout(
        type: LayoutType.VERTICAL_LAYOUT,
        elements: generateDefaultUISchemaElements(_properties, path: "/properties"),
      ),
      version: '2.0',
    );
  }

  /// [instance] can be a Map<String, dynamic> or a String
  /// if the instance is a String and [parseJson] is true, the instance is parsed to a Map<String, dynamic>
  /// if [parseJson] is false, the instance is used as is
  _getMap(dynamic instance, String argumentName) {
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

  /// initialize _showDependencies with the default values
  /// this function gets called recursively for objects in the jsonSchema which are nested into each other
  void _initShowOnDependencies(Map<String, dynamic>? properties, String path) {
    if (properties == null) return;
    for (String key in properties.keys) {
      final element = properties[key];
      // set default values for fields. If a form data is provided, use this
      if (formData.containsKey("$key")) {
        _showOnDependencies["$path/$key"] = formData[key];
      } else if (element.containsKey('default')) {
        // check if the jsonSchema defines a default value for the field
        _showOnDependencies["$path/$key"] = element["default"];
      }
      if (element["type"] == "object") {
        _initShowOnDependencies(element['properties'], "$path/$key/properties");
      }
    }
  }

  /// Validates the JSON schema against the JSON meta schema
  /// sets the validation errors in the state
  /// if the validation is successful, the jsonSchema is set
  bool _validateJsonSchema(Map<String, dynamic> jsonSchemaMap) {
    // widget.jsonSchema["properties"]= widget.jsonSchema["definitions"];
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
    // check version
    final versionString = uiSchemaMap["version"];
    if (versionString == null) {
      // setState(() {
      //   _uiSchemaValidationErrors = [ValidationError("The UI schema must have a version of 2.0 or higher")];
      // });
      return false;
    } else if (versionString is String) {
      final version = double.tryParse(versionString);
      if (version == null || version < 2.0) {
        // setState(() {
        //   _uiSchemaValidationErrors = ValidationResults("")[ValidationError("The UI schema must have a version of 2.0 or higher")];
        // });
        return false;
      }
    }
    // check uiSchema against meta Schema
    // widget.uiSchema["type"]="asA";
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

  /// Returns the FormBuilder widget with the form fields and submit buttons
  FormBuilder _getFormBuilder() {
    return FormBuilder(
      // initialValue: widget.formData ?? {},
      key: _formKey,
      child: _generateForm(),
      // child: Column(
      //   children: [
      //     _generateForm(),
      //     // TODO make this adjustable. Allow a custom widget to be given here or to defined custom buttons with submit callbacks (e.g. provide name, style, icon and a callback function)
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         FilledButton.tonal(
      //           onPressed: () {
      //             _formKey.currentState?.reset();
      //           },
      //           child: const Row(
      //             children: [
      //               Icon(Icons.refresh),
      //               SizedBox(width: 10),
      //               Text('Zurücksetzen'),
      //             ],
      //           ),
      //         ),
      //         const SizedBox(width: 20),
      //         FilledButton(
      //           onPressed: () {
      //             if (_formKey.currentState?.saveAndValidate() == true) {
      //               if (widget.onFormSubmit != null) {
      //                 Map<String, dynamic> formValues;
      //                 switch (widget.onFormSubmitFormat) {
      //                   case OnFormSubmitFormat.formBuilder:
      //                     formValues = _formKey.currentState!.value;
      //                     break;
      //                   case OnFormSubmitFormat.ellaV1:
      //                     formValues = processFormValuesEllaV1(_formKey.currentState!.value);
      //                     break;
      //                   case OnFormSubmitFormat.ellaV2:
      //                     formValues = processFormValuesEllaV2(_formKey.currentState!.value);
      //                     break;
      //                 }
      //                 widget.onFormSubmit!(formValues);
      //               }
      //             }
      //             // // On another side, can access all field values without saving form with instantValues
      //             // _formKey.currentState?.validate();
      //             // debugPrint(_formKey.currentState?.instantValue.toString());
      //           },
      //           child: const Row(children: [
      //             Icon(Icons.send),
      //             SizedBox(width: 10),
      //             Text('Absenden'),
      //           ]),
      //         ),
      //       ],
      //     )
      //   ],
      // ),
    );
  }

  /// Generates the form fields based on the elements of the UI schema
  Widget _generateForm() {
    return _generateLayout(uiSchemaModel.layout);
  }

  /// generates a layout based on the type of the layout
  Widget _generateLayout(Layout layout) {
    LayoutType type = layout.type;
    switch (type) {
      case LayoutType.VERTICAL_LAYOUT:
        return _generateVerticalLayout(layout.elements);
      case LayoutType.HORIZONTAL_LAYOUT:
        return _generateHorizontalLayout(layout.elements);
      case LayoutType.GROUP:
        return _generateGroup(layout as LayoutElement);
    }
  }

  /// generates a group of elements with an optional label at the top
  Widget _generateGroup(LayoutElement item) {
    List<LayoutElement> elements = item.elements!;
    String? label = item.label;

    bool? isShown = item.showOn == null ? null : _evaluateCondition(item.showOn!.type, _showOnDependencies[item.showOn!.scope], item.showOn!.referenceValue);

    ListView generateGroupElements() {
      // return Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: UIConstants.groupPadding),
      //   child: Column(
      //     children: elements
      //         .map((item) => Padding(
      //               padding: EdgeInsets.only(
      //                   top: item == elements.first ? 0 : UIConstants.groupItemPadding,
      //                   bottom: item == elements.last ? 0 : UIConstants.groupItemPadding),
      //               child: _generateItem(item),
      //             ))
      //         .toList(),
      //   ),
      // );
      return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: UIConstants.groupPadding),
        itemCount: elements.length,
        itemBuilder: (BuildContext context, int index) {
          return _generateItem(elements[index], isShownFromParent: isShown);
        },
        separatorBuilder: (BuildContext context, int index) {
          // return _handleShowOn(elements[index].showOn, const SizedBox(height: UIConstants.verticalLayoutItemPadding));
          return const SizedBox(height: UIConstants.verticalLayoutItemPadding);
        },
      );
    }

    return Card.outlined(
        child: Padding(
      padding: const EdgeInsets.all(UIConstants.groupPadding),
      child: label != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: UIConstants.groupTitleSpacing),
                generateGroupElements(),
              ],
            )
          : generateGroupElements(),
    ));

    // if (label != null) {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         label,
    //         style: Theme.of(context).textTheme.titleLarge,
    //       ),
    //       const SizedBox(height: UIConstants.groupTitleSpacing),
    //       generateGroupElements(),
    //     ],
    //   );
    // } else {
    //   return generateGroupElements();
    // }
  }

  /// generates a horizontal layout with the elements in a row. A Wrap is used to warp the elements around
  /// if they need more horizontal space than available
  LayoutBuilder _generateHorizontalLayout(List<LayoutElement> elements) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Wrap(
          // make elements align left and right (space between)
          alignment: WrapAlignment.spaceBetween,
          spacing: UIConstants.horizontalLayoutItemPadding,
          runSpacing: UIConstants.verticalLayoutItemPadding,
          children: elements.map((item) {
            return _generateItem(item);
          }).toList());
    });
  }

  /// generates a vertical layout with the elements in a column
  ListView _generateVerticalLayout(List<LayoutElement> elements) {
    // return Column(
    //   children: elements
    //       .map((item) => Padding(
    //               padding: EdgeInsets.only(top: item == elements.first ? 0 : UIConstants.verticalLayoutItemPadding, bottom: item == elements.last ? 0 : UIConstants.verticalLayoutItemPadding),
    //               child: _generateItem(item),
    //             ))
    //       .toList(),
    // );
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: elements.length,
      itemBuilder: (BuildContext context, int index) {
        return _generateItem(elements[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        // return Container();
        return _handleShowOn(elements[index].showOn, const SizedBox(height: UIConstants.verticalLayoutItemPadding));
      },
    );
  }

  /// generates an layoutElement based on the type of the element
  Widget _generateItem(LayoutElement item, {bool? isShownFromParent}) {
    LayoutElementType? type = item.type;
    Widget child;
    switch (type) {
      case LayoutElementType.BUTTON:
        return _generateButtonControl(item as Button);
      case LayoutElementType.BUTTONGROUP:
        return _generateButtonGroupControl(item);
      case LayoutElementType.CONTROL:
        child = _generateControl(item, isShownFromParent: isShownFromParent);
      case LayoutElementType.DIVIDER:
        child = _generateDivider(item);
      case LayoutElementType.GROUP:
        child = _generateGroup(item);
      case LayoutElementType.HORIZONTAL_LAYOUT:
        child = _generateHorizontalLayout(item.elements!);
      case LayoutElementType.HTML:
        child = _generateHtml(item);
      case LayoutElementType.VERTICAL_LAYOUT:
        child = _generateVerticalLayout(item.elements!);
      case null:
        child = getNotImplementedWidget("Null type");
    }
    // return child;
    return _handleShowOn(item.showOn, child);
  }

  /// handles the visibility of an element based on the showOn property.
  /// Uses the _evaluateCondition function to evaluate the condition
  Widget _handleShowOn(ShowOnProperty? showOn, Widget child) {
    if (showOn == null) {
      return child;
    } else {
      bool isVisible = _evaluateCondition(showOn.type, _showOnDependencies[showOn.scope], showOn.referenceValue);
      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        sizeCurve: Curves.easeInOut,
        firstChild: child,
        secondChild: Container(),
        // Invisible child
        crossFadeState: isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      );
    }
  }

  /// generates a button group control based on the type of the button group
  Widget _generateButtonGroupControl(LayoutElement element) {
    if (element.vertical != null && element.vertical!) {
      return Column(
        children: element.buttons!.map((item) {
          return _generateButtonControl(item);
        }).toList(),
      );
    } else {
      return Wrap(
        children: element.buttons!.map((item) {
          return _generateButtonControl(item);
        }).toList(),
      );
    }
  }

  /// generates a button control based on the type of the button
  Widget _generateButtonControl(Button button) {
    // TODO: I dont get variant here, this most likely is an error with the generated type. Adjust the parsing process
    // if(button.options.nativeSubmitOptions.
    return FilledButton(
      onPressed: () {
        switch (button.buttonType) {
          case TheButtonsType.RESET:
            _formKey.currentState?.reset();
          case TheButtonsType.SUBMIT:
            _formKey.currentState?.saveAndValidate();
        }
        _formKey.currentState?.reset();
      },
      child: Text(button.text),
    );
  }

  /// renders a simple Divider Widget
  Divider _generateDivider(LayoutElement item) {
    return const Divider();
  }

  /// renders the HTML data in the UI schema
  HtmlWidget _generateHtml(LayoutElement item) {
    return HtmlWidget(
      enableCaching: true,
      item.htmlData!,
      onTapUrl: (url) async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          print('Could not launch $url');
        }
        return true;
      },
      renderMode: const ListViewMode(shrinkWrap: true, physics: ClampingScrollPhysics()),
    );
  }

  /// evaluates the condition based on the operator and the operands
  bool _evaluateCondition(ShowOnFunctionType operator, dynamic operand1, dynamic operand2) {
    // TODO as the types are dynamic, type error could occur here. Use stronger typing if possible!
    // maybe try to do the check and if an exception occurs, render an error in the ui
    switch (operator) {
      case ShowOnFunctionType.EQUALS:
        return operand1 == operand2;
      case ShowOnFunctionType.GREATER:
        return operand1 > operand2;
      case ShowOnFunctionType.SMALLER:
        return operand1 < operand2;
      case ShowOnFunctionType.GREATER_OR_EQUAL:
        return operand1 >= operand2;
      case ShowOnFunctionType.SMALLER_OR_EQUAL:
        return operand1 <= operand2;
      case ShowOnFunctionType.NOT_EQUALS:
        return operand1 != operand2;
      case ShowOnFunctionType.LONGER:
        return operand1.length > operand2;
    }
  }

  /// generates a control element based on the type of the property
  /// TODO use typing here for the referenced elements in schema.json
  Widget _generateControl(LayoutElement item, {bool? isShownFromParent}) {
    if (item.scope == null) {
      return _getErrorTextWidget("Control element must have a scope");
    }
    final String scope = item.scope!;
    final LayoutElementOptions? options = item.options;
    final Map<String, dynamic>? property = _getObjectFromJsonSchema(scope);
    if (property == null) {
      return _getErrorTextWidget("Control element must have a valid scope. Scope $scope not found in json schema.");
    }
    // dynamic formDataForScope = _getObjectFromJsonFormData;

    bool isShown = isShownFromParent ?? item.showOn == null || _evaluateCondition(item.showOn!.type, _showOnDependencies[item.showOn!.scope], item.showOn!.referenceValue);

    return FormElementFormControl(
      options: options,
      scope: scope,
      isShown: isShown,
      required: _isRequired(scope) && isShown,
      // only evaluate the second expression if the field is required and the field has a showOn condition
      onChanged: (value) {
        setState(() {
          _showOnDependencies[scope] = value;
        });
      },
      property: property,
      initialValue: _showOnDependencies[scope],
      // formDataForScope,
      onSavedCallback: (value) {
        if (isShown && value != null && value != "") {
          _formSubmitValues[scope] = value;
        } else {
          _formSubmitValues.remove(scope);
        }
      },
    );
  }

  dynamic _getObjectFromJsonFormData(String path) {
    if (formData.isEmpty) {
      return null;
    }
    return _getObjectFromJson(formData, path);
  }

  /// gets an object from the jsonSchema
  /// [path] the path of the object in the json schema
  Map<String, dynamic>? _getObjectFromJsonSchema(String path) {
    dynamic object = _getObjectFromJson(_properties, path);
    if (object is! Map<String, dynamic>?) {
      return null;
    }
    return object;
  }

  /// gets an object from a json
  /// [path] the path of the object in the json
  /// [json] the json object
  dynamic _getObjectFromJson(
    Map<String, dynamic> json,
    String path,
  ) {
    List<String> pathParts = _getPathWithoutPrefix(path).split('/');
    dynamic object = json;
    try {
      for (String part in pathParts) {
        object = object[part];
      }
    } catch (e) {
      return null;
    }
    return object;
  }

  /// checks if a field is required
  /// [path] the path of the field in the json schema
  bool _isRequired(String path) {
    return _requiredFields.contains(_getPathWithoutPrefix(path));
  }

  /// get path without prefix /properties or #/properties
  String _getPathWithoutPrefix(String path) {
    const prefixes = ['/properties/', '#/properties/'];
    for (String prefix in prefixes) {
      if (path.startsWith(prefix)) {
        return path.substring(prefix.length);
      }
    }
    return path;
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
