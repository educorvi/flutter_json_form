import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/utils/parse.dart';
import 'package:json_schema/json_schema.dart';

// Color getAlternatingColor(BuildContext context, int nestingLevel) {
//   return nestingLevel % 2 == 1 ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainerHigh;
// }

/// Generates a default UI schema for a given [jsonSchema] JSON schema.
///
/// This function traverses the provided JSON schema and creates a default UI schema
/// with a vertical layout. Each field in the JSON schema is represented as a control
/// element in the UI schema. If a field is of type `object`, it is represented as a
/// group containing its nested properties.
///
/// The return value is a [ui.UiSchema ] object that represents the generated default UI schema.
ui.UiSchema generateDefaultUISchema(Map<String, dynamic> jsonSchema) {
  // generates the default UI schema elements based on the properties of the JSON schema
  List<ui.LayoutElement> generateDefaultUISchemaElements(Map<String, dynamic> properties, {String path = ""}) {
    List<ui.LayoutElement> elements = [];
    for (String key in properties.keys) {
      // final element = properties[key];
      // if (element["type"] == "object") {
      //   elements.add(ui.LayoutElement(
      //     type: ui.LayoutElementType.GROUP,
      //     elements: generateDefaultUISchemaElements(element['properties'], path: "$path/$key/properties"),
      //     options: ui.LayoutElementOptions(label: element['title'] ?? key),
      //   ));
      // } else {
      elements.add(ui.LayoutElement(
        type: ui.LayoutElementType.CONTROL,
        scope: "$path/$key",
      ));
      // }
    }
    return elements;
  }

  // traverse the json schema and generate a default ui schema. This schema has a control element for every element in the json schema
  return ui.UiSchema(
      version: "2.0",
      layout: ui.Layout(elements: generateDefaultUISchemaElements(jsonSchema, path: "/properties"), type: ui.LayoutType.VERTICAL_LAYOUT));
}

dynamic toEncodable(dynamic value) {
  if (value is DateTime) {
    return value.toIso8601String();
  } else if (value is Map) {
    return value.map((k, v) => MapEntry(k, toEncodable(v)));
  } else if (value is List) {
    return value.map(toEncodable).toList();
  }
  return value;
}

/// Converts a JSON pointer path to a properties-prefixed path for schema traversal.
///
/// This function transforms a path like `foo/bar/baz` into `/properties/foo/properties/bar/properties/baz`.
/// If the path starts with `#`, it is removed. If the path is empty or already starts with `/properties`, it is returned unchanged.
///
/// Useful for converting flat JSON pointer paths to the format expected by schema libraries.
///
/// Examples:
/// ```dart
/// getPathWithProperties('foo/bar') // => '/properties/foo/properties/bar'
/// getPathWithProperties('#/foo/bar') // => '/properties/foo/properties/bar'
/// getPathWithProperties('') // => ''
/// getPathWithProperties('/properties/foo') // => '/properties/foo'
/// ```
String getPathWithProperties(String path) {
  if (path.startsWith("#")) {
    path = path.substring(1);
  }
  // Only treat initial /properties/ prefix as special
  if (path == "" || path.startsWith("/properties/")) {
    return path;
  }
  path = path.replaceFirst(RegExp(r'^/+'), ''); // Remove leading slashes
  List<String> pathParts = path.split('/');
  String newPath = "";
  for (final part in pathParts) {
    if (part.isNotEmpty) {
      newPath += "/properties/$part";
    }
  }
  return newPath;
}

/// gets an object from a json
/// [path] the path of the object in the json
/// [json] the json object
JsonSchema? getObjectFromJson(
  JsonSchema json,
  String path,
) {
  List<String> pathParts = getPropertyKeysFromPath(path);
  JsonSchema? object = json;
  try {
    for (String part in pathParts) {
      object = object?.properties[part];
    }
  } catch (e) {
    return null;
  }
  return object;
}

/// get List of property keys from json pointer
/// Invalid paths should throw error
List<String> getPropertyKeysFromPath(String path) {
  List<String> keys = [];
  path = getPathWithoutPrefix(path);
  if (path == "") {
    return keys;
  }
  List<String> pathParts = path.split('/');

  /// add every second part as the first one is properties and can be ignored
  for (int i = 0; i < pathParts.length; i += 2) {
    keys.add(pathParts[i]);
  }
  return keys;
}

/// get path without prefix /properties or #/properties
String getPathWithoutPrefix(String path) {
  const prefixes = ['/properties/', '#/properties/'];
  for (String prefix in prefixes) {
    if (path.startsWith(prefix)) {
      return path.substring(prefix.length);
    }
  }
  return path;
}

