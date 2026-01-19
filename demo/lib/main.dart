import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_forms_demo/notifiers/accessibility_notifier.dart';
import 'package:flutter_json_forms_demo/notifiers/form_theme_notifier.dart';
import 'package:flutter_json_forms_demo/notifiers/locale_notifier.dart';
import 'package:flutter_json_forms_demo/notifiers/theme_mode_notifier.dart';
import 'package:flutter_json_forms_demo/widgets/actions/theme_mode_switcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/pages/custom_form_page.dart';
import 'package:flutter_json_forms_demo/pages/example_forms_page.dart';
import 'package:flutter_json_forms_demo/pages/settings_page.dart';
import 'package:flutter_json_forms_demo/widgets/adaptive_navigation.dart';
import 'package:flutter_json_forms_demo/widgets/actions/design_system_switcher.dart';
import 'package:logging/logging.dart';
import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter_json_forms_demo/l10n/app_localizations.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

final themeModeNotifier = ThemeModeNotifier();
final formThemeNotifier = FormThemeNotifier();
final accessibilityNotifier = AccessibilityNotifier();
final localeNotifier = LocaleNotifier();

late final Highlighter jsonLightHighlighter;
late final Highlighter jsonDarkHighlighter;

void main() async {
  // Initialize logging for the Flutter JSON Forms package
  Logger.root.level = kDebugMode ? Level.FINE : Level.WARNING;

  _setupCustomLogging();

  // Ensure Flutter bindings are initialized for async operations before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize syntax highlighter
  await Highlighter.initialize(['json']);
  final lightTheme = await HighlighterTheme.loadLightTheme();
  final darkTheme = await HighlighterTheme.loadDarkTheme();
  jsonLightHighlighter = Highlighter(language: 'json', theme: lightTheme);
  jsonDarkHighlighter = Highlighter(language: 'json', theme: darkTheme);

  // Load saved settings
  await Future.wait([
    themeModeNotifier.loadThemeMode(),
    formThemeNotifier.loadDesignSystem(),
    accessibilityNotifier.loadEnabled(),
    localeNotifier.loadLocale(),
  ]);

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
      listenable: Listenable.merge([themeModeNotifier, formThemeNotifier, accessibilityNotifier, localeNotifier]),
      builder: (context, child) {
        final currentAppConstants = AppConstants(designSystem: formThemeNotifier.designSystem);
        return MaterialApp(
          builder: accessibilityNotifier.enabled ? (context, child) => AccessibilityTools(child: child) : null,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
          ],
          title: 'Flutter Json Forms Demo',
          theme: currentAppConstants.theme.getThemeData(Brightness.light),
          darkTheme: currentAppConstants.theme.getThemeData(Brightness.dark),
          themeMode: themeModeNotifier.themeMode,
          locale: localeNotifier.locale,
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
            appBarTitle: Text(AppLocalizations.of(context)!.appTitle),
            appBarActions: [
              DesignSystemSwitcher(notifier: formThemeNotifier),
              const SizedBox(width: LayoutConstants.spacingS),
              ThemeModeSwitcher(notifier: themeModeNotifier),
              const SizedBox(width: LayoutConstants.spacingS),
            ],
            items: [
              NavigationItem(
                label: AppLocalizations.of(context)!.navExamples,
                selectedIcon: currentAppConstants.navigationBar.homePageIconSelected,
                unselectedIcon: currentAppConstants.navigationBar.homePageIconUnselected,
                page: const ExampleFormsPage(),
              ),
              NavigationItem(
                label: AppLocalizations.of(context)!.navCustomForm,
                selectedIcon: currentAppConstants.navigationBar.databasePageIconSelected,
                unselectedIcon: currentAppConstants.navigationBar.databasePageIconUnselected,
                page: const CustomFormPage(),
              ),
              NavigationItem(
                label: AppLocalizations.of(context)!.navSettings,
                selectedIcon: currentAppConstants.navigationBar.settingsPageIconSelected,
                unselectedIcon: currentAppConstants.navigationBar.settingsPageIconUnselected,
                page: SettingsPage(
                  formThemeNotifier: formThemeNotifier,
                  themeModeNotifier: themeModeNotifier,
                  accessibilityNotifier: accessibilityNotifier,
                  localeNotifier: localeNotifier,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
