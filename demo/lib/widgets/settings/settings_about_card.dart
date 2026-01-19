import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsAboutCard extends StatelessWidget {
  const SettingsAboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: LayoutConstants.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.settingsAbout,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              LayoutConstants.gapM,
              Text(AppLocalizations.of(context)!.aboutAppName),
              LayoutConstants.gapS,
              Text(
                AppLocalizations.of(context)!.aboutAppDesc,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              LayoutConstants.gapM,
              InkWell(
                onTap: () async {
                  final uri = Uri.parse('https://github.com/your-repo/flutter_json_forms');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.aboutViewOnGitHub,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
