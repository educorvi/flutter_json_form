import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/custom_form_fields/form_field_text.dart';
import 'package:flutter_json_forms/src/widgets/form_utils/form_field_utils.dart';
import '../../utils/show_on.dart';
import '../custom_form_fields/html_widget.dart';

class FormFieldWrapper extends StatelessWidget {
  final FormFieldContext context;
  final Widget child;
  final bool showLabel;

  const FormFieldWrapper({
    super.key,
    required this.context,
    required this.child,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext buildContext) {
    final preHtml = context.options?.formattingOptions?.preHtml;
    final postHtml = context.options?.formattingOptions?.postHtml;

    List<Widget> columnChildren = [];

    if (preHtml != null && preHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: preHtml));
    }

    final labelText =
        FormFieldUtils.getLabel(context, getLabel: UIConstants.labelSeparateText, uiSchemaLabel: context.options?.formattingOptions?.label);

    if (context.showLabel && showLabel && labelText != null) {
      columnChildren.add(
        FormFieldText(
          labelText,
          required: context.required,
        ),
      );
    }

    columnChildren.add(child);

    if (postHtml != null && postHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: postHtml));
    }

    return handleShowOn(
      child: MergeSemantics(
        child: columnChildren.length == 1
            ? columnChildren.first
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren,
              ),
      ),
      parentIsShown: context.parentIsShown ?? true,
      showOn: context.showOn,
      ritaDependencies: context.ritaDependencies,
      checkValueForShowOn: context.checkValueForShowOn,
      selfIndices: context.selfIndices,
      ritaEvaluator: context.ritaEvaluator,
      getFullFormData: context.getFullFormData,
    );
  }
}
