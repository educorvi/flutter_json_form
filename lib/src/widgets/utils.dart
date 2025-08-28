import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;

Color getAlternatingColor(BuildContext context, int nestingLevel) {
  return nestingLevel % 2 == 1 ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainerHigh;
}

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
Widget handleShowOn(
    {ui.ShowOnProperty? showOn,
    required Widget child,
    Map<String, bool>? ritaDependencies,
    required dynamic Function(String) checkValueForShowOn,
    bool? parentIsShown}) {
  bool isVisible =
      isElementShown(parentIsShown: parentIsShown, showOn: showOn, ritaDependencies: ritaDependencies, checkValueForShowOn: checkValueForShowOn);
  return AnimatedCrossFade(
    duration: const Duration(milliseconds: 450),
    sizeCurve: Curves.easeInOut,
    firstChild: child,
    secondChild: Container(),
    // Invisible child
    crossFadeState: isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  );
}
