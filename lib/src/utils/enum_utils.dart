/// Utility to map enum values to display titles using enumTitles from FieldSpecificOptions or EnumOptions.
/// If no mapping is provided, returns the value itself as the title.
List<MapEntry<String, String>> mapEnumValuesToTitles(List<String> values, Map<String, String>? enumTitles) {
  return values.map((key) => MapEntry(key, enumTitles?[key] ?? key)).toList();
}
