import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
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
        children: elements.map((item) {
          return FormLayoutItemGenerator.generateItem(
            item,
            nestingLevel,
            layoutDirection: LayoutDirection.vertical,
          );
        }).toList(),
      );
    } else {
      content = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: elements.map((item) {
              return Expanded(
                child: FormLayoutItemGenerator.generateItem(
                  item,
                  nestingLevel,
                  layoutDirection: LayoutDirection.horizontal,
                ),
              );
            }).toList(),
          );
        },
      );
    }

    return withLabel(context, label, content);
  }
}
