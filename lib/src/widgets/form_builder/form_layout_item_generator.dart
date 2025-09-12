import 'package:flutter/material.dart';
import 'package:flutter_json_forms/src/utils/layout_direction.dart';
import 'package:flutter_json_forms/src/form_context.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_control.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_button_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_divider.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_group.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_html.dart';
import 'package:flutter_json_forms/src/widgets/form_builder/form_layout.dart';
import 'package:flutter_json_forms/src/widgets/shared/form_not_implemented.dart';
import '../../models/ui_schema.g.dart' as ui;
import '../shared/css.dart';
import '../../utils/show_on.dart';

class FormLayoutItemGenerator {
  static Widget generateItem(
    ui.LayoutElement item,
    int nestingLevel, {
    bool? isShownFromParent,
    LayoutDirection? layoutDirection,
  }) {
    Widget child;

    switch (item.type) {
      case ui.LayoutElementType.BUTTON:
        return FormButton(button: ui.Button.fromJson(item.toJson()));
      case ui.LayoutElementType.BUTTONGROUP:
        return FormButtonGroup(buttonGroup: ui.Buttongroup.fromJson(item.toJson()));
      case ui.LayoutElementType.CONTROL:
        child = FormControl(
          control: ui.Control.fromJson(item.toJson()),
          nestingLevel: nestingLevel,
          isShownFromParent: isShownFromParent,
        );
      case ui.LayoutElementType.DIVIDER:
        child = FormDivider(divider: ui.Divider.fromJson(item.toJson()));
      case ui.LayoutElementType.GROUP:
        child = FormGroup(
          layout: ui.Layout.fromJson(item.toJson()),
          nestingLevel: nestingLevel + 1,
        );
      case ui.LayoutElementType.HORIZONTAL_LAYOUT:
        child = FormLayout.horizontal(
          layout: ui.Layout.fromJson(item.toJson()),
          nestingLevel: nestingLevel + 1,
        );
      case ui.LayoutElementType.HTML:
        child = FormHtml(htmlRenderer: ui.HtmlRenderer.fromJson(item.toJson()));
      case ui.LayoutElementType.VERTICAL_LAYOUT:
        child = FormLayout.vertical(
          layout: ui.Layout.fromJson(item.toJson()),
          nestingLevel: nestingLevel + 1,
        );
      case null:
        child = FormNotImplemented("No type defined for LayoutElementType $item");
    }

    return Builder(
      builder: (context) {
        final formContext = FormContext.of(context)!;
        return applyCss(
          context,
          handleShowOn(
            showOn: item.showOn,
            child: child,
            ritaDependencies: formContext.ritaDependencies,
            ritaEvaluator: formContext.ritaEvaluator,
            checkValueForShowOn: formContext.checkValueForShowOn,
            layoutDirection: layoutDirection,
          ),
          // child,
          cssClass: item.options?.cssClass,
        );
      },
    );
  }
}
