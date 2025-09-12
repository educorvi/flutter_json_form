import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_rule_evaluator.dart';

bool isElementShown({
  bool? parentIsShown,
  ui.ShowOnProperty? showOn,
  Map<String, bool>? ritaDependencies,
  required dynamic Function(String path) checkValueForShowOn,
}) {
  if (parentIsShown == false) return false;
  if (showOn == null) return true;
  if (showOn.rule != null && showOn.id != null && ritaDependencies != null) {
    // Rita rule: use precomputed dependency
    return ritaDependencies[showOn.id!] == true;
  }
  // Fallback: classic showOn
  final value = checkValueForShowOn(showOn.path ?? "");
  if (value == null && showOn.referenceValue != null) {
    return false;
  }

  return evaluateCondition(showOn.type, checkValueForShowOn(showOn.path ?? ""), showOn.referenceValue);
}

/// evaluates the condition based on the operator and the operands
bool evaluateCondition(ui.ShowOnFunctionType? operator, dynamic operand1, dynamic operand2) {
  // TODO as the types are dynamic, type error could occur here. Use stronger typing if possible!
  // maybe try to do the check and if an exception occurs, render an error in the ui
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

/// Collects all Rita rules from descendant control overrides.
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

/// Collects all Rita rules from a list of layout elements.
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
    try {
      final evalData = {
        r"$selfIndices": selfIndices ?? <String, int>{},
        ...getFullFormData(),
      };

      final result = await ritaEvaluator.evaluate(showOn.id!, jsonEncode(evalData));

      // Store the result in FormContext for later use during form submission
      if (formContext != null && showOn.id != null) {
        formContext.storeRitaArrayResult(showOn.id!, selfIndices, result);
      }

      return result;
    } catch (e) {
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
