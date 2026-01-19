import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/notifiers/accessibility_notifier.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';

class SettingsAccessibilityCard extends StatelessWidget {
  final AccessibilityNotifier notifier;

  const SettingsAccessibilityCard({
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
                AppLocalizations.of(context)!.settingsAccessibility,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              LayoutConstants.gapM,
              Text(
                AppLocalizations.of(context)!.settingsAccessibilityDesc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              LayoutConstants.gapM,
              ListenableBuilder(
                listenable: notifier,
                builder: (context, child) {
                  return SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.accessibilityInspector),
                    subtitle: Text(AppLocalizations.of(context)!.accessibilityInspectorDesc),
                    value: notifier.enabled,
                    onChanged: (value) {
                      notifier.setEnabled(value);
                    },
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
