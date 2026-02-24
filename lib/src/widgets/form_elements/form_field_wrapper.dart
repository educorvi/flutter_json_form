import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_field_context.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/widgets/constants.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_help.dart';
import 'package:flutter_json_forms/src/widgets/shared/common.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_field_utils.dart';
import 'package:flutter_json_forms/src/widgets/form_elements/form_visibility.dart';
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

    final layoutHeaderScope = LayoutHeaderScope.maybeOf(context);
    final bool suppressComplexHeader = layoutHeaderScope?.hasHeader == true && (complexElement ?? false);
    final bool shouldIgnoreLabel = ignoreLabel == true || suppressComplexHeader;
    final labelText = shouldIgnoreLabel ? null : FormFieldUtils.getLabel(formFieldContext, getLabel: complexElement ?? UIConstants.labelSeparateText);
    final String? descriptionText = suppressComplexHeader ? null : formFieldContext.description;

    Widget? labelRow;
    final bool hasHeaderContent = labelText != null || (complexElement == true && descriptionText != null);
    if ((formFieldContext.showLabel && hasHeaderContent) || help != null) {
      labelRow = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasHeaderContent)
            Expanded(
              child: complexElement == true
                  ? withHeader(context, labelText, descriptionText, null, required: formFieldContext.required)
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

    final isVisible = formFieldContext.isShownCallback();

    return buildAnimatedVisibility(
      child: MergeSemantics(
        child: withCss(
          context,
          columnChildren.length == 1
              ? columnChildren.first
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columnChildren,
                ),
          cssClass: formFieldContext.options?.formattingOptions?.cssClass,
        ),
      ),
      isVisible: isVisible,
    );
  }
}
