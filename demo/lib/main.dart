import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/pages/custom_form_page.dart';
import 'package:flutter_json_forms_demo/pages/example_forms_page.dart';
import 'package:flutter_json_forms_demo/pages/settings_page.dart';
import 'package:flutter_json_forms_demo/widgets/adaptive_navigation.dart';
import 'package:flutter_json_forms_demo/widgets/theme_mode_switcher.dart';
import 'package:logging/logging.dart';
// import 'package:accessibility_tools/accessibility_tools.dart';

final themeModeNotifier = ThemeModeNotifier();
final formThemeNotifier = FormThemeNotifier();

void main() {
  // Initialize logging for the Flutter JSON Forms package
  Logger.root.level = kDebugMode ? Level.FINE : Level.WARNING;

  _setupCustomLogging();

  runApp(const MyApp());
  // setupDynamicJsonFormValidation();
}

/// Custom logging setup for the demo app
void _setupCustomLogging() {
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 23);
    final level = record.level.name.padRight(7);
    final logger =
        record.loggerName.length > 30 ? '...${record.loggerName.substring(record.loggerName.length - 27)}' : record.loggerName.padRight(30);

    debugPrint('[$time] $level $logger: ${record.message}');

    if (record.error != null) {
      debugPrint('  ↳ Error: ${record.error}');
    }

    if (record.stackTrace != null && record.level >= Level.SEVERE) {
      debugPrint('  ↳ Stack: ${record.stackTrace}');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeModeNotifier, formThemeNotifier]),
      builder: (context, child) {
        final currentAppConstants = AppConstants(designSystem: formThemeNotifier.designSystem);
        return MaterialApp(
          //builder: (context, child) => AccessibilityTools(child: child),
          localizationsDelegates: const [FormBuilderLocalizations.delegate],
          title: 'Flutter Json Forms Demo',
          theme: currentAppConstants.theme.getThemeData(Brightness.light),
          darkTheme: currentAppConstants.theme.getThemeData(Brightness.dark),
          themeMode: themeModeNotifier.themeMode,
          home: const FlutterFormDemo(),
        );
      },
    );
  }
}

class FlutterFormDemo extends StatefulWidget {
  const FlutterFormDemo({super.key});

  @override
  State<FlutterFormDemo> createState() => _FlutterFormDemoState();
}

class _FlutterFormDemoState extends State<FlutterFormDemo> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: formThemeNotifier,
      builder: (context, child) {
        final currentAppConstants = AppConstants(designSystem: formThemeNotifier.designSystem);
        return SelectionArea(
          child: AdaptiveNavigation(
            appBarTitle: const Text("Flutter Json Forms Demo"),
            appBarActions: [
              ThemeModeSwitcher(notifier: themeModeNotifier),
              const SizedBox(width: LayoutConstants.spacingS),
            ],
            items: [
              NavigationItem(
                label: 'Examples',
                selectedIcon: currentAppConstants.navigationBar.homePageIconSelected,
                unselectedIcon: currentAppConstants.navigationBar.homePageIconUnselected,
                page: const ExampleFormsPage(),
              ),
              NavigationItem(
                label: 'Custom Form',
                selectedIcon: currentAppConstants.navigationBar.databasePageIconSelected,
                unselectedIcon: currentAppConstants.navigationBar.databasePageIconUnselected,
                page: const CustomFormPage(),
              ),
              NavigationItem(
                label: 'Settings',
                selectedIcon: currentAppConstants.navigationBar.settingsPageIconSelected,
                unselectedIcon: currentAppConstants.navigationBar.settingsPageIconUnselected,
                page: SettingsPage(themeNotifier: formThemeNotifier),
              ),
            ],
          ),
        );
      },
    );
  }
}
