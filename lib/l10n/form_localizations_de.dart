// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'form_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get buttonRemove => 'Entfernen';

  @override
  String get buttonAdd => 'Hinzufügen';

  @override
  String get buttonDragHandle => 'Ziehen zum Verschieben';

  @override
  String validateMinItems(Object minItems) {
    return 'Bitte mindestens $minItems Elemente hinzufügen.';
  }

  @override
  String validateMaxFileSize(Object maxFileSize) {
    return 'Die Datei überschreitet die maximale Größe von $maxFileSize';
  }
}
