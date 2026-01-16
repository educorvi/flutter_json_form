import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_error.dart';
import '../../models/ui_schema.g.dart' as ui;

import '../../utils/utils.dart';

class FormControl extends StatelessWidget {
  final ui.Control control;
  final int nestingLevel;
  final bool isShownFromParent;

  const FormControl({
    super.key,
    required this.control,
    required this.nestingLevel,
    required this.isShownFromParent,
  });

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;

    String scope = control.scope.startsWith("#") ? control.scope.substring(1) : control.scope;
    final ui.Options? options = control.options;
    final jsonSchemaFromScope = getObjectFromJson(formContext.jsonSchemaModel, scope);

    if (jsonSchemaFromScope == null) {
      return FormError("Control element must have a valid scope. Scope $scope not found in json schema.");
    }

    final format = control.options?.inputOptions?.format;
    final bool parentIsShown = isShownFromParent;

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
      initialValue: formContext.checkValueForShowOn(scope), // null, //
      parentIsShown: parentIsShown,
      selfIndices: const {},
      onChanged: (value) => formContext.onFormValueChanged(scope, value),
      onSavedCallback: (value) => {
        formContext.elementShown(showOn: control.showOn, parentIsShown: parentIsShown) ? formContext.onFormValueSaved(scope, value) : null,
      },
    ));
  }
}
