import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/notifiers/form_theme_notifier.dart';
import 'package:flutter_json_forms_demo/notifiers/theme_mode_notifier.dart';
import 'package:flutter_json_forms_demo/notifiers/locale_notifier.dart';
import 'package:flutter_json_forms_demo/notifiers/accessibility_notifier.dart';
import 'package:flutter_json_forms_demo/widgets/settings/settings_design_system_card.dart';
import 'package:flutter_json_forms_demo/widgets/settings/settings_theme_mode_card.dart';
import 'package:flutter_json_forms_demo/widgets/settings/settings_language_card.dart';
import 'package:flutter_json_forms_demo/widgets/settings/settings_accessibility_card.dart';
import 'package:flutter_json_forms_demo/widgets/settings/settings_about_card.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final FormThemeNotifier formThemeNotifier;
  final ThemeModeNotifier themeModeNotifier;
  final AccessibilityNotifier accessibilityNotifier;
  final LocaleNotifier localeNotifier;

  const SettingsPage({
    super.key,
    required this.formThemeNotifier,
    required this.themeModeNotifier,
    required this.accessibilityNotifier,
    required this.localeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: LayoutConstants.paddingAll,
      children: [
        Center(
          child: SizedBox(
            width: LayoutConstants.maxPageWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.settingsTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                LayoutConstants.gapL,
                SettingsDesignSystemCard(notifier: formThemeNotifier),
                LayoutConstants.gapM,
                SettingsThemeModeCard(notifier: themeModeNotifier),
                LayoutConstants.gapM,
                SettingsLanguageCard(notifier: localeNotifier),
                LayoutConstants.gapM,
                SettingsAccessibilityCard(notifier: accessibilityNotifier),
                LayoutConstants.gapM,
                const SettingsAboutCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
