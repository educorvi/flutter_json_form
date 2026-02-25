import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/utils/data/ui_schema_extensions.dart';
import 'package:flutter_json_forms/src/utils/utils.dart';

bool isElementShown({
  bool? parentIsShown,
  ui.ShowOnProperty? showOn,
  bool? Function()? getRitaResult,
  required dynamic Function(String path) checkValueForShowOn,
}) {
  final logger = FormLogger.showOn;

  if (parentIsShown == false) {
    logger.finer('Element hidden due to parent visibility');
    return false;
  }
  if (showOn == null) {
    logger.finer('No showOn condition - element visible');
    return true;
  }
  if (showOn.rule != null && showOn.id != null && getRitaResult != null) {
    final result = getRitaResult();
    if (result != null) {
      logger.finer('Rita rule ${showOn.id}: $result');
      return result;
    }
    logger.finer('Rita rule ${showOn.id} unresolved - falling back to classic evaluation');
  }
  // Fallback: classic showOn
  final value = checkValueForShowOn(showOn.path ?? "");
  if (value == null && showOn.referenceValue != null) {
    logger.fine('ShowOn path "${showOn.path}" returned null, expecting ${showOn.referenceValue} - hidden');
    return false;
  }

  final result = evaluateCondition(showOn.type, value, showOn.referenceValue);
  logger.fine('ShowOn condition: ${showOn.path} ${showOn.type} ${showOn.referenceValue} = $result (value: $value)');
  return result;
}

/// evaluates the condition based on the operator and the operands
bool evaluateCondition(ui.ShowOnFunctionType? operator, dynamic operand1, dynamic operand2) {
  final logger = FormLogger.showOn;

  try {
    switch (operator) {
      case ui.ShowOnFunctionType.EQUALS:
        return operand1 == operand2;
      case ui.ShowOnFunctionType.GREATER:
        return operand1 > operand2;
      case ui.ShowOnFunctionType.SMALLER:
        return operand1 < operand2;
      case ui.ShowOnFunctionType.GREATER_OR_EQUAL:
        return operand1 >= operand2;
      case ui.ShowOnFunctionType.SMALLER_OR_EQUAL:
        return operand1 <= operand2;
      case ui.ShowOnFunctionType.NOT_EQUALS:
        return operand1 != operand2;
      case null:
        logger.warning('ShowOn condition has null operator - defaulting to false');
        return false;
    }
  } catch (e, stackTrace) {
    logger.severe('Error evaluating showOn condition: $operator($operand1, $operand2)', e, stackTrace);
    return false;
  }
}

/// Recursively collects all Rita rules from a map of descendant control overrides.
///
/// Traverses the [overrides] map, collecting every [ShowOnProperty] with a non-null `id`.
/// If nested descendant overrides are present, collects rules from those as well.
///
/// Returns a flat list of all found Rita rules.
List<ui.ShowOnProperty> collectDescendantRitaRules(Map<String, ui.DescendantControlOverrides> overrides) {
  final List<ui.ShowOnProperty> rules = [];
  for (var entry in overrides.entries) {
    if (entry.value.showOn?.id != null) {
      rules.add(entry.value.showOn!);
    }
    final nested = entry.value.options?.formattingOptions?.descendantControlOverrides;
    if (nested != null) {
      rules.addAll(collectDescendantRitaRules(nested));
    }
  }
  return rules;
}

/// Recursively collects all Rita rules from a list of layout elements.
///
/// Traverses [elements], collecting every [ShowOnProperty] with a non-null `id`.
/// Also collects rules from nested elements and descendant control overrides.
///
/// Returns a flat list of all found Rita rules.
List<ui.ShowOnProperty> collectRitaRules(List<ui.LayoutElement> elements) {
  final List<ui.ShowOnProperty> rules = [];
  for (var element in elements) {
    if (element.asElements != null) {
      rules.addAll(collectRitaRules(element.asElements!));
    }
    if (element.showOn?.id != null) {
      rules.add(element.showOn!);
    }
    final overrides = element.asControlOptions?.formattingOptions?.descendantControlOverrides;
    if (overrides != null) {
      rules.addAll(collectDescendantRitaRules(overrides));
    }
  }
  return rules;
}

/// Resolves a normalized schema [path] against the provided [processedValues]
/// map (output of `processFormValues`) while honoring [selfIndices] for array
/// descendants.
dynamic resolveShowOnValue(
  Map<String, dynamic> processedValues,
  String normalizedPath, {
  Map<String, int>? selfIndices,
}) {
  if (normalizedPath.isEmpty) {
    return processedValues;
  }

  final segments = _extractDataPathSegments(normalizedPath, selfIndices: selfIndices);
  dynamic current = processedValues;

  for (final segment in segments) {
    if (segment is String) {
      if (current is Map) {
        current = current[segment];
      } else {
        return null;
      }
    } else if (segment is int) {
      if (current is List && segment >= 0 && segment < current.length) {
        current = current[segment];
      } else {
        return null;
      }
    }

    if (current == null) {
      return null;
    }
  }

  return current;
}

List<dynamic> _extractDataPathSegments(String normalizedPath, {Map<String, int>? selfIndices}) {
  if (normalizedPath.isEmpty) {
    return const [];
  }

  final parts = normalizedPath.split('/');
  final segments = <dynamic>[];
  final normalizedIndices = selfIndices == null
      ? const <String, int>{}
      : {
          for (final entry in selfIndices.entries) getPathWithProperties(entry.key): entry.value,
        };

  String schemaScope = '';
  for (int i = 0; i < parts.length; i++) {
    final part = parts[i];
    if (part.isEmpty) continue;

    if (part == 'properties') {
      if (i + 1 < parts.length) {
        final propertyName = parts[++i];
        schemaScope = '$schemaScope/properties/$propertyName';
        segments.add(propertyName);
      }
    } else if (part == 'items') {
      int? index;
      if (i + 1 < parts.length) {
        index = int.tryParse(parts[i + 1]);
        if (index != null) {
          i++;
        }
      }

      index ??= normalizedIndices[schemaScope];
      if (index != null) {
        segments.add(index);
      }

      schemaScope = '$schemaScope/items';
    }
  }

  return segments;
}
