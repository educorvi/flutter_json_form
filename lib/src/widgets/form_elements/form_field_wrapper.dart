import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_field_utils.dart';
import '../../utils/show_on.dart';
import '../custom_form_fields/html_widget.dart';
import '../custom_form_fields/animated_tooltip.dart';

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

    final labelText = FormFieldUtils.getLabel(context, getLabel: UIConstants.labelSeparateText);

    if (context.showLabel && showLabel && labelText != null) {
      columnChildren.add(
        Row(
          children: [
            Expanded(
              child: Text(labelText),
            ),
            if (context.options?.formattingOptions?.help != null)
              AnimatedTooltip(
                content: context.options!.formattingOptions!.help!.text,
                label: context.options!.formattingOptions!.help!.label ?? "?",
              ),
          ],
        ),
      );
    }

    columnChildren.add(child);

    if (postHtml != null && postHtml.isNotEmpty) {
      columnChildren.add(CustomHtmlWidget(htmlData: postHtml));
    }

    return handleShowOn(
      child: columnChildren.length == 1
          ? columnChildren.first
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren,
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
