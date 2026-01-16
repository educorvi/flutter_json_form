import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class UvCooperativeDesignUiConstants extends UiConstants {
  @override
  double get cardBorderRadius => 0.0;

  @override
  double get buttonBorderRadius => 0.0;

  @override
  double get dialogBorderRadius => 0.0;

  @override
  double get inputBorderRadius => 0.0;

  @override
  double? get cardElevation => 4.0;

  @override
  double? get buttonElevation => 0.0;

  @override
  TextTheme? get textThemeLight => GoogleFonts.sourceSans3TextTheme(ThemeData.light().textTheme);

  @override
  TextTheme? get textThemeDark => GoogleFonts.sourceSans3TextTheme(ThemeData.dark().textTheme);
}
