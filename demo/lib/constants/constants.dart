import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/appIcon/uv_cooperate_design_icon.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/uv_cooperate_design_ui_constants.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/google_material_ui_constants.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/ui_constants.dart';
import 'package:flutter_json_forms_demo/theme.dart';

import 'appIcon/app_icon.dart';
import 'appIcon/google_material_icon.dart';

final appConstants = AppConstants(designSystem: DesignSystem.googleMaterial);

/// Layout and spacing constants
class LayoutConstants {
  // Page widths
  static const double maxPageWidth = 1000.0;

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;

  // Padding
  static const EdgeInsets paddingAll = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingAllS = EdgeInsets.all(spacingS);
  static const EdgeInsets paddingCard = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: spacingM);
  static const EdgeInsets paddingButtonBar = EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS);

  // Gaps (for use with SizedBox)
  static const SizedBox gapXs = SizedBox(height: spacingXs, width: spacingXs);
  static const SizedBox gapS = SizedBox(height: spacingS, width: spacingS);
  static const SizedBox gapM = SizedBox(height: spacingM, width: spacingM);
  static const SizedBox gapL = SizedBox(height: spacingL, width: spacingL);
  static const SizedBox gapXl = SizedBox(height: spacingXl, width: spacingXl);
}

enum DesignSystem {
  googleMaterial,
  uvCooperativeDesign,
}

enum IconSet {
  googleMaterial,
  phosphorIcons,
}

class AppConstants {
  final DesignSystem designSystem;
  final NetworkConstants network;
  final NavigationBarConstants navigationBar;
  late final UiConstants ui;
  final IconConstants icons;
  late final AppTheme theme;

  AppConstants({required this.designSystem})
      : network = NetworkConstants(),
        navigationBar = NavigationBarConstants(iconSet: _getIconSystem(designSystem)),
        icons = IconConstants(iconSet: _getIconSystem(designSystem)) {
    final uiConstants = UiConstantsFactory.getUiConstants(designSystem);
    ui = uiConstants;
    theme = AppTheme(ui);
  }

  static IconSet _getIconSystem(DesignSystem designSystem) {
    switch (designSystem) {
      case DesignSystem.googleMaterial:
        return IconSet.googleMaterial;
      case DesignSystem.uvCooperativeDesign:
        return IconSet.phosphorIcons;
    }
  }
}

class NetworkConstants {
  final baseUrl =
      "https://ella.uv-kooperation.org/"; // """http://192.168.2.116:1080/"; // "http://192.168.178.165:1080/"; // "http://192.168.178.93:1080/" https://ella.uv-kooperation.org/
  final appsEndpoint = "apps";
}

class IconConstants {
  final AppIcon appIcon;

  IconConstants({required IconSet iconSet}) : appIcon = IconFactory.getIconSet(iconSet);

// Widget _icon(IconData icon, {double size = 24.0, Color? color}) {
//   return Icon(icon, size: size, color: color);
// }
}

class NavigationBarConstants extends IconConstants {
  NavigationBarConstants({required super.iconSet});

  IconData get homePageIconSelected => appIcon.homePageIconSelected;

  IconData get homePageIconUnselected => appIcon.homePageIconUnselected;

  IconData get databasePageIconSelected => appIcon.databasePageIconSelected;

  IconData get databasePageIconUnselected => appIcon.databasePageIconUnselected;

  IconData get settingsPageIconSelected => appIcon.settingsPageIconSelected;

  IconData get settingsPageIconUnselected => appIcon.settingsPageIconUnselected;
}

class IconFactory {
  static AppIcon getIconSet(IconSet iconSet) {
    switch (iconSet) {
      case IconSet.googleMaterial:
        return GoogleMaterialIcon();
      case IconSet.phosphorIcons:
        return UvCooperateDesignIcon();
    }
  }
}

class UiConstantsFactory {
  static UiConstants getUiConstants(DesignSystem designSystem) {
    switch (designSystem) {
      case DesignSystem.googleMaterial:
        return GoogleMaterialUiConstants();
      case DesignSystem.uvCooperativeDesign:
        return UvCooperativeDesignUiConstants();
    }
  }
}
