import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/data/ui_schema_extensions.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout_generator.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../shared/common.dart';
import '../shared/spacing_utils.dart';

class FormGroup extends StatelessWidget {
  final ui.Layout layout;
  final int nestingLevel;
  final bool isShownFromParent;

  const FormGroup({
    super.key,
    required this.layout,
    required this.nestingLevel,
    required this.isShownFromParent,
  });

  @override
  Widget build(BuildContext context) {
    final formContext = FormContext.of(context)!;
    final elements = layout.elements;
    final label = layout.options?.label;
    // final description = layout.options?.description; // TODO: description
    // final showOn = layout.showOn;

    bool isShown = formContext.elementShown(
      showOn: layout.showOn,
      parentIsShown: isShownFromParent,
    );

    // bool? isShown = isElementShown(
    //   showOn: showOn,
    //   ritaDependencies: formContext.ritaDependencies,
    //   checkValueForShowOn: formContext.checkValueForShowOn,
    // );

    Widget groupElement = getLineContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildElementsWithSpacing(context, elements, isShown),
      ),
    );

    return withLabel(context, label, groupElement);
  }

  /// Builds a list of widgets with proper spacing using shared utility
  List<Widget> _buildElementsWithSpacing(BuildContext context, List<ui.LayoutElement> elements, bool parentIsShown) {
    final formContext = FormContext.of(context)!;

    return SpacingUtils.buildLayoutElementsWithSpacing(
      context: context,
      elements: elements,
      widgetBuilder: (element, index) => ItemGenerator.generateLayoutElement(
        element,
        nestingLevel,
        isShownFromParent: parentIsShown,
      ),
      isVisibleChecker: (element, index) {
        if (element.asControlOptions?.formattingOptions?.hidden == true) {
          return false;
        }

        return formContext.elementShown(
          showOn: element.showOn,
          parentIsShown: true,
        );
      },
    );
  }
}
