import 'dart:convert';

/// Utility to map enum values to display titles using enumTitles from FieldSpecificOptions or EnumOptions.
/// If no mapping is provided, returns the value itself as the title.
///
/// This function works with any type of enum value (primitive, object, array).
/// The key is converted to a string representation for lookup in enumTitles.
List<MapEntry<dynamic, String>> mapEnumValuesToTitles(List<dynamic> values, Map<String, String>? enumTitles) {
  return values.map((value) {
    // Create a string key for lookup in enumTitles
    final stringKey = _valueToStringKey(value);
    final title = enumTitles?[stringKey] ?? stringKey;
    return MapEntry(value, title);
  }).toList();
}

/// Converts any value to a string key for enumTitles lookup
String _valueToStringKey(dynamic value) {
  if (value == null) return 'null';
  if (value is String || value is num || value is bool) {
    return value.toString();
  }
  // For objects and arrays, use JSON encoding as the key
  return jsonEncode(value);
}
