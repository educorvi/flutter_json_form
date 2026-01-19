// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Json Forms Demo';

  @override
  String get navExamples => 'Examples';

  @override
  String get navCustomForm => 'Custom Form';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsFormDesignSystem => 'Form Design System';

  @override
  String get settingsFormDesignSystemDesc => 'Select the design system for form rendering';

  @override
  String get designSystemGoogleMaterial => 'Google Material Design';

  @override
  String get designSystemGoogleMaterialDesc => 'Standard Material Design components';

  @override
  String get designSystemUVCooperative => 'UV Cooperate Design';

  @override
  String get designSystemUVCooperativeDesc => 'Custom UV Cooperate design system';

  @override
  String get settingsThemeMode => 'Theme Mode';

  @override
  String get settingsThemeModeDesc => 'Select the color theme for the app';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDesc => 'Select your preferred language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get settingsAccessibility => 'Accessibility';

  @override
  String get settingsAccessibilityDesc => 'Enable accessibility inspector to test your forms';

  @override
  String get accessibilityInspector => 'Accessibility Inspector';

  @override
  String get accessibilityInspectorDesc => 'Show accessibility overlay with tap areas and semantics';

  @override
  String get settingsAbout => 'About';

  @override
  String get aboutAppName => 'Flutter JSON Forms Demo';

  @override
  String get aboutAppDesc => 'A demonstration app for the Flutter JSON Forms package';

  @override
  String get aboutViewOnGitHub => 'View on GitHub';

  @override
  String get jsonSchema => 'JSON Schema';

  @override
  String get uiSchema => 'UI Schema';

  @override
  String get presetData => 'Preset Data';

  @override
  String get showFormData => 'Show Form Data';

  @override
  String get resetForm => 'Reset Form';

  @override
  String get showJsonSchema => 'Show JSON Schema';

  @override
  String get showUiSchema => 'Show UI Schema';

  @override
  String get selectForm => 'Select Form';

  @override
  String get copy => 'Copy';

  @override
  String get close => 'Close';

  @override
  String get jsonSchemaFile => 'JSON Schema File';

  @override
  String get uiSchemaFile => 'UI Schema File';

  @override
  String get loadFiles => 'Load Files';

  @override
  String get loadSchemas => 'Load Schemas';

  @override
  String errorLoadingSchemas(String error) {
    return 'Error loading schemas: $error';
  }

  @override
  String get schemasLoadedSuccessfully => 'Schemas loaded successfully!';

  @override
  String errorParsingJson(String error) {
    return 'Error parsing JSON: $error';
  }

  @override
  String get pleaseSelectBothSchemaFiles => 'Please select both schema files';

  @override
  String get filesLoadedSuccessfully => 'Files loaded successfully!';

  @override
  String errorLoadingFiles(String error) {
    return 'Error loading files: $error';
  }
}
