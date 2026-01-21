import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_control.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_button.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_button_group.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_divider.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_html.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/ui_layout_elements/elements/form_wizard.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../../utils/show_on.dart';

class LayoutFactory {
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
        child = FormLayout.fromLayout(
          layout: item,
          nestingLevel: nestingLevel,
          isShownFromParent: isShownFromParent,
        );
      case ui.HtmlRenderer():
        child = FormHtml(htmlRenderer: item);
    }

    // why is this needed? All primitive fields already have showOnWrapper. Maybe we remove the primitive field wrappers or add this logic at a better place since root layout elements don't get show and css logic here
    return Builder(
      builder: (context) {
        final formContext = FormContext.of(context)!;
        return child is FormControl
            ? child
            : handleShowOn(
                item.showOn,
                child,
                formContext.ritaDependencies,
                formContext.checkValueForShowOn,
                isShownFromParent,
                null,
                formContext.ritaEvaluator,
                formContext.getFullFormData,
              );
      },
    );
  }

  static Widget generateRootLayout(ui.RootLayout rootLayout) {
    switch (rootLayout) {
      case ui.Layout():
        return FormLayout.fromLayout(layout: rootLayout, nestingLevel: -1, isShownFromParent: true);
      case ui.Wizard():
        return FormWizard.fromLayout(
          wizard: rootLayout,
        );
    }
  }
}