/// Initializes showOn dependencies for a given JSON schema and optional form data.
///
/// This function recursively traverses the provided [properties] (from a [JsonSchema]) and builds a map of default values
/// for each property, suitable for use in conditional visibility logic (showOn). Array properties are initialized with
/// a list of nulls if [minItems] is specified, or an empty list otherwise. Object properties are recursively processed.
/// If [formData] is provided, its values are used as initial values for matching keys. If a property has a default value
/// in the schema, it is used. For date/time formats, the string `"\$now"` is replaced with the current [DateTime].
///
/// Returns a map of property paths (e.g. `/properties/foo`) to their initialized values.
///
/// Example:
/// ```dart
/// final schema = await JsonSchema.create({
///   'type': 'object',
///   'properties': {
///     'arr': {'type': 'array', 'minItems': 2},
///     'bar': {
///       'type': 'object',
///       'properties': {
///         'baz': {'type': 'integer'},
///       },
///     },
///   },
/// });
/// final deps = initShowOnDependencies(schema.properties, null);
/// // deps['/properties/arr'] == [null, null]
/// // deps['/properties/bar/properties/baz'] == null
/// ```
Map<String, dynamic> initShowOnDependencies(Map<String, JsonSchema>? properties, Map<String, dynamic>? formData) {
  dynamic formatInput(dynamic value, JsonSchema schema) {
    if (schema.format == "date-time" || schema.format == "date" || schema.format == "time") {
      if (value == "\$now") {
        return DateTime.now();
      }
      // TODO logging if invalid
      return DateTime.tryParse(value);
    }
    return value;
  }

  if (properties == null) return {};
  final Map<String, dynamic> dependencies = {};

  for (final entry in properties.entries) {
    final String key = entry.key;
    final JsonSchema jsonSchema = entry.value;
    SchemaType? schemaType;
    try {
      schemaType = jsonSchema.type;
    } catch (e) {
      schemaType = null;
    }
    if (schemaType == SchemaType.array) {
      if (formData != null && formData.containsKey(key)) {
        dependencies["/properties/$key"] = formData[key];
      } else if (jsonSchema.defaultValue != null) {
        dependencies["/properties/$key"] = jsonSchema.defaultValue;
      } else if (jsonSchema.minItems != null) {
        // final minItems = safeParseInt(jsonSchema.minItems);
        // dependencies["/properties/$key"] = List.generate(minItems, (_) => null, growable: true);
        dependencies["/properties/$key"] = List.filled(
          safeParseInt(jsonSchema.minItems),
          null,
          growable: true,
        );
      } else {
        dependencies["/properties/$key"] = [];
      }
    }
    if (schemaType == SchemaType.object) {
      final recursiveFormData = formData == null
          ? null
          : formData.containsKey(key)
              ? formData[key]
              : null;
      final nestedDependencies = initShowOnDependencies(jsonSchema.properties, recursiveFormData);
      nestedDependencies.forEach((nestedKey, nestedValue) {
        dependencies["/properties/$key$nestedKey"] = nestedValue;
      });
    } else if (formData != null && formData.containsKey(key)) {
      final formDataKey = formData[key];
      if (formDataKey is List) {
        dependencies["/properties/$key"] = formDataKey;
      } else {
        dependencies["/properties/$key"] = formatInput(formData[key], jsonSchema);
      }
    } else if (jsonSchema.defaultValue != null) {
      dependencies["/properties/$key"] = formatInput(jsonSchema.defaultValue, jsonSchema);
    } else {
      // Set default based on type if not set
      // if (element["type"] == "string") {
      //   dependencies["/properties/$key"] = "";
      // } else if (element["type"] == "integer" || element["type"] == "number") {
      //   // TODO use minValue if available. But it would be better to just evaluate all conditions to false if no value is set and let the ui component handle the default value (same behavior as vue json forms)
      //   dependencies["/properties/$key"] = 0;
      //   if (element.containsKey('minimum')) {
      //     dependencies["/properties/$key"] = element['minimum'];
      //   } else {
      //     dependencies["/properties/$key"] = 0;
      //   }
      // } else {
      //   dependencies["/properties/$key"] = null;
      // }
      dependencies["/properties/$key"] = null;
    }
  }
  return dependencies;
}

/// Recursively resets the provided dependencies map
/// most likely no longer needed as all elements are reset when initShowOnDependencies is called
// void resetShowOnDependencies(Map<String, dynamic> dependencies) {
//   dependencies.forEach((key, value) {
//     if (value is Map<String, dynamic>) {
//       resetShowOnDependencies(value);
//     } else if (value is List) {
//       for (var item in value) {
//         if (item is ListItem) {
//           final value = item.value;
//           if (value is Map<String, dynamic>) {
//             resetShowOnDependencies(value);
//           } else {
//             item.value = null;
//           }
//         }
//       }
//     } else {
//       dependencies[key] = null;
//     }
//   });
// }

/// Mixin to provide a safe setState method that checks if the widget is still mounted
mixin SafeSetStateMixin<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
