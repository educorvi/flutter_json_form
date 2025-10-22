import 'package:logging/logging.dart';

/// Centralized logging utility for Flutter JSON Forms
class FormLogger {
  static final Map<String, Logger> _loggers = {};
  static final Logger defaultLogger = Logger('fjf');
  // static bool _initialized = false;

  /// Initialize logging for the package
  /// This should be called by consuming applications if they want to see logs
  // static void initialize({Level level = Level.INFO}) {
  //   if (_initialized) return;

  //   Logger.root.level = level;
  //   // Logger.root.onRecord.listen((record) {
  //   //   // Default console output - apps can override this
  //   //   print('[${record.time}] ${record.level.name}: ${record.loggerName}: ${record.message}');
  //   //   if (record.error != null) {
  //   //     print('Error: ${record.error}');
  //   //   }
  //   //   if (record.stackTrace != null) {
  //   //     print('Stack trace: ${record.stackTrace}');
  //   //   }
  //   // });

  //   _initialized = true;
  // }

  /// Get a logger for a specific component
  static Logger getLogger(String name) {
    return _loggers.putIfAbsent(name, () => Logger('fjf.$name'));
  }

  /// Predefined loggers for common components
  static Logger get formBuilder => getLogger('FormBuilder');
  static Logger get arrayField => getLogger('ArrayField');
  static Logger get showOn => getLogger('ShowOn');
  static Logger get ritaEvaluator => getLogger('RitaEvaluator');
  static Logger get validator => getLogger('Validator');
  static Logger get fieldFactory => getLogger('FieldFactory');
  static Logger get generic => defaultLogger;
}

/// Extension to add convenient logging methods
extension LoggerExtension on Logger {
  // void trace(String message) => finest(message);

  // void debug(String message) => fine(message);

  // void warn(String message, [Object? error, StackTrace? stackTrace]) => warning(message, error, stackTrace);

  // void error(String message, [Object? error, StackTrace? stackTrace]) => severe(message, error, stackTrace);
}
