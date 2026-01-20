import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout_generator.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../data/ui_schema_extensions.dart';
import '../shared/common.dart';
import '../shared/spacing_utils.dart';

class FormLayout extends StatelessWidget {
  final ui.Layout layout;
  final int nestingLevel;
  final LayoutDirection direction;
  final bool isShownFromParent;

  FormLayout.fromLayout({super.key, required this.layout})
      : nestingLevel = 0,
        direction = layout.type == ui.LayoutType.HORIZONTAL_LAYOUT ? LayoutDirection.horizontal : LayoutDirection.vertical,
        isShownFromParent = true;

  const FormLayout.vertical({
    super.key,
    required this.layout,
    required this.nestingLevel,
    required this.isShownFromParent,
  }) : direction = LayoutDirection.vertical;

  const FormLayout.horizontal({
    super.key,
    required this.layout,
    required this.nestingLevel,
    required this.isShownFromParent,
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
        Widget widget = ItemGenerator.generateLayoutElement(
          isShownFromParent: formContext.elementShown(
            showOn: element.showOn,
            parentIsShown: isShownFromParent,
          ),
          element,
          nestingLevel,
        );

        if (layoutDirection == LayoutDirection.horizontal) {
          widget = Expanded(child: widget);
        }

        return widget;
      },
      isVisibleChecker: (element, index) {
        // Check if element is explicitly hidden
        if (element.asControlOptions?.formattingOptions?.hidden == true) {
          return false;
        }

        // Check normal showOn visibility
        return formContext.elementShown(
          showOn: element.showOn,
          parentIsShown: true,
        );
      },
    );
  }
}
