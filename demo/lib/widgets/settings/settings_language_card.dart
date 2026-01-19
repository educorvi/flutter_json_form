import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/notifiers/locale_notifier.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';

class SettingsLanguageCard extends StatelessWidget {
  final LocaleNotifier notifier;

  const SettingsLanguageCard({
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
                AppLocalizations.of(context)!.settingsLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              LayoutConstants.gapM,
              Text(
                AppLocalizations.of(context)!.settingsLanguageDesc,
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
                            const Icon(Icons.language, size: 18),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.languageSystem),
                          ],
                        ),
                        selected: notifier.locale == null,
                        onSelected: (selected) {
                          if (selected) {
                            notifier.setLocale(null);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇬🇧'),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.languageEnglish),
                          ],
                        ),
                        selected: notifier.locale?.languageCode == 'en',
                        onSelected: (selected) {
                          if (selected) {
                            notifier.setLocale(const Locale('en'));
                          }
                        },
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇩🇪'),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.languageGerman),
                          ],
                        ),
                        selected: notifier.locale?.languageCode == 'de',
                        onSelected: (selected) {
                          if (selected) {
                            notifier.setLocale(const Locale('de'));
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
