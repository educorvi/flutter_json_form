import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout_item_generator.dart';
import '../../models/ui_schema.dart' as ui;
import '../shared/common.dart';
import '../../utils/show_on.dart';
import '../constants.dart';

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
        padding: const EdgeInsets.only(left: UIConstants.groupPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildElementsWithSpacing(context, elements, isShown),
        ),
      ),
    );

    return withLabel(context, label, groupElement);
  }

  /// Builds a list of widgets with proper spacing - always creates spacing widgets but makes them invisible when not needed
  List<Widget> _buildElementsWithSpacing(BuildContext context, List<ui.LayoutElement> elements, bool? parentIsShown) {
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
        parentIsShown: true, // parentIsShown ??
      );

      // Always add spacing widget, but with zero size if not needed
      if (i > 0) {
        allWidgets.add(SizedBox(
          height: (isShown && hasVisibleElement) ? 8.0 : 0.0,
        ));
      }

      // Track if we have a visible element for next iteration
      if (isShown) {
        hasVisibleElement = true;
      }

      // Always create the widget - handleShowOn will manage visibility
      final widget = FormLayoutItemGenerator.generateItem(
        item,
        nestingLevel,
        isShownFromParent: parentIsShown,
        layoutDirection: LayoutDirection.vertical,
      );

      allWidgets.add(widget);
    }

    return allWidgets;
  }
}
