import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_error.dart';
import '../../models/ui_schema.dart' as ui;

import '../../utils/utils.dart';

class FormControl extends StatelessWidget {
  final ui.Control control;
  final int nestingLevel;
  final bool? isShownFromParent;

  const FormControl({
    super.key,
    required this.control,
    required this.nestingLevel,
    this.isShownFromParent,
  });

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;

    String scope = control.scope.startsWith("#") ? control.scope.substring(1) : control.scope;
    final ui.ControlOptions? options = control.options;
    final jsonSchemaFromScope = getObjectFromJson(formContext.jsonSchemaModel, scope);

    if (jsonSchemaFromScope == null) {
      return FormError("Control element must have a valid scope. Scope $scope not found in json schema.");
    }

    final format = control.options?.fieldSpecificOptions?.format;
    final bool parentIsShown = isShownFromParent ?? true;

    // bool isShown() => isElementShown(
    //       parentIsShown: parentIsShown,
    //       showOn: control.showOn,
    //       ritaDependencies: formContext.ritaDependencies,
    //       checkValueForShowOn: formContext.checkValueForShowOn,
    //     );

    // bool isShown = formContext.elementShown(
    //   scope: scope,
    //   showOn: control.showOn,
    //   parentIsShown: parentIsShown,
    // );

    return FormElementFactory.createFormElement(FormFieldContext.fromFormContext(
      context: context,
      scope: scope,
      id: scope,
      jsonSchema: jsonSchemaFromScope,
      required: formContext.isRequired(scope),
      nestingLevel: nestingLevel,
      options: options,
      format: format,
      showOn: control.showOn,
      initialValue: formContext.checkValueForShowOn(scope),
      parentIsShown: parentIsShown,
      selfIndices: const {},
      onChanged: (value) => formContext.onFormValueChanged(scope, value),
      onSavedCallback: (value) => {
        formContext.elementShown(
          scope: scope,
          showOn: control.showOn,
          parentIsShown: parentIsShown,
          selfIndices: const {}, // Form controls don't have selfIndices
        )
            ? formContext.onFormValueSaved(scope, value)
            : null,
      },
    ));
    // return FormElementFormControl(
    //   options: options,
    //   format: format,
    //   scope: scope,
    //   id: scope,
    //   nestingLevel: nestingLevel + 1,
    //   required: formContext.isRequired(scope),
    //   jsonSchema: jsonSchemaFromScope,
    //   initialValue: formContext.checkValueForShowOn(scope),
    //   isShownCallback: isShown,
    //   onChanged: (value) => formContext.onFormValueChanged(scope, value),
    //   onSavedCallback: (value) => formContext.onFormValueSaved(scope, value),
    //   parentIsShown: parentIsShown,
    //   ritaDependencies: formContext.ritaDependencies,
    //   checkValueForShowOn: formContext.checkValueForShowOn,
    //   showOn: control.showOn,
    //   ritaEvaluator: formContext.ritaEvaluator,
    //   getFullFormData: formContext.getFullFormData,
    //   selfIndices: const {},
    // );
  }
}
