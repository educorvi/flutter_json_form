import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';

class FormThemeNotifier extends ChangeNotifier {
  DesignSystem _designSystem = appConstants.designSystem;

  DesignSystem get designSystem => _designSystem;

  void setDesignSystem(DesignSystem system) {
    _designSystem = system;
    notifyListeners();
  }
}

class SettingsPage extends StatelessWidget {
  final FormThemeNotifier themeNotifier;

  const SettingsPage({
    super.key,
    required this.themeNotifier,
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
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                LayoutConstants.gapL,
                Card(
                  child: Padding(
                    padding: LayoutConstants.paddingAll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form Theme',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        LayoutConstants.gapM,
                        Text(
                          'Select the design system for form rendering',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        LayoutConstants.gapM,
                        ListenableBuilder(
                          listenable: themeNotifier,
                          builder: (context, child) {
                            return RadioGroup<DesignSystem>(
                              groupValue: themeNotifier.designSystem,
                              onChanged: (value) {
                                if (value != null) {
                                  themeNotifier.setDesignSystem(value);
                                }
                              },
                              child: Column(
                                children: [
                                  RadioListTile<DesignSystem>(
                                    title: const Text('Google Material Design'),
                                    subtitle: const Text('Standard Material Design components'),
                                    value: DesignSystem.googleMaterial,
                                  ),
                                  RadioListTile<DesignSystem>(
                                    title: const Text('UV Cooperate Design'),
                                    subtitle: const Text('Custom UV Cooperate design system'),
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
                LayoutConstants.gapM,
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: LayoutConstants.paddingAll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          LayoutConstants.gapM,
                          const Text('Flutter JSON Forms Demo'),
                          LayoutConstants.gapS,
                          Text(
                            'A demonstration app for the Flutter JSON Forms package',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
