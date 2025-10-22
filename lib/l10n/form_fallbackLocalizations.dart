import 'package:flutter/material.dart';
import 'form_localizations.dart';
import 'form_localizations_en.dart';

extension AppLocalizationsHelper on BuildContext {
  /// Safely get localized string with automatic English fallback
  String localize(String Function(AppLocalizations) getter) {
    try {
      final localizations = AppLocalizations.of(this);
      if (localizations != null) {
        return getter(localizations);
      }
    } catch (e) {
      // Silently fail and use English fallback
    }
    // Fallback to English
    return getter(AppLocalizationsEn());
  }
}
