import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_help.dart';
import 'package:flutter_json_forms/src/widgets/shared/common.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import '../../utils/show_on.dart';
import '../custom_form_input_fields/html_widget.dart';

class FormFieldWrapper extends StatelessWidget {
  final FormFieldContext formFieldContext;
  final Widget child;
  final bool? complexElement;
  final bool? ignoreLabel;

  const FormFieldWrapper({
    super.key,
    required this.formFieldContext,
    required this.child,
    this.complexElement,
    this.ignoreLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (formFieldContext.options?.formattingOptions?.hidden == true) {
      FormLogger.fieldFactory.finest('Field ${formFieldContext.scope} marked as hidden');
      return Visibility(
        maintainState: true,
        visible: false,
        child: child,
      );
    }

    final preHtml = formFieldContext.options?.formattingOptions?.preHtml;
    final postHtml = formFieldContext.options?.formattingOptions?.postHtml;
    final help = formFieldContext.options?.formattingOptions?.help;

    List<Widget> columnChildren = [];

    if (preHtml != null && preHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: preHtml));
    }

    final labelText =
        ignoreLabel == true ? null : FormFieldUtils.getLabel(formFieldContext, getLabel: complexElement ?? UIConstants.labelSeparateText);

    Widget? labelRow;
    if ((formFieldContext.showLabel && labelText != null) || help != null) {
      labelRow = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (labelText != null || formFieldContext.description != null)
            Expanded(
              child: complexElement == true
                  ? withHeader(context, labelText, formFieldContext.description, null, required: formFieldContext.required)
                  : withPrimitiveFieldTitle(context, labelText, null, required: formFieldContext.required),
            ),
          if (help != null)
            Align(
              alignment: Alignment.centerRight,
              child: FormHelp(help: help),
            ),
        ],
      );
    }

    if (labelRow != null) {
      columnChildren.add(labelRow);
    }

    columnChildren.add(child);

    if (postHtml != null && postHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: postHtml));
    }

    return handleShowOn(
      formFieldContext.showOn,
      MergeSemantics(
          child: withCss(
        context,
        columnChildren.length == 1
            ? columnChildren.first
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columnChildren,
              ),
        cssClass: formFieldContext.options?.formattingOptions?.cssClass,
      )),
      formFieldContext.ritaDependencies,
      formFieldContext.checkValueForShowOn,
      formFieldContext.parentIsShown,
      formFieldContext.selfIndices,
      formFieldContext.ritaEvaluator,
      formFieldContext.getFullFormData,
    );
  }
}
