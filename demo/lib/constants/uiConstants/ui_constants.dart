import 'package:flutter/material.dart';

abstract class UiConstants {
  final pageMaxWidth = 750.0;

  TextTheme? get textThemeLight;

  TextTheme? get textThemeDark;

  double get cardBorderRadius;

  double get buttonBorderRadius;

  double get inputBorderRadius;

  double? get cardElevation;

  double? get buttonElevation;

  TextTheme? getTextTheme(Brightness brightness) {
    return _brightnessDependant(brightness,
        light: textThemeLight, dark: textThemeDark);
  }

  T _brightnessDependant<T>(Brightness brightness,
      {required T light, required T dark}) {
    switch (brightness) {
      case Brightness.light:
        return light;
      case Brightness.dark:
        return dark;
    }
  }
}
