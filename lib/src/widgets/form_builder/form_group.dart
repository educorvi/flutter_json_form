import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout_item_generator.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../shared/common.dart';
import '../../utils/show_on.dart';
import '../constants.dart';
import '../shared/spacing_utils.dart';

class FormGroup extends StatelessWidget {
  final ui.Layout layout;
  final int nestingLevel;

  const FormGroup({
    super.key,
    required this.layout,
    required this.nestingLevel,
  });

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;
    final elements = layout.elements;
    final label = layout.options?.label;
    final showOn = layout.showOn;

    bool? isShown = isElementShown(
      showOn: showOn,
      ritaDependencies: formContext.ritaDependencies,
      checkValueForShowOn: formContext.checkValueForShowOn,
    );

    Widget groupElement = getLineContainer(
      child: Padding(
        padding: const EdgeInsets.only(left: UIConstants.groupIndentation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildElementsWithSpacing(context, elements, isShown),
        ),
      ),
    );

    return withLabel(context, label, groupElement);
  }

  /// Builds a list of widgets with proper spacing using shared utility
  List<Widget> _buildElementsWithSpacing(BuildContext context, List<ui.LayoutElement> elements, bool? parentIsShown) {
    final formContext = FormContext.of(context)!;

    return SpacingUtils.buildLayoutElementsWithSpacing(
      context: context,
      elements: elements,
      widgetBuilder: (element, index) => FormLayoutItemGenerator.generateItem(
        element,
        nestingLevel,
        isShownFromParent: parentIsShown,
        layoutDirection: LayoutDirection.vertical,
      ),
      isVisibleChecker: (element, index) {
        // Check if element is explicitly hidden
        if (element.options?.formattingOptions?.hidden == true) {
          return false;
        }

        // Check normal showOn visibility
        final String elementScope = element.scope ?? '';
        return formContext.elementShown(
          scope: elementScope,
          showOn: element.showOn,
          parentIsShown: true,
          selfIndices: const {}, // Groups don't have selfIndices
        );
      },
    );
  }
}
