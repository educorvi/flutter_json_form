import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/notifiers/theme_mode_notifier.dart';

class ThemeModeIcon extends StatelessWidget {
  final ThemeMode themeMode;

  const ThemeModeIcon({
    super.key,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    switch (themeMode) {
      case ThemeMode.system:
        return const Icon(Icons.brightness_auto);
      case ThemeMode.light:
        return const Icon(Icons.light_mode);
      case ThemeMode.dark:
        return const Icon(Icons.dark_mode);
    }
  }
}

class ThemeModeSwitcher extends StatelessWidget {
  final ThemeModeNotifier notifier;

  const ThemeModeSwitcher({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, child) {
        return IconButton(
          icon: ThemeModeIcon(themeMode: notifier.themeMode),
          onPressed: notifier.cycleThemeMode,
          tooltip: _getTooltip(notifier.themeMode),
        );
      },
    );
  }

  String _getTooltip(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System theme (tap for light)';
      case ThemeMode.light:
        return 'Light theme (tap for dark)';
      case ThemeMode.dark:
        return 'Dark theme (tap for system)';
    }
  }
}
