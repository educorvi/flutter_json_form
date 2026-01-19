import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/notifiers/form_theme_notifier.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';

class SettingsDesignSystemCard extends StatelessWidget {
  final FormThemeNotifier notifier;

  const SettingsDesignSystemCard({
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
                AppLocalizations.of(context)!.settingsFormDesignSystem,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              LayoutConstants.gapM,
              Text(
                AppLocalizations.of(context)!.settingsFormDesignSystemDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              LayoutConstants.gapM,
              ListenableBuilder(
                listenable: notifier,
                builder: (context, child) {
                  return RadioGroup<DesignSystem>(
                    groupValue: notifier.designSystem,
                    onChanged: (value) {
                      if (value != null) {
                        notifier.setDesignSystem(value);
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<DesignSystem>(
                          title: Text(AppLocalizations.of(context)!.designSystemGoogleMaterial),
                          subtitle: Text(AppLocalizations.of(context)!.designSystemGoogleMaterialDesc),
                          value: DesignSystem.googleMaterial,
                        ),
                        RadioListTile<DesignSystem>(
                          title: Text(AppLocalizations.of(context)!.designSystemUVCooperative),
                          subtitle: Text(AppLocalizations.of(context)!.designSystemUVCooperativeDesc),
                          value: DesignSystem.uvCooperativeDesign,
                        ),
                      ],
                    ),
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
