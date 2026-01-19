import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityNotifier extends ChangeNotifier {
  bool _enabled = false;

  bool get enabled => _enabled;

  Future<void> loadEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('accessibilityEnabled') ?? false;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('accessibilityEnabled', value);
  }
}
