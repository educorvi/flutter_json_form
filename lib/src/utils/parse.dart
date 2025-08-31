num safeParseNum(dynamic value) {
  if (value is num) {
    return value;
  } else if (value is String) {
    return num.tryParse(value) ?? 0;
  }
  return 0;
}

double safeParseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

int? trySafeParseInt(dynamic value) {
  if (value is int) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

int safeParseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
