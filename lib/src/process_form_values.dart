import 'package:flutter_json_forms/src/widgets/data/list_item.dart';

/// Specify the format of the form data when the form is submitted
enum OnFormSubmitFormat { formBuilder, ellaV1, ellaV2 }

/// Processes the form values for the Ella V1 format
/// Removes all form values which have null value
Map<String, dynamic> processFormValuesEllaV1(Map<String, dynamic> formValues) {
  Map<String, dynamic> processedFormValues = {};
  formValues.forEach((key, value) {
    if (value != null) {
      List<String> parts = key.split('/properties/');
      parts.removeAt(0); // Remove the first empty string from the split

      Map<String, dynamic> currentMap = processedFormValues;
      for (int i = 0; i < parts.length; i++) {
        String part = parts[i];

        if (i == parts.length - 1) {
          // If we're at the last part, check if it's an array index
          if (RegExp(r'/\d+$').hasMatch(part)) {
            // It's an array index, so get the parent key and the index
            String parentKey = RegExp(r'(.*)/\d+$').firstMatch(part)!.group(1)!;
            int index = int.parse(RegExp(r'/(\d+)$').firstMatch(part)!.group(1)!);

            // Get the list for the parent key, or create it if it doesn't exist
            List<dynamic> list = currentMap.putIfAbsent(parentKey, () => <dynamic>[]);

            // Add the value to the list at the correct index
            if (index >= list.length) {
              list.length = index + 1;
            }
            list[index] = value;
          } else {
            String partName = part;
            if (i == 0) {
              partName = "#/properties/$part";
            }
            // It's not an array index, so just set the value
            currentMap[partName] = value;
          }
        } else {
          String partName = part;
          if (i == 0) {
            partName = "#/properties/$part";
          }
          // Otherwise, navigate to the next map, creating it if necessary
          currentMap = currentMap.putIfAbsent(partName, () => <String, dynamic>{});
        }
      }
    }
  });
  return processedFormValues;
}

dynamic _extractListItemValue(dynamic value) {
  if (value is ListItem) {
    return _extractListItemValue(value.value);
  } else if (value is List) {
    return value.map(_extractListItemValue).toList();
  } else if (value is Map) {
    return value.map((k, v) => MapEntry(k, _extractListItemValue(v)));
  }
  return value;
}

/// Processes the form values for the Ella V2 format
/// All objects now get their own nested json object. e.g.
/// if there are two separate keys "/properties/object1/properties/field1" and "/properties/object1/properties/field2", they will be combined into one object "/properties/object1" with the fields "field1" and "field2"
Map<String, dynamic> processFormValuesEllaV2(Map<String, dynamic> formValues) {
  Map<String, dynamic> processedFormValues = {};
  formValues.forEach((key, value) {
    if (value != null) {
      List<String> parts = key.split('/properties/');
      parts.removeAt(0);

      Map<String, dynamic> currentMap = processedFormValues;
      for (int i = 0; i < parts.length; i++) {
        String part = parts[i];

        if (i == parts.length - 1) {
          // Last part, check for array entry or normal field
          if (RegExp(r'/\d+$').hasMatch(part)) {
            String parentKey = RegExp(r'(.*)/\d+$').firstMatch(part)!.group(1)!;
            int index = int.parse(RegExp(r'/(\d+)$').firstMatch(part)!.group(1)!);

            List<dynamic> list = currentMap.putIfAbsent(parentKey, () => <dynamic>[]);

            // Ensure the list is large enough
            if (index >= list.length) {
              list.length = index + 1;
            }
            list[index] = _extractListItemValue(value);
          } else {
            currentMap[part] = _extractListItemValue(value);
          }
        } else {
          currentMap = currentMap.putIfAbsent(part, () => <String, dynamic>{});
        }
      }
    }
  });
  return processedFormValues;
}
