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

    Column generateGroupElements() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: elements.map((item) {
          return FormLayoutItemGenerator.generateItem(
            item,
            nestingLevel,
            isShownFromParent: isShown,
            layoutDirection: LayoutDirection.vertical,
          );
        }).toList(),
      );
    }

    Widget groupElement = getLineContainer(
      child: Padding(
        padding: const EdgeInsets.only(left: UIConstants.groupPadding),
        child: generateGroupElements(),
      ),
    );

    return label != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              groupElement,
            ],
          )
        : groupElement;
  }
}
