import 'package:flutter/widgets.dart';
import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;
import 'package:flutter_json_forms/src/utils/show_on.dart';
import 'package:json_schema/json_schema.dart';
import 'utils/rita_rule_evaluator/ritaRuleEvaluator.dart';

class FormContext extends InheritedWidget {
  final Map<String, dynamic> showOnDependencies;
  final Map<String, bool> ritaDependencies;
  final JsonSchema jsonSchemaModel;
  final RitaRuleEvaluator ritaEvaluator;
  final Function(String, dynamic) setValueForShowOn;
  final Function(String) checkValueForShowOn;
  final Function(String) isRequired;
  final Map<String, dynamic> Function()? getFullFormData;
  final Function(String, dynamic) onFormValueSaved;
  final Function(String, dynamic) onFormValueChanged;
  final Function({bool focusOnInvalid, bool autoScrollWhenFocusOnInvalid}) saveAndValidate;
  final VoidCallback reset;
  final Map<String, dynamic> Function() getFormValues;

  const FormContext({
    super.key,
    required this.showOnDependencies,
    required this.ritaDependencies,
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
    required super.child,
  });

  static FormContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormContext>();
  }

  @override
  bool updateShouldNotify(FormContext oldWidget) =>
      showOnDependencies != oldWidget.showOnDependencies || ritaDependencies != oldWidget.ritaDependencies;

  bool elementShown({
    required String scope,
    ui.ShowOnProperty? showOn,
    bool? parentIsShown,
  }) {
    return isElementShown(
      parentIsShown: parentIsShown ?? true,
      showOn: showOn,
      ritaDependencies: ritaDependencies,
      checkValueForShowOn: checkValueForShowOn,
    );
  }
}
