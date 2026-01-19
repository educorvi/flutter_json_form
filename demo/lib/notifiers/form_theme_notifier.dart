import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormThemeNotifier extends ChangeNotifier {
  DesignSystem _designSystem = appConstants.designSystem;

  DesignSystem get designSystem => _designSystem;

  Future<void> loadDesignSystem() async {
    final prefs = await SharedPreferences.getInstance();
    final designSystemName = prefs.getString('designSystem');
    if (designSystemName != null) {
      _designSystem = DesignSystem.values.firstWhere(
        (e) => e.name == designSystemName,
        orElse: () => DesignSystem.googleMaterial,
      );
    }
    notifyListeners();
  }

  Future<void> setDesignSystem(DesignSystem system) async {
    _designSystem = system;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('designSystem', system.name);
  }
}
