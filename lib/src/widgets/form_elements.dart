import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/ritaRuleEvaluator.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:flutter_json_forms/src/utils/validators/validators.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/animated_tooltip.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/html_widget.dart';
import 'package:flutter_json_forms/src/widgets/shared_widgets.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:json_schema/json_schema.dart';

import '../constants.dart';
import '../models/ui_schema.dart' as ui;
import 'custom_form_fields/form_builder_segmented_button.dart';
import 'data/list_item.dart';

class FormElementFormControl extends StatefulWidget {
  final ui.ControlOptions? options;
  final ui.Format? format;
  final String scope;
  final String id;
  final JsonSchema jsonSchema;
  final bool required;
  final void Function(dynamic)? onChanged;
  final bool Function() isShownCallback;
  final dynamic initialValue;
  final int nestingLevel;
  final bool? parentIsShown;
  final Map<String, bool>? ritaDependencies;
  final dynamic Function(String path) checkValueForShowOn;
  final ui.ShowOnProperty? showOn;
  final Map<String, int>? selfIndices;
  final RitaRuleEvaluator? ritaEvaluator;
  final Map<String, dynamic> Function()? getFullFormData;

  // final bool isShown;

  // used for array elements which should not generate a label
  final bool showLabel;
  final void Function(dynamic)? onSavedCallback;

  const FormElementFormControl(
      {super.key,
      this.options,
      required this.scope,
      required this.required,
      this.onChanged,
      required this.jsonSchema,
      this.initialValue,
      // required this.isShown,
      this.onSavedCallback,
      this.showLabel = true,
      required this.isShownCallback,
      this.format,
      required this.nestingLevel,
      required this.id,
      this.parentIsShown,
      this.ritaDependencies,
      required this.checkValueForShowOn,
      this.showOn,
      this.selfIndices,
      this.ritaEvaluator,
      this.getFullFormData});

  @override
  State<FormElementFormControl> createState() => _FormElementFormControlState();
}

class _FormElementFormControlState extends State<FormElementFormControl> {
  late final String? title;
  late final String? description;
  late final SchemaType? type;
  late final ui.ControlOptions? options;
  late final ui.Format? format;
  late final String scope;
  late final JsonSchema jsonSchema;
  late final bool required;
  late final bool label;
  late final String? placeholder;
  late final bool enabled;
  late dynamic initialValue;
  late final void Function(dynamic)? onChanged;
  late final bool Function() isShownCallback;
  late final void Function(dynamic)? onSavedCallback;

  final bool labelSeparateText = true;

  @override
  void initState() {
    options = widget.options;
    format = widget.format;
    scope = widget.scope;
    jsonSchema = widget.jsonSchema;
    required = widget.required;
    onChanged = widget.onChanged;
    isShownCallback = widget.isShownCallback;
    title = jsonSchema.title; // ?? _getNameFromPath(scope);
    label = options?.formattingOptions?.label ?? true;
    description = jsonSchema.description;
    try {
      type = jsonSchema.type;
    } catch (e) {
      type = null;
    }
    placeholder = options?.formattingOptions?.placeholder;
    enabled = true; // options?.disabled != true;
    initialValue = widget.initialValue ?? jsonSchema.defaultValue;
    // on saved should only be called when the element is shown
    onSavedCallback = (dynamic value) {
      if (widget.onSavedCallback != null && isShownCallback()) {
        widget.onSavedCallback!(value);
      }
    };
    if (widget.initialValue is Map<String, dynamic>) {
      // print("initialValue is Map<String, dynamic>, this should be a object");
      _showOnDependencies = widget.initialValue;
    } else if (widget.initialValue is List) {
      // print("initialValue is List, this should be a array");
      // _showOnDependencies = widget.initialValue;
    } else {
      _showOnDependencies = {};
      // print("neither a object nor a array");
    }
    // _showOnDependencies = widget.initialValue is Map<String, dynamic> || ? widget.initialValue : {};
    super.initState();
  }

  // Array
  List<ListItem> items = [];
  bool itemsInitialized = false;
  int _idCounter = 0;

