import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter Json Forms Demo'**
  String get appTitle;

  /// Navigation label for examples page
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get navExamples;

  /// Navigation label for custom form page
  ///
  /// In en, this message translates to:
  /// **'Custom Form'**
  String get navCustomForm;

  /// Navigation label for settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Form design system section title
  ///
  /// In en, this message translates to:
  /// **'Form Design System'**
  String get settingsFormDesignSystem;

  /// Form design system section description
  ///
  /// In en, this message translates to:
  /// **'Select the design system for form rendering'**
  String get settingsFormDesignSystemDesc;

  /// Google Material Design option
  ///
  /// In en, this message translates to:
  /// **'Google Material Design'**
  String get designSystemGoogleMaterial;

  /// Google Material Design description
  ///
  /// In en, this message translates to:
  /// **'Standard Material Design components'**
  String get designSystemGoogleMaterialDesc;

  /// UV Cooperate Design option
  ///
  /// In en, this message translates to:
  /// **'UV Cooperate Design'**
  String get designSystemUVCooperative;

  /// UV Cooperate Design description
  ///
  /// In en, this message translates to:
  /// **'Custom UV Cooperate design system'**
  String get designSystemUVCooperativeDesc;

  /// Theme mode section title
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeMode;

  /// Theme mode section description
  ///
  /// In en, this message translates to:
  /// **'Select the color theme for the app'**
  String get settingsThemeModeDesc;

  /// System theme mode option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// Light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// Dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// Language section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Language section description
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get settingsLanguageDesc;

  /// System language option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// Accessibility section title
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibility;

  /// Accessibility section description
  ///
  /// In en, this message translates to:
  /// **'Enable accessibility inspector to test your forms'**
  String get settingsAccessibilityDesc;

  /// Accessibility inspector switch title
  ///
  /// In en, this message translates to:
  /// **'Accessibility Inspector'**
  String get accessibilityInspector;

  /// Accessibility inspector switch description
  ///
  /// In en, this message translates to:
  /// **'Show accessibility overlay with tap areas and semantics'**
  String get accessibilityInspectorDesc;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// App name in about section
  ///
  /// In en, this message translates to:
  /// **'Flutter JSON Forms Demo'**
  String get aboutAppName;

  /// App description in about section
  ///
  /// In en, this message translates to:
  /// **'A demonstration app for the Flutter JSON Forms package'**
  String get aboutAppDesc;

  /// View on GitHub link text
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get aboutViewOnGitHub;

  /// JSON Schema label
  ///
  /// In en, this message translates to:
  /// **'JSON Schema'**
  String get jsonSchema;

  /// UI Schema label
  ///
  /// In en, this message translates to:
  /// **'UI Schema'**
  String get uiSchema;

  /// Preset Data label
  ///
  /// In en, this message translates to:
  /// **'Preset Data'**
  String get presetData;

  /// Show Form Data button
  ///
  /// In en, this message translates to:
  /// **'Show Form Data'**
  String get showFormData;

  /// Reset Form button
  ///
  /// In en, this message translates to:
  /// **'Reset Form'**
  String get resetForm;

  /// Show JSON Schema button
  ///
  /// In en, this message translates to:
  /// **'Show JSON Schema'**
  String get showJsonSchema;

  /// Show UI Schema button
  ///
  /// In en, this message translates to:
  /// **'Show UI Schema'**
  String get showUiSchema;

  /// Select Form dropdown label
  ///
  /// In en, this message translates to:
  /// **'Select Form'**
  String get selectForm;

  /// Copy button
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// JSON Schema file upload label
  ///
  /// In en, this message translates to:
  /// **'JSON Schema File'**
  String get jsonSchemaFile;

  /// UI Schema file upload label
  ///
  /// In en, this message translates to:
  /// **'UI Schema File'**
  String get uiSchemaFile;

  /// Load Files button
  ///
  /// In en, this message translates to:
  /// **'Load Files'**
  String get loadFiles;

  /// Load Schemas button
  ///
  /// In en, this message translates to:
  /// **'Load Schemas'**
  String get loadSchemas;

  /// Error loading schemas message
  ///
  /// In en, this message translates to:
  /// **'Error loading schemas: {error}'**
  String errorLoadingSchemas(String error);

  /// Schemas loaded successfully message
  ///
  /// In en, this message translates to:
  /// **'Schemas loaded successfully!'**
  String get schemasLoadedSuccessfully;

  /// Error parsing JSON message
  ///
  /// In en, this message translates to:
  /// **'Error parsing JSON: {error}'**
  String errorParsingJson(String error);

  /// Please select both schema files message
  ///
  /// In en, this message translates to:
  /// **'Please select both schema files'**
  String get pleaseSelectBothSchemaFiles;

  /// Files loaded successfully message
  ///
  /// In en, this message translates to:
  /// **'Files loaded successfully!'**
  String get filesLoadedSuccessfully;

  /// Error loading files message
  ///
  /// In en, this message translates to:
  /// **'Error loading files: {error}'**
  String errorLoadingFiles(String error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
