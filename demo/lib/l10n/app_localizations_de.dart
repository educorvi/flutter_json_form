// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Flutter Json Forms Demo';

  @override
  String get navExamples => 'Beispiele';

  @override
  String get navCustomForm => 'Eigenes Formular';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsFormDesignSystem => 'Formular-Designsystem';

  @override
  String get settingsFormDesignSystemDesc => 'Wähle das Designsystem für die Formulardarstellung';

  @override
  String get designSystemGoogleMaterial => 'Google Material Design';

  @override
  String get designSystemGoogleMaterialDesc => 'Standard Material Design Komponenten';

  @override
  String get designSystemUVCooperative => 'UV Cooperate Design';

  @override
  String get designSystemUVCooperativeDesc => 'Benutzerdefiniertes UV Cooperate Designsystem';

  @override
  String get settingsThemeMode => 'Farbmodus';

  @override
  String get settingsThemeModeDesc => 'Wähle das Farbthema für die App';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Hell';

  @override
  String get themeModeDark => 'Dunkel';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageDesc => 'Wähle die bevorzugte Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get settingsAccessibility => 'Barrierefreiheit';

  @override
  String get settingsAccessibilityDesc => 'Aktiviere den Barrierefreiheitsinspektor, um Formulare zu testen';

  @override
  String get accessibilityInspector => 'Barrierefreiheitsinspektor';

  @override
  String get accessibilityInspectorDesc => 'Barrierefreiheits-Overlay mit Tap-Bereichen und Semantik anzeigen';

  @override
  String get settingsAbout => 'Über';

  @override
  String get aboutAppName => 'Flutter JSON Forms Demo';

  @override
  String get aboutAppDesc => 'Eine Demonstrations-App für das Flutter JSON Forms Paket';

  @override
  String get aboutViewOnGitHub => 'Auf GitHub ansehen';

  @override
  String get jsonSchema => 'JSON Schema';

  @override
  String get uiSchema => 'UI Schema';

  @override
  String get presetData => 'Initialdaten';

  @override
  String get showFormData => 'Formulardaten anzeigen';

  @override
  String get resetForm => 'Formular zurücksetzen';

  @override
  String get showJsonSchema => 'JSON Schema anzeigen';

  @override
  String get showUiSchema => 'UI Schema anzeigen';

  @override
  String get selectForm => 'Formular auswählen';

  @override
  String get copy => 'Kopieren';

  @override
  String get close => 'Schließen';

  @override
  String get jsonSchemaFile => 'JSON Schema Datei';

  @override
  String get uiSchemaFile => 'UI Schema Datei';

  @override
  String get loadFiles => 'Dateien laden';

  @override
  String get loadSchemas => 'Schemas laden';

  @override
  String errorLoadingSchemas(String error) {
    return 'Fehler beim Laden der Schemas: $error';
  }

  @override
  String get schemasLoadedSuccessfully => 'Schemas erfolgreich geladen!';

  @override
  String errorParsingJson(String error) {
    return 'Fehler beim Parsen von JSON: $error';
  }

  @override
  String get pleaseSelectBothSchemaFiles => 'Bitte wählen Sie beide Schema-Dateien aus';

  @override
  String get filesLoadedSuccessfully => 'Dateien erfolgreich geladen!';

  @override
  String errorLoadingFiles(String error) {
    return 'Fehler beim Laden der Dateien: $error';
  }
}
