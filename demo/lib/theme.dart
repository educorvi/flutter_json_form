import 'package:flutter/material.dart';

import 'constants/uiConstants/ui_constants.dart';

final class AppTheme {
  final UiConstants uiConstants;

  AppTheme(this.uiConstants);

  ThemeData getThemeData(Brightness brightness) {
    return ThemeData(
      // colorScheme: ColorScheme.fromSeed(
      //   seedColor: const Color(0x00004994),
      //   brightness: brightness,
      // ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: UVColors.primary,
        brightness: brightness,
        // primary: UVColors.primary,
        // onPrimary: UVColors.onPrimary,
        // secondary: UVColors.secondary,
        // // onSecondary: UVColors.onSecondary,
        // error: UVColors.error,
        // onError: UVColors.onError,
        // surface: UVColors.surface,
        // onSurface: UVColors.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: uiConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(uiConstants.cardBorderRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(uiConstants.buttonBorderRadius),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12.0),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(uiConstants.buttonBorderRadius),
          ),
          elevation: uiConstants.buttonElevation),
      inputDecorationTheme: InputDecorationTheme(
        // isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(uiConstants.inputBorderRadius),
        ),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(uiConstants.buttonBorderRadius),
        ),
      ),
      useMaterial3: true,
      brightness: brightness,
      textTheme: uiConstants.getTextTheme(brightness),
    );
  }
}

abstract final class UVColors {
  /// primary color UV blue
  static const Color blue70 = Color(0x00004994);
  static const Color blue60 = Color(0x000063af);
  static const Color blue50 = Color(0x000095db);
  static const Color blue30 = Color(0x004ebfef);
  static const Color blue20 = Color(0x00a1daf8);
  static const Color blue10 = Color(0x00d4edfc);

  /// secondary color UV green
  static const Color green70 = Color(0x00006226);
  static const Color green60 = Color(0x0000812c);
  static const Color green50 = Color(0x004ca22f);
  static const Color green30 = Color(0x00afca0b);
  static const Color green20 = Color(0x00d5df95);
  static const Color green10 = Color(0x00ecf3da);

  /// secondary color UV red
  static const Color red70 = Color(0x00681c16);
  static const Color red60 = Color(0x009b1c18);
  static const Color red50 = Color(0x00d51317);
  static const Color red30 = Color(0x00f35449);
  static const Color red20 = Color(0x00f8c7c8);
  static const Color red10 = Color(0x00fdeded);

  /// secondary color UV turquoise
  // TODO

  /// secondary color UV orange
  // TODO

  /// secondary color UV violet
  // TODO

  /// neutral color UV grey
  static const Color grey100 = Color(0x00000000);
  static const Color grey90 = Color(0x003c3c3c);
  static const Color grey80 = Color(0x00555555);
  static const Color grey50 = Color(0x009c9c9c);
  static const Color grey30 = Color(0x006c6c6c);
  static const Color grey10 = Color(0x00ededed);

  static const Color primary = blue70;
  static const Color onPrimary = Colors.white;

  static const Color secondary = blue30;
  static const Color onSecondary = Colors.black;

  static const Color tertiary = blue50;
  static const Color onTertiary = Colors.white;

  static const Color error = red30;
  static const Color onError = Colors.white;

  static const Color surface = grey10;
  static const Color onSurface = Colors.black;
}
