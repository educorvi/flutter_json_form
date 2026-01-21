// import 'dart:convert';
// import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

// import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/utils/data/list_item.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
// import 'package:form_builder_file_picker/form_builder_file_picker.dart';

/// Specify the format of the form data when the form is submitted
enum OnFormSubmitFormat { formBuilder, ellaV1, ellaV2 }

/// Processes the form values for the Ella V1 format
/// Removes all form values which have null value
// Map<String, dynamic> processFormValuesEllaV1(Map<String, dynamic> formValues) {
//   Map<String, dynamic> processedFormValues = {};
//   formValues.forEach((key, value) {
//     if (value != null) {
//       List<String> parts = key.split('/properties/');
//       parts.removeAt(0); // Remove the first empty string from the split

//       Map<String, dynamic> currentMap = processedFormValues;
//       for (int i = 0; i < parts.length; i++) {
//         String part = parts[i];

//         if (i == parts.length - 1) {
//           // If we're at the last part, check if it's an array index
//           if (RegExp(r'/\d+$').hasMatch(part)) {
//             // It's an array index, so get the parent key and the index
//             String parentKey = RegExp(r'(.*)/\d+$').firstMatch(part)!.group(1)!;
//             int index = int.parse(RegExp(r'/(\d+)$').firstMatch(part)!.group(1)!);

//             // Get the list for the parent key, or create it if it doesn't exist
//             List<dynamic> list = currentMap.putIfAbsent(parentKey, () => <dynamic>[]);

//             // Add the value to the list at the correct index
//             if (index >= list.length) {
//               list.length = index + 1;
//             }
//             list[index] = value;
//           } else {
//             String partName = part;
//             if (i == 0) {
//               partName = "#/properties/$part";
//             }
//             // It's not an array index, so just set the value
//             currentMap[partName] = value;
//           }
//         } else {
//           String partName = part;
//           if (i == 0) {
//             partName = "#/properties/$part";
//           }
//           // Otherwise, navigate to the next map, creating it if necessary
//           currentMap = currentMap.putIfAbsent(partName, () => <String, dynamic>{});
//         }
//       }
//     }
//   });
//   return processedFormValues;
// }

/// Recursively extracts the underlying value from ListItem, List, Map, or DateTime.
///
/// - If [value] is a ListItem, returns its recursively extracted value.
/// - If [value] is a List, returns a new list with each element recursively extracted.
/// - If [value] is a Map, returns a new map with each value recursively extracted.
/// - If [value] is a DateTime, returns its ISO8601 string representation.
/// - Otherwise, returns [value] unchanged.
///
/// This helper is used to convert form field values into JSON-serializable output,
/// flattening ListItem wrappers and handling nested structures.
/// Recursively extracts the underlying value from ListItem, List, Map, or DateTime.
///
/// - If [value] is a ListItem, returns its recursively extracted value.
/// - If [value] is a List, returns a new list with each element recursively extracted.
/// - If [value] is a Map, returns a new map with each value recursively extracted.
/// - If [value] is a DateTime, returns its ISO8601 string representation.
/// - Otherwise, returns [value] unchanged.
///
/// This helper is used to convert form field values into JSON-serializable output,
/// flattening ListItem wrappers and handling nested structures.
dynamic extractListItemValue(dynamic value, {bool skipFiles = true}) {
  if (value is ListItem) {
    return extractListItemValue(value.value, skipFiles: skipFiles);
  } else if (value is List) {
    return value.map((v) => extractListItemValue(v, skipFiles: skipFiles)).toList();
  } else if (value is Map) {
    return value.map((k, v) => MapEntry(k, extractListItemValue(v, skipFiles: skipFiles)));
  } else if (value is DateTime) {
    return value.toIso8601String();
  } else if (value is Color?) {
    return value?.toARGB32().toString();
  } else if (value is PlatformFile) {
    if (skipFiles) {
      return '[file-upload-skipped]';
    }
    // Try to encode file content as base64
    try {
      if (value.bytes != null) {
        // import 'dart:convert'; at top of file
        return base64Encode(value.bytes!);
      } else if (value.path != null) {
        // import 'dart:io'; at top of file
        final file = File(value.path!);
        if (file.existsSync()) {
          return base64Encode(file.readAsBytesSync());
        }
      }
    } catch (e) {
      // ignore errors, fall through to placeholder
    }
    return '[file-upload-unavailable]';
  }
  return value;
}

// Future<String> readPlatformFileBytes(PlatformFile file) async {
//   if (file.bytes != null) {
//     return base64Encode(file.bytes!);
//   } else if (file.path != null) {
//     return base64Encode(await File(file.path!).readAsBytes());
//   } else {
//     FormLogger.generic.warning('PlatformFile has no bytes');
//     return Future.value('');
//   }
// }

/// Converts flat form value map with JSON pointer-like keys into a nested JSON structure.
///
/// This function transforms form field values from a flat map (where keys are paths like
/// "/properties/object1/properties/field1") into a deeply nested map suitable for Ella V2 format.
///
/// - Keys are split by "/properties/" to determine nesting.
/// - Array indices (e.g., "/properties/list/0") are detected and values are placed at the correct index.
/// - ListItem wrappers and DateTime values are unwrapped/serialized using [_extractListItemValue].
/// - Null values are omitted from the output.
///
/// Example:
///   Input: {
///     "/properties/person/properties/name": "Alice",
///     "/properties/person/properties/age": 30,
///     "/properties/tags/0": "tag1",
///     "/properties/tags/1": "tag2"
///   }
///   Output: {
///     "person": {"name": "Alice", "age": 30},
///     "tags": ["tag1", "tag2"]
///   }
Map<String, dynamic> processFormValues(Map<String, dynamic> formValues, {bool skipFiles = true}) {
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
            int index = int.parse(RegExp(r'/\d+$').firstMatch(part)!.group(0)!.replaceAll('/', ''));

            List<dynamic> list = currentMap.putIfAbsent(parentKey, () => <dynamic>[]);

            // Ensure the list is large enough
            if (index >= list.length) {
              list.length = index + 1;
            }
            list[index] = extractListItemValue(value, skipFiles: skipFiles);
          } else {
            currentMap[part] = extractListItemValue(value, skipFiles: skipFiles);
          }
        } else {
          currentMap = currentMap.putIfAbsent(part, () => <String, dynamic>{});
        }
      }
    }
  });
  return processedFormValues;
}
