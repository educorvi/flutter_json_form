import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_forms/src/widgets/utils.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

// import 'package:form_builder_cupertino_fields/form_builder_cupertino_fields.dart';
import '../constants.dart';
import '../models/ui-schema.dart';
import 'custom_form_fields/form_builder_segmented_button.dart';
import 'data/list_item.dart';

class FormElementFormControl extends StatefulWidget {
  final Options? options;
  final Format? format;
  final String scope;
  final Map<String, dynamic> property;
  final bool required;
  final void Function(dynamic)? onChanged;
  final bool Function() isShownCallback;
  final dynamic initialValue;
  final int nestingLevel;

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
      required this.property,
      this.initialValue,
      // required this.isShown,
      this.onSavedCallback,
      this.showLabel = true,
      required this.isShownCallback,
      this.format,
      required this.nestingLevel});

  @override
  State<FormElementFormControl> createState() => _FormElementFormControlState();
}

class _FormElementFormControlState extends State<FormElementFormControl> {
  late final String title;
  late final String? description;
  late final String? type;
  late final Options? options;
  late final Format? format;
  late final String scope;
  late final Map<String, dynamic> property;
  late final bool required;
  late final bool label;
  late final String? placeholder;
  late final bool enabled;
  late final dynamic initialValue;
  late final void Function(dynamic)? onChanged;
  late final bool Function() isShownCallback;
  late final void Function(dynamic)? onSavedCallback;

  final bool labelSeparateText = true;

