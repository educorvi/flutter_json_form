import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/data/ui_schema_extensions.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_control.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_divider.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_html.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_wizard.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../shared/css.dart';
import '../../utils/show_on.dart';

class ItemGenerator {
  static Widget generateLayoutElement(
    ui.LayoutElement item,
    int nestingLevel, {
    required bool isShownFromParent,
  }) {
    Widget child;

    switch (item) {
      case ui.Button():
        return FormButton(button: item);
      case ui.Buttongroup():
        return FormButtonGroup(buttonGroup: item);
      case ui.Control():
        child = FormControl(
          control: item,
          nestingLevel: nestingLevel,
          isShownFromParent: isShownFromParent,
        );
      case ui.Divider():
        child = FormDivider(divider: item);
      case ui.Layout():
        child = generateLayout(
          item,
          nestingLevel,
          isShownFromParent: isShownFromParent,
        );
      case ui.HtmlRenderer():
        child = FormHtml(htmlRenderer: item);
    }

    // why is this needed? All primitive fields already have showOnWrapper. MAybe we remov ethe primitive field wrappers or add this logic at a better plcae since root layout elements dont get show and css lofic here
    return Builder(
      builder: (context) {
        final formContext = FormContext.of(context)!;
        return applyCss(
            context,
            child is FormControl
                ? child
                : handleShowOn(
                    item.showOn,
                    child,
                    formContext.ritaDependencies,
                    formContext.checkValueForShowOn,
                    true,
                    null,
                    formContext.ritaEvaluator,
                    formContext.getFullFormData,
                  ),
            // child,
            cssClass: item.asCssClass);
      },
    );
  }

  static Widget generateRootLayout(ui.RootLayout rootLayout) {
    switch (rootLayout) {
      case ui.Layout():
        return generateLayout(rootLayout, -1, isShownFromParent: true);
      case ui.Wizard():
        return FormWizard(
          wizard: rootLayout,
        );
    }
  }

  static Widget generateLayout(
    ui.Layout layout,
    int nestingLevel, {
    required bool isShownFromParent,
  }) {
    final type = layout.type;
    switch (type) {
      case ui.LayoutType.GROUP:
        return FormGroup(
          layout: layout,
          nestingLevel: nestingLevel + 1,
          isShownFromParent: isShownFromParent,
        );
      case ui.LayoutType.HORIZONTAL_LAYOUT:
        return FormLayout.horizontal(
          layout: layout,
          nestingLevel: nestingLevel + 1,
          isShownFromParent: isShownFromParent,
        );
      case ui.LayoutType.VERTICAL_LAYOUT:
        return FormLayout.vertical(
          layout: layout,
          nestingLevel: nestingLevel + 1,
          isShownFromParent: isShownFromParent,
        );
    }
  }
}
