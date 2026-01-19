import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/notifiers/theme_mode_notifier.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';

class SettingsThemeModeCard extends StatelessWidget {
  final ThemeModeNotifier notifier;

  const SettingsThemeModeCard({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: LayoutConstants.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.settingsThemeMode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              LayoutConstants.gapM,
              Text(
                AppLocalizations.of(context)!.settingsThemeModeDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              LayoutConstants.gapM,
              ListenableBuilder(
                listenable: notifier,
                builder: (context, child) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.brightness_auto, size: 18),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.themeModeSystem),
                          ],
                        ),
                        selected: notifier.themeMode == ThemeMode.system,
                        onSelected: (selected) {
                          if (selected) {
                            notifier.setThemeMode(ThemeMode.system);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.light_mode, size: 18),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.themeModeLight),
                          ],
                        ),
                        selected: notifier.themeMode == ThemeMode.light,
                        onSelected: (selected) {
                          if (selected) {
                            notifier.setThemeMode(ThemeMode.light);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.dark_mode, size: 18),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.themeModeDark),
                          ],
                        ),
                        selected: notifier.themeMode == ThemeMode.dark,
                        onSelected: (selected) {
                          if (selected) {
                            notifier.setThemeMode(ThemeMode.dark);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
