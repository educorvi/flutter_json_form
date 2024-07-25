import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final _properties = {};
const _requiredFields = [];

/// Generates the form fields based on the properties of the json schema
List<Widget> _generateForm() {
  List<Widget> formFields = [];
  _properties.forEach((key, value) {
    formFields.add(_generateFormField(key, value));
    formFields.add(const SizedBox(height: 20));
  });
  return formFields;
}

/// Generates a form field based on the type of the property
Widget _generateFormField(String key, dynamic value) {
  if (value['type'] == 'string' && value['enum'] != null) {
    List<String> values = [];
    for (var item in value['enum']) {
      values.add(item);
    }
    return _generateRadioGroup(key, value['title'], values);
  } else if (value['type'] == 'array') {
    List<String> values = [];
    for (var item in value['enum']) {
      values.add(item);
    }
    return _generateCheckboxGroup(key, value['title'], values);
  } else if (value['type'] == 'string' || value['type'] == 'number') {
    return _generateTextField(key, value['title'], value['type']);
  }
  print('The type is not supported yet');
  return const SizedBox();
  // return const Text('The type is not supported yet', style: TextStyle(color: Colors.red),);
}

/// Generates a text field for the form
/// Check whether the type is string or number
/// Make the field required if it is in the required fields
FormBuilderTextField _generateTextField(String key, String title, String type) {
  return FormBuilderTextField(
    keyboardType: type == 'number' ? TextInputType.number : TextInputType.text,
    name: title,
    decoration: InputDecoration(labelText: title),
    validator: FormBuilderValidators.compose([
      if (_requiredFields.contains(key)) FormBuilderValidators.required(),
      if (type == 'number') FormBuilderValidators.numeric(),
    ]),
  );
}

/// generates a FormBuilderRadioGroup to select a value from a list of Radio Widgets
FormBuilderRadioGroup _generateRadioGroup(String key, String title, List<String> values) {
  return FormBuilderRadioGroup(
    name: title,
    decoration: InputDecoration(labelText: title),
    validator: FormBuilderValidators.compose([
      if (_requiredFields.contains(key)) FormBuilderValidators.required(),
    ]),
    options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
  );
}

// generates a FormBuilderCheckboxGroup to select multiple values from a list of Checkbox Widgets
FormBuilderCheckboxGroup _generateCheckboxGroup(String key, String title, List<String> values) {
  return FormBuilderCheckboxGroup(
    name: title,
    decoration: InputDecoration(labelText: title),
    validator: FormBuilderValidators.compose([
      if (_requiredFields.contains(key)) FormBuilderValidators.required(),
    ]),
    options: values.map((value) => FormBuilderFieldOption(value: value)).toList(growable: false),
  );
}