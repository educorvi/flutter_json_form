import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_control.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_button.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_button_group.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_divider.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_html.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/elements/form_wizard.dart';
import '../../models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/rendering/renderer_scope.dart';

class LayoutFactory {
  static Widget generateLayoutElement(
    ui.LayoutElement item,
    int nestingLevel, {
    required bool isShownFromParent,
  }) {
    Widget child;

    switch (item) {
      case ui.Button():
        child = FormButton(button: item);
        break;
      case ui.Buttongroup():
        child = FormButtonGroup(buttonGroup: item);
        break;
      case ui.Control():
        return FormControl(
          control: item,
          nestingLevel: nestingLevel,
          isShownFromParent: isShownFromParent,
        );
      case ui.Divider():
        child = FormDivider(divider: item);
        break;
      case ui.Layout():
        child = FormLayout.fromLayout(
          layout: item,
          nestingLevel: nestingLevel,
          isShownFromParent: isShownFromParent,
        );
        break;
      case ui.HtmlRenderer():
        child = FormHtml(htmlRenderer: item);
        break;
    }

    // why is this needed? All primitive fields already have showOnWrapper. Maybe we remove the primitive field wrappers or add this logic at a better place since root layout elements don't get show and css logic here
    return Builder(
      builder: (context) {
        final isVisible = FormContext.of(context)!.elementShown(
          showOn: item.showOn,
          parentIsShown: isShownFromParent,
          selfIndices: null,
        );
        return RendererScope.of(context).buildVisibilityWrapper(context, child: child, isVisible: isVisible);
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
