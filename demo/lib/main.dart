import 'package:flutter/material.dart';
import 'package:flutter_json_forms/flutter_json_forms.dart';
import 'package:flutter_json_forms_demo/constants/constants.dart';
import 'package:flutter_json_forms_demo/widgets/form_file/form_file_base.dart';
import 'package:flutter_json_forms_demo/widgets/form_selector.dart';
import 'package:flutter_json_forms_demo/widgets/theme_mode_switcher.dart';
import 'package:logging/logging.dart';
import 'package:accessibility_tools/accessibility_tools.dart';

final themeModeNotifier = ThemeModeNotifier();

void main() {
  // Initialize logging for the Flutter JSON Forms package
  Logger.root.level = Level.FINE;

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
      listenable: themeModeNotifier,
      builder: (context, child) {
        return MaterialApp(
          //builder: (context, child) => AccessibilityTools(child: child),
          localizationsDelegates: const [FormBuilderLocalizations.delegate],
          title: 'Flutter Json Forms Demo',
          theme: appConstants.theme.getThemeData(Brightness.light),
          darkTheme: appConstants.theme.getThemeData(Brightness.dark),
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
  late final FormSelector formSelector;

  @override
  void initState() {
    super.initState();
  }

  FormFile? selectedFormFile;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Flutter Json Forms Demo"),
          actions: [
            ThemeModeSwitcher(notifier: themeModeNotifier),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(8),
          children: [
            Center(child: SizedBox(width: 1000, child: SelectionArea(child: FormSelector()))),
          ],
        ),
      ),
    );
  }
}
