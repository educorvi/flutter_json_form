import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/default_renderer/ui_elements/ui_html.dart';
import 'package:flutter_json_forms/src/rendering/helpers/render_helpers.dart';
import 'package:flutter_json_forms/src/rendering/render_context.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/rendering/default_renderer/constants.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/helpers/common.dart';

// TODO: make html widget overridable so when the user implements a custom html element, it can also pass this here so their renderer is used here as well without needing to redefine the wrapper element

class FormFieldWrapper extends StatelessWidget {
  final RenderContext formFieldContext;
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
    // handle hidden visibility
    if (formFieldContext.options?.formattingOptions?.hidden == true) {
      FormLogger.fieldFactory.finest('Field ${formFieldContext.scope} marked as hidden');
      return Visibility(
        maintainState: true,
        visible: false,
        child: child,
      );
    }

    // List of elements being rendered additionally to the form field child
    List<Widget> columnChildren = [];

    // Pre HTML rendering
    final preHtml = formFieldContext.options?.formattingOptions?.preHtml;
    if (preHtml != null && preHtml.isNotEmpty) {
      columnChildren.add(buildDefaultHtml(context, UiHtmlContext(ui.HtmlRenderer(htmlData: preHtml))));
    }

    // Render label, description and helper
    final layoutHeaderScope = LayoutHeaderScope.maybeOf(context);
    final bool suppressComplexHeader = layoutHeaderScope?.hasHeader == true && (complexElement ?? false);
    final bool shouldIgnoreLabel = ignoreLabel == true || suppressComplexHeader;

    // Show label when: not ignoring it AND (field is complex OR labels are rendered separately)
    final showLabelInWrapper = !shouldIgnoreLabel && (complexElement ?? UIConstants.labelSeparateText);
    final labelText = showLabelInWrapper ? RenderHelpers.getLabel(formFieldContext, forInputDecoration: false) : null;
    final String? descriptionText = suppressComplexHeader ? null : formFieldContext.description;

    Widget? labelRow;
    final bool hasHeaderContent = labelText != null || (complexElement == true && descriptionText != null);
    final help = formFieldContext.options?.formattingOptions?.help;
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
              child: RendererScope.of(context).buildHelpWidget(context, help),
            ),
        ],
      );
    }

    if (labelRow != null) {
      columnChildren.add(labelRow);
    }

    // Child element itself (actual form field)
    columnChildren.add(child);

    // PostHTML rendering
    final postHtml = formFieldContext.options?.formattingOptions?.postHtml;
    if (postHtml != null && postHtml.isNotEmpty) {
      columnChildren.add(buildDefaultHtml(context, UiHtmlContext(ui.HtmlRenderer(htmlData: postHtml))));
    }

    // Render the elements and only use a row when there are more elements than the form child itself
    return MergeSemantics(
      child: columnChildren.length == 1
          ? columnChildren.first
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren,
            ),
    );
  }
}
