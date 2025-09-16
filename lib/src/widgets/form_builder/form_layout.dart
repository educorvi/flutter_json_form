import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout_item_generator.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../shared/common.dart';
import '../shared/spacing_utils.dart';

class FormLayout extends StatelessWidget {
  final ui.Layout layout;
  final int nestingLevel;
  final LayoutDirection direction;

  const FormLayout.vertical({
    super.key,
    required this.layout,
    required this.nestingLevel,
  }) : direction = LayoutDirection.vertical;

  const FormLayout.horizontal({
    super.key,
    required this.layout,
    required this.nestingLevel,
  }) : direction = LayoutDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    final elements = layout.elements;
    final label = layout.options?.label;

    Widget content;
    if (direction == LayoutDirection.vertical) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildElementsWithSpacing(context, elements, LayoutDirection.vertical),
      );
    } else {
      content = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildElementsWithSpacing(context, elements, LayoutDirection.horizontal).map((widget) => widget).toList(),
          );
        },
      );
    }

    return withLabel(context, label, content);
  }

  /// Builds a list of widgets with proper spacing using shared utility
  List<Widget> _buildElementsWithSpacing(BuildContext context, List<ui.LayoutElement> elements, LayoutDirection layoutDirection) {
    final formContext = FormContext.of(context)!;

    return SpacingUtils.buildLayoutElementsWithSpacing(
      context: context,
      elements: elements,
      layoutDirection: layoutDirection,
      widgetBuilder: (element, index) {
        Widget widget = FormLayoutItemGenerator.generateItem(
          element,
          nestingLevel,
          layoutDirection: layoutDirection,
        );

        if (layoutDirection == LayoutDirection.horizontal) {
          widget = Expanded(child: widget);
        }

        return widget;
      },
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
          selfIndices: const {}, // Layouts don't have selfIndices
        );
      },
    );
  }
}
