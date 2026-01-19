// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'form_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get buttonRemove => 'Remove';

  @override
  String get buttonAdd => 'Add';

  @override
  String get buttonDragHandle => 'Drag to reorder';

  @override
  String validateMinItems(Object minItems) {
    return 'Please add at least $minItems items.';
  }

  @override
  String validateMaxFileSize(Object maxFileSize) {
    return 'The file exceeds the maximum size of $maxFileSize';
  }
}
