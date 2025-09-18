# Logging in Flutter JSON Forms

Flutter JSON Forms includes logging to help debug form behavior, understand performance, and track issues.

## Quick Start

### 1. Enable Logging in the App

 Enable logging to the console  with Formatting

```dart
void setupCustomLogging() {
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String().substring(11, 23);
    final level = record.level.name.padRight(7);
    final logger = record.loggerName.padRight(30);

    print('[$time] $level $logger: ${record.message}');

    if (record.error != null) {
      print('  ↳ Error: ${record.error}');
    }
  });
}
```

### 3. Component-Specific Loggers

The package provides loggers for different components:

```dart
// Get individual component loggers
final formLogger = FormLogger.formBuilder;
final arrayLogger = FormLogger.arrayField;
final ritaLogger = FormLogger.ritaEvaluator;
final validationLogger = FormLogger.validator;
```

## Custom Log Handling

### File Logging

```dart
import 'dart:io';

void setupFileLogging() {
  final logFile = File('app_logs.txt');

  Logger.root.onRecord.listen((record) {
    final logEntry = '[${record.time}] ${record.level.name}: ${record.loggerName}: ${record.message}\n';
    logFile.writeAsStringSync(logEntry, mode: FileMode.append);
  });
}
```

### Filter Specific Components

```dart
void setupFilteredLogging() {
  Logger.root.onRecord.listen((record) {
    // Only log array field and form builder events
    if (record.loggerName.contains('arrayField') || 
        record.loggerName.contains('formBuilder')) {
      print('${record.level.name}: ${record.message}');
    }
  });
}
```

## Production Considerations

### Disable Logging in Release Builds

```dart
void main() {
  // Only enable logging in debug mode
  if (kDebugMode) {
    FormLogger.initialize(level: Level.INFO);
  }

  runApp(MyApp());
}
```

### Performance-Conscious Logging

```dart
void main() {
  // Enable only warnings and errors in release
  FormLogger.initialize(
    level: kDebugMode ? Level.ALL : Level.WARNING
  );

  runApp(MyApp());
}
```

## Example Log Output

```
[14:32:15.123] INFO    fjf.formBuilder: Starting form initialization
[14:32:15.145] DEBUG   fjf.formBuilder: Initializing JavaScript engine and rule set
[14:32:15.234] DEBUG   fjf.formBuilder: Loading and validating schemas
[14:32:15.267] DEBUG   fjf.formBuilder: Initializing form data and rules
[14:32:15.445] INFO    fjf.formBuilder: Form initialization completed successfully
[14:32:18.567] DEBUG   fjf.formBuilder: Form value changed: /properties/name = "John"
[14:32:18.574] DEBUG   fjf.arrayField: Adding new array item
[14:32:18.576] DEBUG   fjf.arrayField: Array now has 3 items
```

## Integration with Analytics

```dart
void setupAnalyticsLogging() {
  Logger.root.onRecord.listen((record) {
    // Send errors to crash analytics
    if (record.level >= Level.SEVERE) {
      FirebaseCrashlytics.instance.recordError(
        record.error ?? record.message,
        record.stackTrace,
      );
    }

    // Track form usage metrics
    if (record.loggerName.contains('form_builder') && 
        record.message.contains('initialization completed')) {
      Analytics.track('form_loaded');
    }
  });
}
```

## Common Use Cases

### Debugging Form Issues
Set `Level.ALL` to see detailed form behavior during development.

### Production Monitoring
Use `Level.WARNING` to catch issues without overwhelming logs.

### Performance Analysis
Monitor form initialization and rita evaluation timing.

### User Experience Tracking
Log form interactions to understand user behavior patterns.