  // Object
  final Map<String, dynamic> formSubmitValues = {};
  late final Map<String, dynamic> _showOnDependencies;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    switch (type) {
      case SchemaType.string:
        child = _generateStringControl();
      case SchemaType.integer || SchemaType.number:
        child = _generateIntegerControl();
      case SchemaType.boolean:
        child = _generateBooleanControl();
      case SchemaType.array:
        child = _generateArrayControl();
      case SchemaType.object:
        child = _generateObject();
      default: // TODO: number and null missing
        child = _getErrorTextWidget("Not implemented");
    }
    if (options?.formattingOptions?.hidden == true) {
      // TODO: this results in a small additional gap in the ui
      return Visibility(
        maintainState: true,
        visible: false,
        child: child,
      );
    } else {
      return child;
    }
  }

  /// handles the generation of string elements in the jsonSchema
  Widget _generateStringControl() {
    if (jsonSchema.enumValues?.isNotEmpty ?? false) {
      List<String> values = [];
      for (var item in jsonSchema.enumValues!) {
        if (item is String) {
          values.add(item);
        } else {
          try {
            values.add(item.toString());
          } catch (e) {
            // TODO: Handle error
            print(e);
          }
        }
      }
      switch (options?.fieldSpecificOptions?.displayAs) {
        case ui.DisplayAs.RADIOBUTTONS:
          return generateRadioGroup(values);
        case ui.DisplayAs.SWITCHES:
          return generateSegmentedControl(values);
        case ui.DisplayAs.SELECT:
          return generateDropdown(values);
        case ui.DisplayAs.BUTTONS:
          return generateSegmentedControl(values);
        case null:
          return generateDropdown(values);
      }
    } else if (jsonSchema.format == 'date-time' || format == ui.Format.DATETIME_LOCAL) {
      return generateDateTimePicker(InputType.both);
    } else if (jsonSchema.format == 'date' || format == ui.Format.DATE) {
      return generateDateTimePicker(InputType.date); // TODO adjust timepicker
    } else if (jsonSchema.format == 'time' || format == ui.Format.TIME) {
      return generateDateTimePicker(InputType.time); // TODO adjust timepicker
    } else if (jsonSchema.format == 'uri') {
      return generateFilePicker();
    } else {
      // type is string
      if (jsonSchema.format == 'color' || format == ui.Format.COLOR) {
        return generateColorPicker();
      }
      return generateTextField();
    }
  }

  /// handles the generation of integer elements in the jsonSchema
  Widget _generateIntegerControl() {
    if (options?.fieldSpecificOptions?.range == true) {
      return generateSlider();
    }
    // if(options?.displayAs == DisplayAs.RATING) return generateRating();
    // TODO differentiate between rating and normal integer
    // return generateRating();
    return generateTextField();
  }

  /// handles the generation of boolean elements in the jsonSchema
  Widget _generateBooleanControl() {
    return generateSwitch();
  }

  /// handles the generation of array elements in the jsonSchema
  Widget _generateArrayControl() {
    if (jsonSchema.items != null) {
      late final type;
      try {
        type = jsonSchema.items!.type;
      } catch (e) {
        return _getErrorTextWidget(e.toString());
        // Handle error
      }
      if (type != SchemaType.object && type != SchemaType.array && jsonSchema.items!.enumValues?.isNotEmpty == true) {
        List<String> values = [];
        for (var item in jsonSchema.items!.enumValues!) {
          values.add(item);
        }
        return generateCheckboxGroup(values);
      }
    }
    if (jsonSchema.enumValues?.isNotEmpty ?? false) {
      List<String> values = [];
      for (var item in jsonSchema.enumValues!) {
        values.add(item);
      }
      return generateCheckboxGroup(values);
    }
    // if (jsonSchema.items != null) {
    //   final type = jsonSchema.items!.type;
    //   if (type != SchemaType.object && type != SchemaType.array && jsonSchema.items!.enumValues != null) {
    //     List<String> values = [];
    //     for (var item in jsonSchema.items!.enumValues!) {
    //       values.add(item);
    //     }
    //     return generateCheckboxGroup(values);
    //   }
    // }
    if (options?.fieldSpecificOptions?.tags?.enabled == true) {
      // TODO implement variants and proper tags support
      return generateTextField();
    }

    if (!itemsInitialized) {
      itemsInitialized = true;
      // initialize items with default value
      if (initialValue != null) {
        if (initialValue is! List) {
          // print("initialValue is not a List, but should be for an array");
          // return _getNotImplementedWidget();
          initialValue = [];
        }
        for (dynamic item in initialValue) {
          items.add(ListItem<dynamic>(id: _idCounter, value: item));
          _idCounter++;
        }
      } else {
        int minItems = safeParseInt(jsonSchema.minItems);
        for (int i = 0; i < minItems; i++) {
          items.add(ListItem<dynamic>(id: _idCounter++, value: null));
        }
      }
      // if (widget.initialValue is List){
      //   List<dynamic> initialValueList= widget.initialValue;
      //   initialValueList.clear();
      //   for (var item in items) {
      //     initialValueList.add(item);
      //   }
      // }
    }
    // generate an array with string elements
    return _getArrayWidget();
    // if (type == 'string') {
    //   return _getArrayWidget();
    // } else if (type == 'integer') {
    //   return _getNotImplementedWidget();
    // } else if (type == 'boolean') {
    //   return _getNotImplementedWidget();
    // } else if (type == 'object') {
    //   return _getNotImplementedWidget();
    // } else {
    //   return _getNotImplementedWidget();
    // }
  }

  // TODO: put this in an extra file and also allow to next object and other arrays within arrays and not only primitive types
  Widget _getArrayWidget() {
    void addItem() {
      setState(() {
        _idCounter++;
        items.add(ListItem<dynamic>(id: _idCounter, value: null));
      });
    }

    void removeItem(int index) {
      setState(() {
        items.removeAt(index);
      });
    }

    // Compute array container shown-state once, and propagate to children
    // bool arrayIsShown() => isElementShown(
    //       parentIsShown: widget.isShownCallback(),
    //       showOn: widget.showOn,
    //       ritaDependencies: widget.ritaDependencies,
    //       checkValueForShowOn: widget.checkValueForShowOn,
    //     );
    // Use the already computed shown-state for this container
    bool arrayIsShown() => widget.isShownCallback();

    int? maxItems = trySafeParseInt(jsonSchema.maxItems);
    int minItems = safeParseInt(jsonSchema.minItems);

    final labelString = _getLabel();

    Widget arrayWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelString != null)
          SizedBox(
              width: double.infinity,
              child: Text(
                labelString,
                style: Theme.of(context).textTheme.titleLarge,
              )),
        ReorderableListView.builder(
          shrinkWrap: true,
          // buildDefaultDragHandles: true,
          physics: const ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            // Per-item child overrides and its shown-state chained to the array container
            // final String childScope = '$scope/items';
            final ui.DescendantControlOverrides? overrides = options?.formattingOptions?.descendantControlOverrides?[scope];
            final ui.ControlOptions? childOptions = overrides?.options ?? options;
            final ui.ShowOnProperty? childShowOn = overrides?.showOn;

            bool childIsShown() => isElementShown(
                  parentIsShown: arrayIsShown(),
                  showOn: childShowOn,
                  ritaDependencies: widget.ritaDependencies,
                  checkValueForShowOn: widget.checkValueForShowOn,
                );

            return Container(
              // padding: EdgeInsets.symmetric(vertical: 0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(12),
              //   border: Border.all(
              //     color: Colors.grey,
              //   ),
              // ),
              key: Key('${items[index].id}'),
              // padding: const EdgeInsets.only(right: 40, top: 5, bottom: 5),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: GestureDetector(
                      onTapDown: (_) => FocusScope.of(context).unfocus(),
                      child: const Icon(Icons.drag_handle),
                    ),
                  ),
                  Expanded(
                    child: FormElementFormControl(
                      scope: '$scope/items', // ${items[index].id} TODO maybe revert or have a look if this breaks things
                      id: '${widget.id}/items/${items[index].id}',
                      options: childOptions,
                      showOn: childShowOn,
                      jsonSchema: jsonSchema.items!, // TODO not type safe!
                      nestingLevel: widget.nestingLevel,
                      required: required,
                      // isShown: widget.isShown,
                      initialValue: items[index].value,
                      // Add/propagate selfIndices (mark current array scope with current index)
                      selfIndices: () {
                        final map = <String, int>{};
                        if (widget.selfIndices != null) {
                          map.addAll(widget.selfIndices!);
                        }
                        // For the current array, the key is the array's scope (not '/items')
                        map[scope] = index;
                        return map;
                      }(),
                      ritaEvaluator: widget.ritaEvaluator,
                      getFullFormData: widget.getFullFormData,
                      onSavedCallback: (value) {
                        items[index].value = value;
                        // call widget.onSavedCallback with the new value when last element is saved
                        if (widget.onSavedCallback != null && index == items.length - 1) {
                          widget.onSavedCallback!(items.map((e) => e.value).toList());
                        }
                      },
                      isShownCallback: childIsShown,
                      onChanged: (value) {
                        items[index].value = value;
                        if (widget.onChanged != null) {
                          widget.onChanged!(items);
                        }
                      },
                      showLabel: false,
                      parentIsShown: arrayIsShown(),
                      ritaDependencies: widget.ritaDependencies,
                      checkValueForShowOn: widget.checkValueForShowOn,
                      // showOn: widget.options?.formattingOptions?.descendantControlOverrides?,
                    ),
                  ),
                  // SizedBox(width: 10),
                  IconButton(
                    // FilledButton.tonal
                    // style: ButtonStyle(
                    //   // backgroundColor: WidgetStateProperty.all(
                    //   //   Theme.of(context).colorScheme.error,
                    //   // ),
                    //   iconColor: WidgetStateProperty.all(
                    //     Theme.of(context).colorScheme.error,
                    //     // Theme.of(context).colorScheme.onError,
                    //   ),
                    // ),
                    disabledColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                    icon: Icon(Icons.close),
                    color: Theme.of(context).colorScheme.error,
                    // child: Icon(Icons.close),
                    onPressed: items.length > minItems ? () => removeItem(index) : null,
                    // padding: EdgeInsets.zero,
                  ),
                ],
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final ListItem item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            });
          },
        ),
        // description
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: maxItems == null || items.length < maxItems ? () => addItem() : null,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );

    return handleShowOn(
      child: arrayWidget,
      parentIsShown: widget.parentIsShown,
      showOn: widget.showOn,
      ritaDependencies: widget.ritaDependencies,
      checkValueForShowOn: widget.checkValueForShowOn,
      selfIndices: widget.selfIndices,
      ritaEvaluator: widget.ritaEvaluator,
      getFullFormData: widget.getFullFormData,
    );
  }

  Widget _generateObject() {
    // Compute object container shown-state once, and propagate to children
    // bool objectIsShown() => isElementShown(
    //       parentIsShown: widget.isShownCallback(),
    //       showOn: widget.showOn,
    //       ritaDependencies: widget.ritaDependencies,
    //       checkValueForShowOn: widget.checkValueForShowOn,
    //     );
    // Use current element's shown-state
    bool objectIsShown() => widget.isShownCallback();
    List<Widget> elements = [];
    for (var key in jsonSchema.properties.keys) {
      // TODO: add default values recursively here
      bool childRequired = jsonSchema.propertyRequired(key);
      String childScope = "$scope/properties/$key";
      ui.DescendantControlOverrides? descendantControlOverrides = options?.formattingOptions?.descendantControlOverrides?[childScope];

      // Use descendant overrides if present, otherwise fall back to parent's options/showOn
      final childOptions = descendantControlOverrides?.options ?? options;
      final childShowOn = descendantControlOverrides?.showOn ?? widget.showOn;

      // Helper for child visibility
      bool childIsShown() => isElementShown(
            parentIsShown: objectIsShown(),
            showOn: childShowOn,
            ritaDependencies: widget.ritaDependencies,
            checkValueForShowOn: widget.checkValueForShowOn,
          );
      elements.add(FormElementFormControl(
        scope: childScope,
        id: '${widget.id}/properties/$key',
        options: childOptions,
        showOn: childShowOn,
        nestingLevel: widget.nestingLevel + 1,
        jsonSchema: jsonSchema.properties[key]!, // TODO: unsafe
        required: childRequired,
        initialValue: initialValue is Map<String, dynamic> ? initialValue["/properties/$key"] : null,
        isShownCallback: childIsShown,
        onSavedCallback: (value) {
          if (value != null && value != "" && childIsShown()) {
            formSubmitValues[key] = value;
          } else {
            formSubmitValues.remove(key);
          }
          if (widget.onSavedCallback != null && key == jsonSchema.properties.keys.last) {
            if (formSubmitValues.isNotEmpty) {
              widget.onSavedCallback!(formSubmitValues);
            }
          }
        },
        onChanged: (value) {
          _showOnDependencies[key] = value;
          if (widget.onChanged != null) {
            widget.onChanged!(_showOnDependencies);
          }
        },
        parentIsShown: objectIsShown(),
        ritaDependencies: widget.ritaDependencies,
        checkValueForShowOn: widget.checkValueForShowOn,
        selfIndices: widget.selfIndices,
        ritaEvaluator: widget.ritaEvaluator,
        getFullFormData: widget.getFullFormData,
      ));
    }

    Widget objectElements = getLineContainer(
        //.filled(
        // color: getAlternatingColor(context, widget.nestingLevel),
        // child: ListView.builder(
        //   // .separated
        //   shrinkWrap: true,
        //   physics: const ClampingScrollPhysics(),
        //   padding: const EdgeInsets.symmetric(horizontal: UIConstants.groupPadding),
        //   itemCount: elements.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return elements[index];
        //   },
        //   // separatorBuilder: (BuildContext context, int index) {
        //   //   return const SizedBox(height: UIConstants.verticalLayoutItemPadding);
        //   // },
        // ),
        child: Padding(
      padding: EdgeInsets.only(left: UIConstants.groupPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: elements,
      ),
    ));

    String? label = _getLabel(); // ?? scope.split('/').last;

    Widget objectWidget = label != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              objectElements,
            ],
          )
        : objectElements;

    return handleShowOn(
      child: objectWidget,
      checkValueForShowOn: widget.checkValueForShowOn,
      parentIsShown: widget.parentIsShown,
      showOn: widget.showOn,
      ritaDependencies: widget.ritaDependencies,
      selfIndices: widget.selfIndices,
      ritaEvaluator: widget.ritaEvaluator,
      getFullFormData: widget.getFullFormData,
    );
  }

  /// Material Switch
  Widget generateSwitch() {
    return _wrapField(
      showLabel: false,
      child: FormBuilderSwitch(
        initialValue: initialValue,
        name: widget.id,
        onChanged: onChanged,
        enabled: enabled,
        onSaved: widget.onSavedCallback,
        validator: _composeBaseValidator(additionalValidators: required ? [FormBuilderValidators.equal(true)] : null),
        title: Text(_getLabel() ?? ""),
        contentPadding: const EdgeInsets.all(0),
        decoration: _getInputDecoration(border: false),
        subtitle: description != null ? Text(description!) : null,
      ),
    );
  }

  /// Generates a text field for the form
  /// Check whether the type is string or number
  /// Make the field required if it is in the required fields
  Widget generateTextField() {
    int getLines() {
      if (options?.fieldSpecificOptions?.multi != null) {
        dynamic multi = options!.fieldSpecificOptions!.multi;
        if (options!.fieldSpecificOptions!.multi is bool) {
          bool multiBool = multi;
          return multiBool ? 2 : 1;
        } else if (multi is int) {
          return multi;
        }
      }
      return 1;
    }

    int maxLines = getLines();

    // TODO: create widget so state works
    bool obscureText = format == ui.Format.PASSWORD;

    TextInputType getKeyboardType() {
      if (maxLines > 1) return TextInputType.multiline;
      switch (format) {
        case ui.Format.EMAIL:
          return TextInputType.emailAddress;
        case ui.Format.PASSWORD:
          return TextInputType.visiblePassword;
        case ui.Format.SEARCH:
          return TextInputType.text;
        case ui.Format.URL:
          return TextInputType.url;
        case ui.Format.TEL:
          return TextInputType.phone;
        default:
          if (type == "integer" || type == "number") {
            return TextInputType.number;
          }
          return TextInputType.text;
      }
    }

    Iterable<String>? getAutocompleteValues() {
      if (options?.fieldSpecificOptions?.autocomplete != null) {
        switch (options!.fieldSpecificOptions!.autocomplete!) {
          case ui.Autocomplete.OFF:
            return null; // don't autofill
          case ui.Autocomplete.ON:
            return null; // finding a best match is not implemented
          case ui.Autocomplete.NAME:
            return [AutofillHints.name];
          case ui.Autocomplete.HONORIFIC_PREFIX:
            return [AutofillHints.namePrefix];
          case ui.Autocomplete.GIVEN_NAME:
            return null; // not found
          case ui.Autocomplete.ADDITIONAL_NAME:
            return [AutofillHints.givenName];
          case ui.Autocomplete.FAMILY_NAME:
            return [AutofillHints.familyName];
          case ui.Autocomplete.HONORIFIC_SUFFIX:
            return [AutofillHints.nameSuffix];
          case ui.Autocomplete.NICKNAME:
            return [AutofillHints.nickname];
          case ui.Autocomplete.EMAIL:
            return [AutofillHints.email];
          case ui.Autocomplete.USERNAME:
            return [AutofillHints.username];
          case ui.Autocomplete.NEW_PASSWORD:
            return [AutofillHints.newPassword];
          case ui.Autocomplete.CURRENT_PASSWORD:
            return [AutofillHints.password];
          case ui.Autocomplete.ONE_TIME_CODE:
            return [AutofillHints.oneTimeCode];
          case ui.Autocomplete.ORGANIZATION_TITLE:
            return [AutofillHints.organizationName];
          case ui.Autocomplete.ORGANIZATION:
            return [AutofillHints.organizationName]; // best fit
          case ui.Autocomplete.STREET_ADDRESS:
            return null; // not found
          case ui.Autocomplete.SHIPPING:
            return null; // not found
          case ui.Autocomplete.BILLING:
            return null; // not found
          case ui.Autocomplete.ADDRESS_LINE1:
            return [AutofillHints.streetAddressLine1];
          case ui.Autocomplete.ADDRESS_LINE2:
            return [AutofillHints.streetAddressLine2];
          case ui.Autocomplete.ADDRESS_LINE3:
            return [AutofillHints.streetAddressLine3];
          case ui.Autocomplete.ADDRESS_LEVEL1:
            return [AutofillHints.streetAddressLevel1];
          case ui.Autocomplete.ADDRESS_LEVEL2:
            return [AutofillHints.streetAddressLevel2];
          case ui.Autocomplete.ADDRESS_LEVEL3:
            return [AutofillHints.streetAddressLevel3];
          case ui.Autocomplete.ADDRESS_LEVEL4:
            return [AutofillHints.streetAddressLevel4];
          case ui.Autocomplete.COUNTRY:
            return [AutofillHints.countryCode];
          case ui.Autocomplete.COUNTRY_NAME:
            return [AutofillHints.countryName];
          case ui.Autocomplete.POSTAL_CODE:
            return [AutofillHints.postalCode];
          case ui.Autocomplete.CC_NAME:
            return [AutofillHints.creditCardName];
          case ui.Autocomplete.CC_GIVEN_NAME:
            return [AutofillHints.creditCardGivenName];
          case ui.Autocomplete.CC_ADDITIONAL_NAME:
            return null; // not found
          case ui.Autocomplete.CC_FAMILY_NAME:
            return [AutofillHints.creditCardFamilyName];
          case ui.Autocomplete.CC_NUMBER:
            return [AutofillHints.creditCardNumber];
          case ui.Autocomplete.CC_EXP:
            return [AutofillHints.creditCardExpirationDate];
          case ui.Autocomplete.CC_EXP_MONTH:
            return [AutofillHints.creditCardExpirationMonth];
          case ui.Autocomplete.CC_EXP_YEAR:
            return [AutofillHints.creditCardExpirationYear];
          case ui.Autocomplete.CC_CSC:
            return [AutofillHints.creditCardSecurityCode];
          case ui.Autocomplete.CC_TYPE:
            return [AutofillHints.creditCardType];
          case ui.Autocomplete.TRANSACTION_CURRENCY:
            return [AutofillHints.transactionCurrency];
          case ui.Autocomplete.TRANSACTION_AMOUNT:
            return [AutofillHints.transactionAmount];
          case ui.Autocomplete.LANGUAGE:
            return [AutofillHints.language];
          case ui.Autocomplete.BDAY:
            return [AutofillHints.birthday];
          case ui.Autocomplete.BDAY_DAY:
            return [AutofillHints.birthdayDay];
          case ui.Autocomplete.BDAY_MONTH:
            return [AutofillHints.birthdayMonth];
          case ui.Autocomplete.BDAY_YEAR:
            return [AutofillHints.birthdayYear];
          case ui.Autocomplete.SEX:
            return [AutofillHints.gender];
          case ui.Autocomplete.TEL:
            return [AutofillHints.telephoneNumber];
          case ui.Autocomplete.TEL_COUNTRY_CODE:
            return [AutofillHints.telephoneNumberCountryCode];
          case ui.Autocomplete.TEL_NATIONAL:
            return [AutofillHints.telephoneNumberNational];
          case ui.Autocomplete.TEL_AREA_CODE:
            return [AutofillHints.telephoneNumberAreaCode];
          case ui.Autocomplete.TEL_LOCAL:
            return [AutofillHints.telephoneNumberLocal];
          case ui.Autocomplete.TEL_EXTENSION:
            return [AutofillHints.telephoneNumberExtension];
          case ui.Autocomplete.IMPP:
            return [AutofillHints.impp];
          case ui.Autocomplete.URL:
            return [AutofillHints.url];
          case ui.Autocomplete.PHOTO:
            return [AutofillHints.photo];
          case ui.Autocomplete.WEBAUTHN:
            return null; // not found
        }
      }
      return null;
    }

    String initialValueString = "";
    if (initialValue != null) {
      try {
        initialValueString = initialValue.toString();
      } catch (e) {
        // TODO: logging
        initialValueString = "";
      }
    }

    TextAlign textAlign = switch (options?.fieldSpecificOptions?.textAlign) {
      ui.TextAlign.START => TextAlign.start,
      ui.TextAlign.END => TextAlign.end,
      ui.TextAlign.CENTER => TextAlign.center,
      ui.TextAlign.LEFT => TextAlign.left,
      ui.TextAlign.RIGHT => TextAlign.right,
      null => TextAlign.start,
    };

    return _wrapField(
        child: FormBuilderTextField(
      textAlign: textAlign,
      name: widget.id,
      onSubmitted: onChanged,
      enabled: enabled,
      onSaved: widget.onSavedCallback,
      obscureText: obscureText,
      validator: FormBuilderValidators.compose([
        _composeBaseValidator(),
        if (type == 'number' || type == 'integer') FormBuilderValidators.numeric(checkNullOrEmpty: false),
        if (jsonSchema.minimum != null) FormBuilderValidators.min(safeParseNum(jsonSchema.minimum), checkNullOrEmpty: false),
        if (jsonSchema.maximum != null) FormBuilderValidators.max(safeParseNum(jsonSchema.maximum), checkNullOrEmpty: false),
        if (jsonSchema.exclusiveMinimum != null)
          FormBuilderValidators.min(safeParseNum(jsonSchema.exclusiveMinimum), inclusive: false, checkNullOrEmpty: false),
        if (jsonSchema.exclusiveMaximum != null)
          FormBuilderValidators.max(safeParseNum(jsonSchema.exclusiveMaximum), inclusive: false, checkNullOrEmpty: false),
        if (jsonSchema.multipleOf != null)
          JsonSchemaValidators.multipleOf<dynamic>(
            safeParseNum(jsonSchema.multipleOf),
            // Optional: provide a localized error text
            // errorTextBuilder: (m) => AppLocalizations.of(context)!.multipleOfErrorText(m),
          ),
        if (jsonSchema.minLength != null) FormBuilderValidators.minLength(safeParseInt(jsonSchema.minLength), checkNullOrEmpty: false),
        if (jsonSchema.maxLength != null) FormBuilderValidators.maxLength(safeParseInt(jsonSchema.maxLength), checkNullOrEmpty: false),
        if (jsonSchema.pattern != null) FormBuilderValidators.match(jsonSchema.pattern!, checkNullOrEmpty: false),
        if (options?.fieldSpecificOptions?.format == ui.Format.EMAIL) FormBuilderValidators.email(checkNullOrEmpty: false),
        if (options?.fieldSpecificOptions?.format == ui.Format.PASSWORD)
          FormBuilderValidators.password(checkNullOrEmpty: false), // Doesn't do anything currently
        if (options?.fieldSpecificOptions?.format == ui.Format.TEL) FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
        if (options?.fieldSpecificOptions?.format == ui.Format.URL) FormBuilderValidators.url(checkNullOrEmpty: false),
      ]),
      // _composeBaseValidator(additionalValidators: (type == 'number' || type == 'integer') ? [FormBuilderValidators.numeric()] : null)
      decoration: _getInputDecoration(
          suffixIcon: format == ui.Format.PASSWORD
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(
                      () {
                        obscureText = !obscureText;
                      },
                    );
                  },
                )
              : null),
      initialValue: initialValueString,
      textInputAction: maxLines > 1 ? TextInputAction.newline : null,
      maxLines: maxLines,
      keyboardType: getKeyboardType(),
      autofillHints: getAutocompleteValues(),
      // onTapOutside: (PointerDownEvent event) {
      // print("onTapOutside");
      // FocusScope.of(context).unfocus();
      // },
    ));
  }

  /// generate Color Picker using [FormBuilderColorPickerField]
  Widget generateColorPicker() {
    return _wrapField(
      child: FormBuilderColorPickerField(
        name: widget.id,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(),
      ),
    );
  }

  Widget generateSlider() {
    final double min = safeParseDouble(jsonSchema.minimum);
    final double max = safeParseDouble(jsonSchema.maximum);
    final double? multiple = jsonSchema.multipleOf != null ? safeParseDouble(jsonSchema.multipleOf) : null;

    int? divisions;
    if (max > min) {
      if (multiple != null && multiple > 0) {
        final double steps = (max - min) / multiple;
        // Only set divisions if steps is (almost) an integer
        if (steps.isFinite && steps > 0 && (steps - steps.roundToDouble()).abs() < 1e-6) {
          // TODO. set threshold in constants file
          divisions = steps.round();
        } else {
          divisions = null; // slider moves freely; validation enforces multipleOf
        }
      } else {
        divisions = (max - min).toInt();
      }
    }

    return _wrapField(
      child: FormBuilderSlider(
        name: widget.id,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(additionalValidators: [
          if (multiple != null && multiple > 0)
            JsonSchemaValidators.multipleOf<dynamic>(
              multiple,
              // Optional translation hook:
              // errorTextBuilder: (m) => AppLocalizations.of(context)!.multipleOfErrorText(m),
            ),
        ]),
        decoration: _getInputDecoration(),
        min: min,
        max: max,
        divisions: divisions,
        initialValue: initialValue is double ? initialValue : min,
      ),
    );
  }

  Text _getErrorTextWidget(String message) {
    return Text(
      "Error: $message",
      style: const TextStyle(color: Colors.red),
    );
  }

  /// generate File Picker using [FormBuilderFilePicker]
  Widget generateFilePicker() {
    List<String>? getFileExtensions() {
      if (options?.fieldSpecificOptions?.acceptedFileType != null) {
        String acceptedFileType = options!.fieldSpecificOptions!.acceptedFileType!;
        List<String> fileTypes = acceptedFileType.split(', ');
        // if all file types are allowed, no restriction is needed
        if (fileTypes.contains("*")) {
          return null;
        } else {
          return fileTypes;
        }
      }
      return null;
    }

    return _wrapField(
      child: FormBuilderFilePicker(
        name: widget.id,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(),
        //  filled: true
        maxFiles: options?.fieldSpecificOptions?.allowMultipleFiles == true ? null : 1,
        allowedExtensions: getFileExtensions(),
        // TODO correctly parse file types, see documentation
      ),
    );
  }

  /// generates a FormBuilderRadioGroup to select a value from a list of Radio Widgets using [FormBuilderRadioGroup]
  Widget generateRadioGroup(List<String> values) {
    return _wrapField(
      child: FormBuilderRadioGroup(
        name: widget.id,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(border: false),
        // const OutlineInputBorder()
        options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
        orientation: getOptionsOrientation(options?.fieldSpecificOptions?.stacked),
      ),
    );
  }

  /// generates a FormBuilderCheckboxGroup to select multiple values from a list of Checkbox Widgets
  Widget generateCheckboxGroup(List<String> values) {
    return _wrapField(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: FormBuilderCheckboxGroup(
          name: widget.id,
          onChanged: onChanged,
          onSaved: widget.onSavedCallback,
          enabled: enabled,
          validator: _composeBaseValidator(),
          decoration: _getInputDecoration(border: false),
          orientation: getOptionsOrientation(options?.fieldSpecificOptions?.stacked),
          // border: const OutlineInputBorder()
          options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
        ),
      ),
    );
  }

  /// generates a FormBuilderDropdown to select a value from a list of Dropdown Widgets
  Widget generateDropdown(List<String> values) {
    return _wrapField(
      child: FormBuilderDropdown(
        name: widget.id,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(),
        // filled: true
        initialValue: initialValue,
        items: values.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(growable: false),
      ),
    );
  }

  /// generates a DateTimePicker to select a date
  Widget generateDateTimePicker(InputType inputType) {
    DateTime? getDefaultDatetime() {
      if (initialValue is! String) {
        return null;
      }
      final String initialValueString = initialValue;
      if (initialValueString == '\$now') {
        return DateTime.now();
      } else {
        return DateTime.tryParse(initialValueString);
      }
    }

    return _wrapField(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: FormBuilderDateTimePicker(
          name: widget.id,
          onChanged: onChanged,
          enabled: enabled,
          validator: _composeBaseValidator(),
          decoration: _getInputDecoration(suffix: const Icon(Icons.date_range)),
          initialValue: getDefaultDatetime(),
          inputType: inputType,
          onSaved: (DateTime? dateTime) => {widget.onSavedCallback?.call((dateTime?.toIso8601String()))}, // widget.onSavedCallback,
          // onFieldSubmitted: (value) => {value?.toIso8601String()},
          // locale: const Locale('de', 'DE'),
          // initialValue: DateTime.now(),
          // border decoration
        ),
      ),
    );
  }

  /// generate rating
  Widget generateRating() {
    return _wrapField(
      child: Container(
        constraints: const BoxConstraints(minWidth: 100),
        child: FormBuilderRatingBar(
          name: widget.id,
          onChanged: onChanged,
          enabled: enabled,
          validator: _composeBaseValidator(),
          decoration: _getInputDecoration(),
          itemSize: 20,
        ),
      ),
    );
  }

  Widget generateSegmentedControl(List<String> values) {
    // return FormBuilderCupertinoSegmentedControl<String>(
    //   name: scope,
    //   onChanged: onChanged,
    //   // decoration: InputDecoration(labelText: _getLabel()),
    //   validator: _composeBaseValidator(),
    //   options: values
    //       .map((value) => FormBuilderFieldOption(value: value))
    //       .toList(growable: false),
    // );
    return _wrapField(
      child: FormBuilderSegmentedButton<String>(
        name: widget.id,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        initialValue: initialValue,
        enabled: enabled,
        decoration: _getInputDecoration(border: false),
        segments: values.map((value) => ButtonSegment(value: value, label: Text(value))).toList(growable: false),
        showSelectedIcon: true,
        selectedIcon: const Icon(Icons.check),
      ),
    );
  }

  /// composes a base validator for the form element which validates the required property
  /// additional validators can be added to the list
  /// validation is only done when the element is shown
  /// [additionalValidators] list of additional validators to be added to the base validator
  FormFieldValidator<dynamic> _composeBaseValidator({List<FormFieldValidator>? additionalValidators}) {
    // FormBuilderValidator.compose can't be used here as the value of isShown can change dynamically after the validator is created
    // Therefore the callback function for the validator is created here and the value of isShown is checked before any validators are called
    return (valueCandidate) {
      if (!isShownCallback()) {
        return null;
      }

      if (required) {
        final validatorResult = FormBuilderValidators.required().call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      if (additionalValidators != null) {
        for (final validator in additionalValidators) {
          final validatorResult = validator.call(valueCandidate);
          if (validatorResult != null) {
            return validatorResult;
          }
        }
      }
      return null;
    };
  }

  /// generates the label text marked as required when the field is required
  String? _getLabel() {
    String? getScope() {
      final lastScopeElement = scope.split('/').last;
      return lastScopeElement != "items" ? lastScopeElement : null;
    }

    final titleString = title ?? getScope();
    return required ? ('${titleString}*') : titleString; // TODO: not barrierefrei, should be an icon with text required/notwendig
  }

  // Text? _getLabelText() {
  //   return label ? Text(_getLabel()) : null;
  // }

  /// temporary: get title from path
  String _getNameFromPath(String path) {
    final name = path.split('/').last;
    if (name.isNotEmpty) {
      return name[0].toUpperCase() + name.substring(1);
    }
    return name;
  }

  /// TODO temporary
  Text _getNotImplementedWidget() {
    return Text(
      "TODO implement $type",
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _wrapField({required Widget child, bool showLabel = true}) {
    final preHtml = options?.formattingOptions?.preHtml;
    final postHtml = options?.formattingOptions?.postHtml;

    List<Widget> columnChildren = [];

    if (preHtml != null && preHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: preHtml));
    }

    final labelText = _getLabel();

    if (labelSeparateText && widget.showLabel && showLabel && labelText != null) {
      columnChildren.add(
        Row(
          children: [
            Expanded(
              child: Text(
                labelText,
              ),
            ),
            if (options?.formattingOptions?.help != null)
              AnimatedTooltip(
                content: options!.formattingOptions!.help!.text,
                label: options!.formattingOptions!.help!.label ?? "?",
              ),
          ],
        ),
      );
    }

    columnChildren.add(child);

    if (postHtml != null && postHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: postHtml));
    }

    // Always wrap in a Column to ensure preHtml/postHtml are rendered
    return handleShowOn(
      child: columnChildren.length == 1
          ? columnChildren.first
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren,
            ),
      parentIsShown: widget.parentIsShown ?? true,
      showOn: widget.showOn,
      ritaDependencies: widget.ritaDependencies,
      checkValueForShowOn: widget.checkValueForShowOn,
      selfIndices: widget.selfIndices,
      ritaEvaluator: widget.ritaEvaluator,
      getFullFormData: widget.getFullFormData,
    );
  }

  // get the options orientation depending on the stacking
  // by default, stack is handled as false like defined in the ui Schema so the Orientation is set to wrap
  OptionsOrientation getOptionsOrientation(bool? stacked) {
    return stacked == true ? OptionsOrientation.vertical : OptionsOrientation.wrap;
  }

  /// Creates the input decoration for the form field
  /// [prefix] and [suffix] widgets can be set to customize the appearance
  /// If the uiSchema defines formatting options, they take precedence and will be used instead
  InputDecoration _getInputDecoration({bool border = true, Widget? prefix, Widget? suffix, Widget? suffixIcon}) {
    // TODO: Range selector
    return InputDecoration(
      labelText: labelSeparateText ? null : _getLabel(),
      hintText: placeholder,
      // filled: border,
      // fillColor: getAlternatingColor(context, widget.nestingLevel),
      // border: InputBorder.none,
      border: !border ? InputBorder.none : Theme.of(context).inputDecorationTheme.border,
      helperText: description,
      helperMaxLines: 10,
      prefix: options?.formattingOptions?.prepend == null ? prefix : null,
      prefixText: options?.formattingOptions?.prepend,
      suffix: options?.formattingOptions?.append == null ? suffix : null,
      suffixText: options?.formattingOptions?.append,
      suffixIcon: suffixIcon,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // TODO: has to be added back
      // prefixText: prefixHardcoded != null
      //     ? null
      //     : options?.textAlign == TextAlign.LEFT || options?.textAlign == TextAlign.START
      //         ? options?.append
      //         : null,
      // suffixText: suffixHardcoded != null
      //     ? null
      //     : options?.textAlign == TextAlign.RIGHT || options?.textAlign == TextAlign.END
      //         ? options?.append
      //         : null,
    );
  }
}
