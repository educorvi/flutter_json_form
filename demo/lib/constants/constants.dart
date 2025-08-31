import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/appIcon/UvCooperativeDesignIcon.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/UvCooperateDesignUiConstants.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/googleMaterialUiConstants.dart';
import 'package:flutter_json_forms_demo/constants/uiConstants/uiConstants.dart';
import 'package:flutter_json_forms_demo/theme.dart';

import 'appIcon/appIcon.dart';
import 'appIcon/googleMaterialIcon.dart';

final appConstants =
    AppConstants(designSystem: DesignSystem.uvCooperativeDesign);

enum DesignSystem {
  googleMaterial,
  uvCooperativeDesign,
}

enum IconSet {
  googleMaterial,
  phosphorIcons,
}

class AppConstants {
  final NetworkConstants network;
  final NavigationBarConstants navigationBar;
  late final UiConstants ui;
  final IconConstants icons;
  late final AppTheme theme;

  AppConstants({required DesignSystem designSystem})
      : network = NetworkConstants(),
        navigationBar =
            NavigationBarConstants(iconSet: _getIconSystem(designSystem)),
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
      default:
        return IconSet.googleMaterial;
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

  IconConstants({required IconSet iconSet})
      : appIcon = IconFactory.getIconSet(iconSet);

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
      default:
        return GoogleMaterialIcon();
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
      default:
        return GoogleMaterialUiConstants();
    }
  }
}
