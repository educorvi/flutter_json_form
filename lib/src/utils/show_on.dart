import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_rule_evaluator.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';

bool isElementShown({
  bool? parentIsShown,
  ui.ShowOnProperty? showOn,
  Map<String, bool>? ritaDependencies,
  required dynamic Function(String path) checkValueForShowOn,
}) {
  final logger = FormLogger.showOn;

  if (parentIsShown == false) {
    logger.fine('Element hidden due to parent visibility');
    return false;
  }
  if (showOn == null) {
    logger.finer('No showOn condition - element visible');
    return true;
  }
  if (showOn.rule != null && showOn.id != null && ritaDependencies != null) {
    // Rita rule: use precomputed dependency
    final result = ritaDependencies[showOn.id!] == true;
    logger.finest('Rita rule ${showOn.id}: $result');
    return result;
  }
  // Fallback: classic showOn
  final value = checkValueForShowOn(showOn.path ?? "");
  if (value == null && showOn.referenceValue != null) {
    logger.fine('ShowOn path "${showOn.path}" returned null, expecting ${showOn.referenceValue} - hidden');
    return false;
  }

  final result = evaluateCondition(showOn.type, checkValueForShowOn(showOn.path ?? ""), showOn.referenceValue);
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

/// handles the visibility of an element based on the showOn property.
/// Uses the _evaluateCondition function to evaluate the condition
Widget handleShowOn({
  ui.ShowOnProperty? showOn,
  required Widget child,
  Map<String, bool>? ritaDependencies,
  required dynamic Function(String) checkValueForShowOn,
  bool? parentIsShown,
  // Optional per-element Rita evaluation
  Map<String, int>? selfIndices,
  RitaRuleEvaluator? ritaEvaluator,
  Map<String, dynamic> Function()? getFullFormData,
  LayoutDirection? layoutDirection = LayoutDirection.vertical,
}) {
  // Widget formattedChild = Padding(
  //   padding: layoutDirection == LayoutDirection.horizontal // TODO: pass down if first or last element and whn not to render the padding
  //       ? const EdgeInsets.symmetric(horizontal: UIConstants.elementPadding)
  //       : const EdgeInsets.symmetric(vertical: UIConstants.elementPadding),
  //   child: child,
  // );

  if (showOn == null) {
    return child; // formattedChild;
  }
  // If this element has a Rita rule and evaluator/context are provided, evaluate per element with $selfIndices
  if (showOn.rule != null && showOn.id != null && ritaEvaluator != null && getFullFormData != null) {
    return _RitaRuleWidget(
      showOn: showOn,
      ritaEvaluator: ritaEvaluator,
      getFullFormData: getFullFormData,
      selfIndices: selfIndices,
      parentIsShown: parentIsShown,
      ritaDependencies: ritaDependencies,
      checkValueForShowOn: checkValueForShowOn,
      child: child,
    );
  }

  // Fallback to existing logic (legacy showOn or precomputed Rita without indices)
  final bool isVisible =
      isElementShown(parentIsShown: parentIsShown, showOn: showOn, ritaDependencies: ritaDependencies, checkValueForShowOn: checkValueForShowOn);
  return AnimatedCrossFade(
    duration: const Duration(milliseconds: 400),
    sizeCurve: Curves.easeInOut,
    firstChild: child,
    secondChild: Container(),
    crossFadeState: isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  );
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
    if (element.elements != null) {
      rules.addAll(collectRitaRules(element.elements!));
    }
    if (element.showOn?.id != null) {
      rules.add(element.showOn!);
    }
    final overrides = element.options?.formattingOptions?.descendantControlOverrides;
    if (overrides != null) {
      rules.addAll(collectDescendantRitaRules(overrides));
    }
  }
  return rules;
}

/// A widget that re-evaluates Rita rules whenever the FormContext changes
class _RitaRuleWidget extends StatelessWidget {
  final ui.ShowOnProperty showOn;
  final RitaRuleEvaluator ritaEvaluator;
  final Map<String, dynamic> Function() getFullFormData;
  final Map<String, int>? selfIndices;
  final bool? parentIsShown;
  final Map<String, bool>? ritaDependencies;
  final dynamic Function(String) checkValueForShowOn;
  final Widget child;

  // Static tracking of logged revisions to avoid duplicate evalData logging
  static int _lastLoggedRevision = -1;

  const _RitaRuleWidget({
    required this.showOn,
    required this.ritaEvaluator,
    required this.getFullFormData,
    required this.selfIndices,
    required this.parentIsShown,
    required this.ritaDependencies,
    required this.checkValueForShowOn,
    required this.child,
  });

  static bool _hasLoggedDataForRevision(int revision) {
    return revision <= _lastLoggedRevision;
  }

  static void _markRevisionLogged(int revision) {
    _lastLoggedRevision = revision;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to FormContext changes via dependency
    final formContext = FormContext.of(context);

    return FutureBuilder<bool>(
      // Use revision to force rebuild when dependencies change
      // key: ValueKey('${showOn.id}_${formContext?.ritaDependenciesRevision}_${selfIndices?.entries.map((e) => '${e.key}:${e.value}').join(',')}'),
      future: _evaluateRule(formContext),
      builder: (context, snapshot) {
        final bool isVisible = snapshot.data == true
            ? true
            : (snapshot.connectionState == ConnectionState.waiting
                ? false
                : isElementShown(
                    parentIsShown: parentIsShown,
                    showOn: showOn,
                    ritaDependencies: ritaDependencies,
                    checkValueForShowOn: checkValueForShowOn,
                  ));

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          sizeCurve: Curves.easeInOut,
          firstChild: child,
          secondChild: Container(),
          crossFadeState: isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        );
      },
    );
  }

  Future<bool> _evaluateRule(FormContext? formContext) async {
    final logger = FormLogger.ritaEvaluator;

    try {
      final evalData = {
        r"$selfIndices": selfIndices ?? <String, int>{},
        ...getFullFormData(),
      };

      // Log evalData only for the first rule in a batch (when revision changes)
      final currentRevision = formContext?.ritaDependenciesRevision ?? 0;
      if (!_hasLoggedDataForRevision(currentRevision)) {
        logger.fine('Rita evaluation batch $currentRevision - evalData: ${jsonEncode(evalData)}');
        _markRevisionLogged(currentRevision);
      }

      logger.finer('Evaluating Rita rule ${showOn.id}');
      final result = await ritaEvaluator.evaluate(showOn.id!, jsonEncode(evalData));
      logger.finest('Rita rule ${showOn.id} result: $result');

      // Store the result in FormContext for later use during form submission
      if (formContext != null && showOn.id != null) {
        formContext.storeRitaArrayResult(showOn.id!, selfIndices, result);
      }

      return result;
    } catch (e, stackTrace) {
      logger.severe('Rita rule evaluation failed for ${showOn.id}, falling back to traditional showOn', e, stackTrace);
      // Fall back to traditional showOn evaluation
      return isElementShown(
        parentIsShown: parentIsShown,
        showOn: showOn,
        ritaDependencies: ritaDependencies,
        checkValueForShowOn: checkValueForShowOn,
      );
    }
  }
}
