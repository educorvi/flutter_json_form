import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/form_element.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import '../../models/ui_schema.dart' as ui;
import '../../utils/show_on.dart';
import '../shared/common.dart';

class FormObjectField extends StatefulWidget {
  final FormFieldContext formFieldContext;

  const FormObjectField({
    super.key,
    required this.formFieldContext,
  });

  @override
  State<FormObjectField> createState() => _FormObjectFieldState();
}

class _FormObjectFieldState extends State<FormObjectField> {
  final Map<String, dynamic> formSubmitValues = {};

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;

    bool objectIsShown() => widget.formFieldContext.isShownCallback();

    List<Widget> elements = [];
    for (var key in widget.formFieldContext.jsonSchema.properties.keys) {
      bool childRequired = widget.formFieldContext.jsonSchema.propertyRequired(key) || widget.formFieldContext.required;
      String childScope = "${widget.formFieldContext.scope}/properties/$key";

      ui.DescendantControlOverrides? descendantControlOverrides =
          widget.formFieldContext.options?.formattingOptions?.descendantControlOverrides?[childScope];

      final childOptions = descendantControlOverrides?.options ?? widget.formFieldContext.options;
      final childShowOn = descendantControlOverrides?.showOn ?? widget.formFieldContext.showOn;

      bool childIsShown() => isElementShown(
            parentIsShown: objectIsShown(),
            showOn: childShowOn,
            ritaDependencies: formContext.ritaDependencies,
            checkValueForShowOn: formContext.checkValueForShowOn,
          );

      elements.add(FormElementFactory.createFormElement(widget.formFieldContext.createChildContext(
          childScope: childScope,
          childId: '${widget.formFieldContext.id}/properties/$key',
          childJsonSchema: widget.formFieldContext.jsonSchema.properties[key]!,
          childOptions: childOptions,
          childShowOn: childShowOn,
          childInitialValue:
              widget.formFieldContext.initialValue is Map<String, dynamic> ? widget.formFieldContext.initialValue["/properties/$key"] : null,
          childRequired: childRequired,
          // childShowLabel: childShowLabel,
          childSelfIndices: widget.formFieldContext.selfIndices,
          childOnChanged: (value) {
            if (widget.formFieldContext.onChanged != null) {
              final newValue =
                  Map<String, dynamic>.from(widget.formFieldContext.initialValue is Map<String, dynamic> ? widget.formFieldContext.initialValue : {});
              newValue[key] = value;
              widget.formFieldContext.onChanged!(newValue);
            }
          },
          childOnSavedCallback: (value) {
            if (value != null && value != "" && childIsShown()) {
              formSubmitValues[key] = value;
            } else {
              formSubmitValues.remove(key);
            }
            if (widget.formFieldContext.onSavedCallback != null && key == widget.formFieldContext.jsonSchema.properties.keys.last) {
              if (formSubmitValues.isNotEmpty) {
                widget.formFieldContext.onSavedCallback!(formSubmitValues);
              }
            }
          })));
    }

    Widget objectElements = getLineContainer(
      child: Padding(
        padding: const EdgeInsets.only(left: UIConstants.groupPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: elements,
        ),
      ),
    );

    String? label = FormFieldUtils.getLabel(widget.formFieldContext);

    Widget objectWidget = label != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              objectElements,
            ],
          )
        : objectElements;

    return handleShowOn(
      child: objectWidget,
      checkValueForShowOn: formContext.checkValueForShowOn,
      parentIsShown: widget.formFieldContext.parentIsShown,
      showOn: widget.formFieldContext.showOn,
      ritaDependencies: formContext.ritaDependencies,
      selfIndices: widget.formFieldContext.selfIndices,
      ritaEvaluator: widget.formFieldContext.ritaEvaluator,
      getFullFormData: widget.formFieldContext.getFullFormData,
    );
  }
}
