import 'package:flutter_json_forms_demo/constants/uiConstants/ui_constants.dart';

import 'package:flutter/material.dart';

final class GoogleMaterialUiConstants extends UiConstants {
  @override
  double get cardBorderRadius => 12.0;

  @override
  double get buttonBorderRadius => 32.0;

  @override
  double get inputBorderRadius => 12.0;

  @override
  double get dialogBorderRadius => 32.0;

  @override
  double? get cardElevation => null; // use default Google Material elevation

  @override
  double? get buttonElevation => null; // use default Google Material elevation

  @override
  TextTheme? get textThemeLight => null; // use default Google Material text theme

  @override
  TextTheme? get textThemeDark => null; // use default Google Material text theme
}
