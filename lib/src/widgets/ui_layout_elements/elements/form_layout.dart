import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/form_layout_factory.dart';
import 'package:flutter_json_forms/src/widgets/shared/common.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/widgets/shared/spacing_utils.dart';

class FormLayout extends StatelessWidget {
  final ui.Layout layout;
  final int nestingLevel;
  final bool isShownFromParent;
  late final LayoutDirection direction;

  FormLayout.fromLayout({
    super.key,
    required this.layout,
    required this.nestingLevel,
    required this.isShownFromParent,
  }) {
    switch (layout.type) {
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        direction = LayoutDirection.horizontal;
        break;
      case ui.LayoutType.GROUP:
      case ui.LayoutType.VERTICAL_LAYOUT:
        direction = LayoutDirection.vertical;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final elements = layout.elements;
    final options = layout.options;
    final type = layout.type;
    final Widget content;
    switch (type) {
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        content = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildElementsWithSpacing(context, elements).map((widget) => widget).toList(),
            );
          },
        );
      case ui.LayoutType.VERTICAL_LAYOUT:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildElementsWithSpacing(context, elements),
        );
      case ui.LayoutType.GROUP:
        content = getLineContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildElementsWithSpacing(context, elements),
          ),
        );
    }
    // TODO: when allowing custom styling, allow passing generic header function but also wrap this function and allow to provide individual header function for verticalLAyout, horizontalLayout, Group, Object, array etc.)
    return withCss(context, withHeader(context, options?.label, options?.description, content), cssClass: options?.cssClass);
  }

  /// Builds a list of widgets with proper spacing using shared utility
  List<Widget> _buildElementsWithSpacing(BuildContext context, List<ui.LayoutElement> elements) {
    final formContext = FormContext.of(context)!;

    return SpacingUtils.buildWidgetsWithSpacing<ui.LayoutElement>(
      items: elements,
      layoutDirection: direction,
      widgetBuilder: (element, index) {
        Widget widget = LayoutFactory.generateLayoutElement(
          isShownFromParent: isElementVisible(
            formContext: formContext,
            element: element,
            parentIsShown: isShownFromParent,
          ),
          element,
          nestingLevel,
        );

        if (direction == LayoutDirection.horizontal) {
          widget = Expanded(child: widget);
        }
        return widget;
      },
      isVisibleChecker: (element, index) => isElementVisible(
        formContext: formContext,
        element: element,
        parentIsShown: isShownFromParent,
      ),
    );
  }
}

bool isElementVisible({
  required FormContext formContext,
  required ui.LayoutElement element,
  required bool parentIsShown,
}) {
  // Check if element is explicitly hidden
  // TODO: not necessary here and only relevant for control
  // if (element.asControlOptions?.formattingOptions?.hidden == true) {
  //   return false;
  // }
  // Check normal showOn visibility
  return formContext.elementShown(
    showOn: element.showOn,
    parentIsShown: parentIsShown,
  );
}
