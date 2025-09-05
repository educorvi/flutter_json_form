import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout_item_generator.dart';
import '../../models/ui_schema.dart' as ui;
import '../shared/common.dart';

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
            children: _buildElementsWithSpacing(context, elements, LayoutDirection.horizontal).map((widget) => widget).toList(),
          );
        },
      );
    }

    return withLabel(context, label, content);
  }

  /// Builds a list of widgets with proper spacing - always creates spacing widgets but makes them invisible when not needed
  List<Widget> _buildElementsWithSpacing(BuildContext context, List<ui.LayoutElement> elements, LayoutDirection layoutDirection) {
    final formContext = FormContext.of(context)!;
    final List<Widget> allWidgets = [];
    bool hasVisibleElement = false;

    for (int i = 0; i < elements.length; i++) {
      final item = elements[i];

      // Check if this element should be visible
      final String elementScope = item.scope ?? '';
      final bool isShown = formContext.elementShown(
        scope: elementScope,
        showOn: item.showOn,
        parentIsShown: true,
      );

      // Always add spacing widget, but with zero size if not needed
      if (i > 0) {
        if (layoutDirection == LayoutDirection.vertical) {
          allWidgets.add(SizedBox(
            height: (isShown && hasVisibleElement) ? 8.0 : 0.0,
          ));
        } else {
          allWidgets.add(SizedBox(
            width: (isShown && hasVisibleElement) ? 8.0 : 0.0,
          ));
        }
      }

      // Track if we have a visible element for next iteration
      if (isShown) {
        hasVisibleElement = true;
      }

      // Always create the widget - handleShowOn will manage visibility
      Widget widget = FormLayoutItemGenerator.generateItem(
        item,
        nestingLevel,
        layoutDirection: layoutDirection,
      );

      if (layoutDirection == LayoutDirection.horizontal) {
        widget = Expanded(child: widget);
      }

      allWidgets.add(widget);
    }

    return allWidgets;
  }
}
