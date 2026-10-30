import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/rendering/helpers/layout_helpers.dart';
import 'package:flutter_json_forms/src/rendering/ui_element_contexts.dart';

/// Builds a vertical (column) layout with optional header and CSS wrapping.
Widget buildDefaultVerticalLayout(
  BuildContext context,
  UiLayoutContext layout,
  List<Widget> children,
  EdgeInsets contentPadding,
  CrossAxisAlignment crossAxisAlignment,
) {
  final content = Padding(
    padding: contentPadding,
    child: Column(crossAxisAlignment: crossAxisAlignment, children: children),
  );
  return LayoutHelpers.wrapWithHeader(context, layout, content);
}

/// Builds a horizontal (row) layout with optional header and CSS wrapping.
///
/// Each child is wrapped in [Expanded] so the row fills available width.
Widget buildDefaultHorizontalLayout(
  BuildContext context,
  UiLayoutContext layout,
  List<Widget> children,
  EdgeInsets contentPadding,
  MainAxisAlignment mainAxisAlignment,
  CrossAxisAlignment crossAxisAlignment,
) {
  final expanded = children.map((c) => c is Expanded ? c : Expanded(child: c)).toList();
  final row = Padding(
    padding: contentPadding,
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: expanded,
    ),
  );
  return LayoutHelpers.wrapWithHeader(context, layout, row);
}

/// Builds an indented / bordered group layout with optional header and CSS
/// wrapping.
Widget buildDefaultGroup(
  BuildContext context,
  UiLayoutContext layout,
  List<Widget> children,
  double indentation,
  Color borderColor,
  double borderWidth,
  EdgeInsets contentPadding,
) {
  final content = Container(
    padding: EdgeInsets.only(left: indentation).add(contentPadding),
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: borderColor, width: borderWidth)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );
  return LayoutHelpers.wrapWithHeader(context, layout, content);
}
