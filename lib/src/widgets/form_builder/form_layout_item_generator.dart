import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/data/ui_schema_extensions.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_control.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_divider.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_html.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../shared/css.dart';
import '../../utils/show_on.dart';

class FormLayoutItemGenerator {
  static Widget generateItem(
    ui.LayoutElement item,
    int nestingLevel, {
    required bool
        isShownFromParent, // TODO why optional, should be required. If no showOn is specified or shoOn evaluated to true, element is shown. If not shown, just set to not shown and child element doent have to evaluate if the are shown since their parent is not shown
    LayoutDirection? layoutDirection,
  }) {
    Widget child;

    switch (item) {
      case ui.Button():
        return FormButton(button: ui.Button.fromJson(item.toJson()));
      case ui.Buttongroup():
        return FormButtonGroup(buttonGroup: ui.Buttongroup.fromJson(item.toJson()));
      case ui.Control():
        child = FormControl(
          control: ui.Control.fromJson(item.toJson()),
          nestingLevel: nestingLevel,
          isShownFromParent: isShownFromParent,
        );
      case ui.Divider():
        child = FormDivider(divider: ui.Divider.fromJson(item.toJson()));
      case ui.Layout():
        final type = item.type;
        switch (type) {
          case ui.LayoutType.GROUP:
            child = FormGroup(
              layout: ui.Layout.fromJson(item.toJson()),
              nestingLevel: nestingLevel + 1,
              isShownFromParent: isShownFromParent,
            );
          case ui.LayoutType.HORIZONTAL_LAYOUT:
            child = FormLayout.horizontal(
              layout: ui.Layout.fromJson(item.toJson()),
              nestingLevel: nestingLevel + 1,
              isShownFromParent: isShownFromParent,
            );
          case ui.LayoutType.VERTICAL_LAYOUT:
            child = FormLayout.vertical(
              layout: ui.Layout.fromJson(item.toJson()),
              nestingLevel: nestingLevel + 1,
              isShownFromParent: isShownFromParent,
            );
        }
      case ui.HtmlRenderer():
        child = FormHtml(htmlRenderer: ui.HtmlRenderer.fromJson(item.toJson()));
    }

    return Builder(
      builder: (context) {
        final formContext = FormContext.of(context)!;
        return applyCss(
            context,
            child is FormControl
                ? child
                : handleShowOn(
                    showOn: item.showOn,
                    child: child,
                    ritaDependencies: formContext.ritaDependencies,
                    ritaEvaluator: formContext.ritaEvaluator,
                    checkValueForShowOn: formContext.checkValueForShowOn,
                  ),
            // child,
            cssClass: item.asCssClass);
      },
    );
  }
}
