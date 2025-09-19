/// Safely parses a dynamic value to a [num].
///
/// Returns the input unchanged if it's already a [num].
/// Attempts to parse if it's a [String] using [num.tryParse].
/// Returns 0 for any other type or if parsing fails.
///
/// Examples:
/// ```dart
/// safeParseNum(42) => 42
/// safeParseNum(42.5) => 42.5
/// safeParseNum('123') => 123
/// safeParseNum('invalid') => 0
/// safeParseNum(null) => 0
/// ```
num safeParseNum(dynamic value) {
  if (value is num) {
    return value;
  } else if (value is String) {
    return num.tryParse(value) ?? 0;
  }
  return 0;
}

/// Safely parses a dynamic value to a [double].
///
/// Converts the input to double if it's a [num].
/// Attempts to parse if it's a [String] using [double.tryParse].
/// Returns 0.0 for any other type or if parsing fails.
///
/// Examples:
/// ```dart
/// safeParseDouble(42) => 42.0
/// safeParseDouble('42.5') => 42.5
/// safeParseDouble('invalid') => 0.0
/// safeParseDouble(null) => 0.0
/// ```
double safeParseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

/// Attempts to safely parse a dynamic value to an [int], returning null on failure.
///
/// Converts the input to int (truncated) if it's a [num].
/// Attempts to parse if it's a [String] using [int.tryParse].
/// Returns null for any other type or if parsing fails.
///
/// This is useful when you need to distinguish between a successful parse
/// and a failed parse, unlike [safeParseInt] which returns 0 on failure.
///
/// Examples:
/// ```dart
/// trySafeParseInt(42) => 42
/// trySafeParseInt(42.7) => 42 (truncated)
/// trySafeParseInt('123') => 123
/// trySafeParseInt('42.5') => null (decimal strings not supported)
/// trySafeParseInt('invalid') => null
/// trySafeParseInt(null) => null
/// ```
int? trySafeParseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

/// Safely parses a dynamic value to an [int].
///
/// Converts the input to int (truncated) if it's a [num].
/// Attempts to parse if it's a [String] using [int.tryParse].
/// Returns 0 for any other type or if parsing fails.
///
/// Examples:
/// ```dart
/// safeParseInt(42) => 42
/// safeParseInt(42.7) => 42 (truncated)
/// safeParseInt('123') => 123
/// safeParseInt('42.5') => 0 (decimal strings not supported)
/// safeParseInt('invalid') => 0
/// safeParseInt(null) => 0
/// ```
int safeParseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
