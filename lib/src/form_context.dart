import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_rule_evaluator.dart';
import 'package:json_schema/json_schema.dart';

class FormContext extends InheritedWidget {
  final void Function(Map<String, dynamic>?)? onFormSubmitSaveCallback;
  final void Function(Map<String, dynamic>?, ui.Request?)? onFormRequestCallback;
  final Map<String, dynamic> showOnDependencies;
  final JsonSchema jsonSchemaModel;
  final RitaRuleEvaluator ritaEvaluator;
  final Function(String, dynamic) setValueForShowOn;
  final dynamic Function(String path, {Map<String, int>? selfIndices}) checkValueForShowOn;
  final Function(String) isRequired;
  final Map<String, dynamic> Function()? getFullFormData;
  final Function(String, dynamic) onFormValueSaved;
  final Function(String, dynamic) onFormValueChanged;
  final Function({bool focusOnInvalid, bool autoScrollWhenFocusOnInvalid}) saveAndValidate;
  final VoidCallback reset;
  final Map<String, dynamic> Function() getFormValues;
  final bool Function({required ui.ShowOnProperty? showOn, Map<String, int>? selfIndices, required bool? parentIsShown}) elementShown;

  const FormContext({
    super.key,
    this.onFormSubmitSaveCallback,
    this.onFormRequestCallback,
    required this.showOnDependencies,
    required this.jsonSchemaModel,
    required this.ritaEvaluator,
    required this.setValueForShowOn,
    required this.checkValueForShowOn,
    required this.isRequired,
    required this.getFullFormData,
    required this.onFormValueSaved,
    required this.onFormValueChanged,
    required this.saveAndValidate,
    required this.reset,
    required this.getFormValues,
    required this.elementShown,
    required super.child,
  });

  static FormContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormContext>();
  }

  @override
  bool updateShouldNotify(FormContext oldWidget) {
    // Use mapEquals for deep comparison to ensure updates are triggered when content changes
    return !mapEquals(showOnDependencies, oldWidget.showOnDependencies);
  }

  // bool elementShown({
  //   ui.ShowOnProperty? showOn,
  //   bool? parentIsShown,
  //   Map<String, int>? selfIndices,
  // }) {
  //   return elementShown(showOn: showOn, selfIndices: selfIndices, parentIsShown: parentIsShown);
  //   // // Use Rita checking if selfIndices are provided
  //   // if (selfIndices != null && selfIndices.isNotEmpty) {
  //   //   return checkElementShownWithRita(showOn, selfIndices, parentIsShown);
  //   // }

  //   // // Fall back to old showOn evaluation
  //   // return isElementShown(
  //   //   parentIsShown: parentIsShown ?? true,
  //   //   showOn: showOn,
  //   //   ritaDependencies: ritaDependencies,
  //   //   checkValueForShowOn: checkValueForShowOn,
  //   // );
  // }
}