  @override
  void initState() {
    options = widget.options;
    format = widget.format;
    scope = widget.scope;
    property = widget.property;
    required = widget.required;
    onChanged = widget.onChanged;
    isShownCallback = widget.isShownCallback;
    title = property['title'] ?? _getNameFromPath(scope);
    label = options?.label ?? true;
    description = property['description'];
    type = property["type"];
    placeholder = options?.placeholder;
    enabled = true; // options?.disabled != true;
    initialValue = widget.initialValue ?? property['default'];
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
      case 'string':
        child = _generateStringControl();
      case 'integer' || 'number':
        child = _generateIntegerControl();
      case 'boolean':
        child = _generateBooleanControl();
      case 'array':
        child = _generateArrayControl();
      case 'object':
        child = _generateObject();
      default: // TODO: number and null missing
        child = _getNotImplementedWidget();
    }
    if (options?.hidden == true) {
      // TODO: this results in a small additional gap in the ui
      return Visibility(
        maintainState: true,
        visible: false,
        child: child,
      );
      return child;
    } else {
      return child;
    }
  }

  /// temporary: get title from path
  String _getNameFromPath(String path) {
    final name = path.split('/').last;
    if (name.isNotEmpty) {
      return name[0].toUpperCase() + name.substring(1);
    }
    return name;
  }

  /// handles the generation of string elements in the jsonSchema
  Widget _generateStringControl() {
    if (property['enum'] != null) {
      List<String> values = [];
      for (var item in property['enum']) {
        if (item is String) {
          values.add(item);
        } else {
          try {
            values.add(item.toString());
          } catch (e) {
            print(e);
          }
        }
      }
      if (options?.buttons == "Radiobuttons" || options?.radiobuttons == true) {
        // DisplayAs.RADIOBUTTONS
        return generateRadioGroup(values);
      } else if (options?.buttons == "Checkboxgroups") {
        // DisplayAs.BUTTONS
        return generateSegmentedControl(values);
      } else {
        return generateDropdown(values);
      }
    } else if (property['format'] == 'date-time' || format == Format.DATE_TIME) {
      return generateDateTimePicker(InputType.both);
    } else if (property['format'] == 'date' || format == Format.DATE) {
      return generateDateTimePicker(InputType.date); // TODO adjust timepicker
    } else if (property['format'] == 'time' || format == Format.TIME) {
      return generateDateTimePicker(InputType.time); // TODO adjust timepicker
    } else if (property['format'] == 'uri') {
      return generateFilePicker();
    } else {
      // type is string
      if (property['format'] == 'color' || format == Format.COLOR) {
        return generateColorPicker();
      }
      return generateTextField();
    }
  }

  /// handles the generation of integer elements in the jsonSchema
  Widget _generateIntegerControl() {
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
    var type = null;
    if (property['items'] != null) {
      type = property['items']['type'];
      if (property['items']['enum'] != null) {
        List<String> values = [];
        for (var item in property['items']['enum']) {
          values.add(item);
        }
        return generateCheckboxGroup(values);
      }
    }
    if (property['enum'] != null) {
      List<String> values = [];
      for (var item in property['enum']) {
        values.add(item);
      }
      return generateCheckboxGroup(values);
    }
    if (options?.tags?.enabled == true) {
      // TODO implement variants and proper tags support
      return generateTextField();
    }

    if (!itemsInitialized) {
      itemsInitialized = true;
      // initialize items with default value
      if (initialValue != null && initialValue is List<ListItem>) {
        for (ListItem item in initialValue) {
          items.add(ListItem<dynamic>(id: item.id, value: item.value));
          _idCounter++;
        }
      } else {
        items.add(ListItem<dynamic>(id: _idCounter++, value: null));
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

    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getLabel(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            FilledButton.tonal(
              onPressed: () {
                addItem();
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
        ReorderableListView.builder(
          shrinkWrap: true,
          // buildDefaultDragHandles: true,
          physics: const ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              key: Key('${items[index].id}'),
              padding: const EdgeInsets.only(right: 40, top: 5, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: FormElementFormControl(
                      scope: '$scope/${items[index].id}',
                      property: property['items'] ?? {},
                      nestingLevel: widget.nestingLevel,
                      required: required,
                      // isShown: widget.isShown,
                      initialValue: items[index].value,
                      onSavedCallback: (value) {
                        items[index].value = value;
                        // call widget.onSavedCallback with the new value when last element is saved
                        if (widget.onSavedCallback != null && index == items.length - 1) {
                          widget.onSavedCallback!(items.map((e) => e.value).toList());
                        }
                      },
                      isShownCallback: isShownCallback,
                      onChanged: (value) {
                        items[index].value = value;
                        if (widget.onChanged != null) {
                          widget.onChanged!(items);
                        }
                      },
                      showLabel: false,
                    ),
                  ),
                  if (items.length > 1) SizedBox(width: 10),
                  if (items.length > 1)
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => removeItem(index),
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
      ],
    );
  }

  Widget _generateObject() {
    // TODO use version from dynamic_form_builder.dart
    List<Widget> elements = [];
    if (property['properties'] != null) {
      for (var key in property['properties'].keys) {
        // TODO: add default values recursively here
        bool childRequired = property['required'] != null ? property['required'].contains(key) : false;
        onSavedCallback(value) {
          if (value != null && value != "" && isShownCallback()) {
            formSubmitValues[key] = value;
          } else {
            formSubmitValues.remove(key);
          }
          // if last element is saved, submit the form
          if (widget.onSavedCallback != null && key == property['properties'].keys.last) {
            // dont submit an empty object
            if (formSubmitValues.isNotEmpty) {
              widget.onSavedCallback!(formSubmitValues);
            }
          }
        }

        onChangedCallback(value) {
          _showOnDependencies[key] = value;
          if (widget.onChanged != null) {
            widget.onChanged!(_showOnDependencies);
          }
        }

        // formSubmitValues[key] = property['properties'][key]['default'];
        elements.add(FormElementFormControl(
          scope: "$scope/properties/$key",
          nestingLevel: widget.nestingLevel + 1,
          property: property['properties'][key],
          required: childRequired,
          initialValue: initialValue is Map<String, dynamic> ? initialValue["/properties/$key"] : null,
          // TODO: error handling, most likely at another place in the code. If no object is provided here, an error should be rendered in the ui before
          // isShown: widget.isShown,
          isShownCallback: isShownCallback,
          onSavedCallback: onSavedCallback,
          onChanged: onChangedCallback,
        ));
      }
    }

    Card generateGroupElements() {
      return Card.filled(
        color: getAlternatingColor(context, widget.nestingLevel),
        // decoration: const BoxDecoration(
        //   border: Border(
        //     left: BorderSide(
        //       color: Colors.grey, // Change this color to match your design
        //       width: 2.0, // Change this width to match your design
        //     ),
        //   ),
        // ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: UIConstants.groupPadding),
          itemCount: elements.length,
          itemBuilder: (BuildContext context, int index) {
            return elements[index];
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: UIConstants.verticalLayoutItemPadding);
          },
        ),
      );
    }

    if (property['title'] != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property['title'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: UIConstants.groupTitleSpacing),
          generateGroupElements(),
        ],
      );
    } else {
      return generateGroupElements();
    }
  }

  /// Material Switch
  Widget generateSwitch() {
    return FormBuilderSwitch(
      initialValue: initialValue,
      name: scope,
      onChanged: onChanged,
      enabled: enabled,
      onSaved: widget.onSavedCallback,
      validator: _composeBaseValidator(additionalValidators: required ? [FormBuilderValidators.equal(true)] : null),
      title: Text(_getLabel()),
      contentPadding: const EdgeInsets.all(0),
      decoration: _getInputDecoration(border: false),
      subtitle: description != null ? Text(description!) : null,
    );
  }

  /// Generates a text field for the form
  /// Check whether the type is string or number
  /// Make the field required if it is in the required fields
  Widget generateTextField() {
    int getLines() {
      if (options?.multi != null) {
        dynamic multi = options!.multi;
        if (options!.multi is bool) {
          bool multiBool = multi;
          return multiBool ? 5 : 1;
        } else if (multi is int) {
          return multi;
        }
      }
      return 1;
    }

    int maxLines = getLines();

    TextInputType getKeyboardType() {
      if (maxLines > 1) return TextInputType.multiline;
      switch (format) {
        case Format.EMAIL:
          return TextInputType.emailAddress;
        case Format.PASSWORD:
          return TextInputType.visiblePassword;
        case Format.SEARCH:
          return TextInputType.text;
        case Format.URL:
          return TextInputType.url;
        case Format.TEL:
          return TextInputType.phone;
        default:
          if (type == "integer" || type == "number") {
            return TextInputType.number;
          }
          return TextInputType.text;
      }
    }

    Iterable<String>? getAutocompleteValues() {
      if (options?.autocomplete != null) {
        switch (options!.autocomplete!) {
          case AutocompleteValues.OFF:
            return null; // don't autofill
          case AutocompleteValues.ON:
            return null; // finding a best match is not implemented
          case AutocompleteValues.NAME:
            return [AutofillHints.name];
          case AutocompleteValues.HONORIFIC_PREFIX:
            return [AutofillHints.namePrefix];
          case AutocompleteValues.GIVEN_NAME:
            return null; // not found
          case AutocompleteValues.ADDITIONAL_NAME:
            return [AutofillHints.givenName];
          case AutocompleteValues.FAMILY_NAME:
            return [AutofillHints.familyName];
          case AutocompleteValues.HONORIFIC_SUFFIX:
            return [AutofillHints.nameSuffix];
          case AutocompleteValues.NICKNAME:
            return [AutofillHints.nickname];
          case AutocompleteValues.EMAIL:
            return [AutofillHints.email];
          case AutocompleteValues.USERNAME:
            return [AutofillHints.username];
          case AutocompleteValues.NEW_PASSWORD:
            return [AutofillHints.newPassword];
          case AutocompleteValues.CURRENT_PASSWORD:
            return [AutofillHints.password];
          case AutocompleteValues.ONE_TIME_CODE:
            return [AutofillHints.oneTimeCode];
          case AutocompleteValues.ORGANIZATION_TITLE:
            return [AutofillHints.organizationName];
          case AutocompleteValues.ORGANIZATION:
            return [AutofillHints.organizationName]; // best fit
          case AutocompleteValues.STREET_ADDRESS:
            return null; // not found
          case AutocompleteValues.SHIPPING:
            return null; // not found
          case AutocompleteValues.BILLING:
            return null; // not found
          case AutocompleteValues.ADDRESS_LINE1:
            return [AutofillHints.streetAddressLine1];
          case AutocompleteValues.ADDRESS_LINE2:
            return [AutofillHints.streetAddressLine2];
          case AutocompleteValues.ADDRESS_LINE3:
            return [AutofillHints.streetAddressLine3];
          case AutocompleteValues.ADDRESS_LEVEL1:
            return [AutofillHints.streetAddressLevel1];
          case AutocompleteValues.ADDRESS_LEVEL2:
            return [AutofillHints.streetAddressLevel2];
          case AutocompleteValues.ADDRESS_LEVEL3:
            return [AutofillHints.streetAddressLevel3];
          case AutocompleteValues.ADDRESS_LEVEL4:
            return [AutofillHints.streetAddressLevel4];
          case AutocompleteValues.COUNTRY:
            return [AutofillHints.countryCode];
          case AutocompleteValues.COUNTRY_NAME:
            return [AutofillHints.countryName];
          case AutocompleteValues.POSTAL_CODE:
            return [AutofillHints.postalCode];
          case AutocompleteValues.CC_NAME:
            return [AutofillHints.creditCardName];
          case AutocompleteValues.CC_GIVEN_NAME:
            return [AutofillHints.creditCardGivenName];
          case AutocompleteValues.CC_ADDITIONAL_NAME:
            return null; // not found
          case AutocompleteValues.CC_FAMILY_NAME:
            return [AutofillHints.creditCardFamilyName];
          case AutocompleteValues.CC_NUMBER:
            return [AutofillHints.creditCardNumber];
          case AutocompleteValues.CC_EXP:
            return [AutofillHints.creditCardExpirationDate];
          case AutocompleteValues.CC_EXP_MONTH:
            return [AutofillHints.creditCardExpirationMonth];
          case AutocompleteValues.CC_EXP_YEAR:
            return [AutofillHints.creditCardExpirationYear];
          case AutocompleteValues.CC_CSC:
            return [AutofillHints.creditCardSecurityCode];
          case AutocompleteValues.CC_TYPE:
            return [AutofillHints.creditCardType];
          case AutocompleteValues.TRANSACTION_CURRENCY:
            return [AutofillHints.transactionCurrency];
          case AutocompleteValues.TRANSACTION_AMOUNT:
            return [AutofillHints.transactionAmount];
          case AutocompleteValues.LANGUAGE:
            return [AutofillHints.language];
          case AutocompleteValues.BDAY:
            return [AutofillHints.birthday];
          case AutocompleteValues.BDAY_DAY:
            return [AutofillHints.birthdayDay];
          case AutocompleteValues.BDAY_MONTH:
            return [AutofillHints.birthdayMonth];
          case AutocompleteValues.BDAY_YEAR:
            return [AutofillHints.birthdayYear];
          case AutocompleteValues.SEX:
            return [AutofillHints.gender];
          case AutocompleteValues.TEL:
            return [AutofillHints.telephoneNumber];
          case AutocompleteValues.TEL_COUNTRY_CODE:
            return [AutofillHints.telephoneNumberCountryCode];
          case AutocompleteValues.TEL_NATIONAL:
            return [AutofillHints.telephoneNumberNational];
          case AutocompleteValues.TEL_AREA_CODE:
            return [AutofillHints.telephoneNumberAreaCode];
          case AutocompleteValues.TEL_LOCAL:
            return [AutofillHints.telephoneNumberLocal];
          case AutocompleteValues.TEL_EXTENSION:
            return [AutofillHints.telephoneNumberExtension];
          case AutocompleteValues.IMPP:
            return [AutofillHints.impp];
          case AutocompleteValues.URL:
            return [AutofillHints.url];
          case AutocompleteValues.PHOTO:
            return [AutofillHints.photo];
          case AutocompleteValues.WEBAUTHN:
            return null; // not found
        }
      }
      return null;
    }

    return _wrapFieldTitle(
        child: FormBuilderTextField(
      name: scope,
      onSubmitted: onChanged,
      enabled: enabled,
      onSaved: widget.onSavedCallback,
      validator: FormBuilderValidators.compose([
        _composeBaseValidator(),
        if (type == 'number' || type == 'integer') FormBuilderValidators.numeric(),
      ]),
      // _composeBaseValidator(additionalValidators: (type == 'number' || type == 'integer') ? [FormBuilderValidators.numeric()] : null)
      decoration: _getInputDecoration(),
      initialValue: initialValue,
      textInputAction: maxLines > 1 ? TextInputAction.newline : null,
      maxLines: maxLines,
      keyboardType: getKeyboardType(),
      autofillHints: getAutocompleteValues(),
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).unfocus();
      },
    ));
  }

  /// generate Color Picker using [FormBuilderColorPickerField]
  Widget generateColorPicker() {
    return _wrapFieldTitle(
      child: FormBuilderColorPickerField(
        name: scope,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(),
      ),
    );
  }

  /// generate File Picker using [FormBuilderFilePicker]
  Widget generateFilePicker() {
    List<String>? getFileExtensions() {
      if (options?.acceptedFileType != null) {
        String acceptedFileType = options!.acceptedFileType!;
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

    return _wrapFieldTitle(
      child: FormBuilderFilePicker(
        name: scope,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(),
        //  filled: true
        maxFiles: options?.allowMultipleFiles == true ? null : 1,
        allowedExtensions: getFileExtensions(),
        // TODO correctly parse file types, see documentation
      ),
    );
  }

  /// generates a FormBuilderRadioGroup to select a value from a list of Radio Widgets using [FormBuilderRadioGroup]
  Widget generateRadioGroup(List<String> values) {
    return _wrapFieldTitle(
      child: FormBuilderRadioGroup(
        name: scope,
        onChanged: onChanged,
        onSaved: widget.onSavedCallback,
        enabled: enabled,
        validator: _composeBaseValidator(),
        decoration: _getInputDecoration(border: false),
        // const OutlineInputBorder()
        options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
        orientation: OptionsOrientation.vertical,
      ),
    );
  }

  /// generates a FormBuilderCheckboxGroup to select multiple values from a list of Checkbox Widgets
  Widget generateCheckboxGroup(List<String> values) {
    return _wrapFieldTitle(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: FormBuilderCheckboxGroup(
          name: scope,
          onChanged: onChanged,
          onSaved: widget.onSavedCallback,
          enabled: enabled,
          validator: _composeBaseValidator(),
          decoration: _getInputDecoration(border: false),
          // border: const OutlineInputBorder()
          options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
        ),
      ),
    );
  }

  /// generates a FormBuilderDropdown to select a value from a list of Dropdown Widgets
  Widget generateDropdown(List<String> values) {
    return _wrapFieldTitle(
      child: FormBuilderDropdown(
        name: scope,
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

    return _wrapFieldTitle(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100),
        child: FormBuilderDateTimePicker(
            name: scope,
            onChanged: onChanged,
            enabled: enabled,
            validator: _composeBaseValidator(),
            decoration: _getInputDecoration(suffixHardcoded: const Icon(Icons.date_range)),
            initialValue: getDefaultDatetime(),
            inputType: inputType,
            onSaved: (DateTime? dateTime) => {widget.onSavedCallback?.call((dateTime?.toIso8601String()))}
            // locale: const Locale('de', 'DE'),
            // initialValue: DateTime.now(),
            // border decoration
            ),
      ),
    );
  }

  /// generate rating
  Widget generateRating() {
    return _wrapFieldTitle(
      child: Container(
        constraints: const BoxConstraints(minWidth: 100),
        child: FormBuilderRatingBar(
          name: scope,
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
    return _wrapFieldTitle(
      child: FormBuilderSegmentedButton<String>(
        name: scope,
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
      // if(!widget.isShown){
      //   return null;
      // }

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
  String _getLabel() {
    return title + (required ? '*' : '');
  }

  Text? _getLabelText() {
    return label ? Text(_getLabel()) : null;
  }

  /// TODO temporary
  Text _getNotImplementedWidget() {
    return Text(
      "TODO implement $type",
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _wrapFieldTitle({required Widget child}) {
    return labelSeparateText && widget.showLabel
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getLabel(),
              ),
              // const SizedBox(height: UIConstants.groupTitleSpacing),
              child,
            ],
          )
        : child;
  }

  InputDecoration _getInputDecoration({bool border = true, Widget? prefixHardcoded, Widget? suffixHardcoded}) {
    return InputDecoration(
      labelText: labelSeparateText ? null : _getLabel(),
      hintText: placeholder,
      filled: border,
      fillColor: getAlternatingColor(context, widget.nestingLevel),
      // border: InputBorder.none,
      border:
          border ? const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)), borderSide: BorderSide.none) : InputBorder.none,
      helperText: description,
      helperMaxLines: 10,
      prefix: prefixHardcoded,
      suffix: suffixHardcoded,
      prefixText: prefixHardcoded != null
          ? null
          : options?.textAlign == TextAlign.LEFT || options?.textAlign == TextAlign.START
              ? options?.append
              : null,
      suffixText: suffixHardcoded != null
          ? null
          : options?.textAlign == TextAlign.RIGHT || options?.textAlign == TextAlign.END
              ? options?.append
              : null,
    );
  }
}
