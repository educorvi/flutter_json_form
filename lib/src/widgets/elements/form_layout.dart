import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/form_layout_factory.dart';
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/helpers/layout_helpers.dart';
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';

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
    direction = LayoutHelpers.directionForType(layout.type);
  }

  @override
  Widget build(BuildContext context) {
    final renderer = RendererScope.of(context);
    final formContext = FormContext.of(context)!;
    final layoutCtx = UiLayoutContext(layout);

    final children = LayoutHelpers.buildLayoutChildren(
      layout.elements,
      direction,
      (element, isShown) => LayoutFactory.generateLayoutElement(
        element,
        nestingLevel,
        isShownFromParent: isShown,
      ),
      (element) => formContext.elementShown(
        showOn: element.showOn,
        parentIsShown: isShownFromParent,
      ),
    );

    switch (layout.type) {
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        return renderer.buildUiHorizontalLayout(context, layoutCtx, children);
      case ui.LayoutType.VERTICAL_LAYOUT:
        return renderer.buildUiVerticalLayout(context, layoutCtx, children);
      case ui.LayoutType.GROUP:
        return renderer.buildUiGroup(context, layoutCtx, children);
    }
  }
}
