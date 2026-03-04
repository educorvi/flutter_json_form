import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/extensions/xhr.dart';
import 'package:flutter_js/flutter_js.dart' show getJavascriptRuntime, JavascriptRuntime;
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;
import 'package:flutter_json_forms/src/utils/logger.dart';

class RitaRuleEvaluator {
  final JavascriptRuntime jsRuntime;
  final String jsBundlePath = 'packages/flutter_json_forms/assets/js/rita-core.js';
  bool _initialized = false;
  Completer<dynamic>? _ritaCompleter;
  Map<String, ui.ShowOnProperty> ritaRules = {};
  bool _disposed = false;
  static final _logger = FormLogger.ritaEvaluator;

  // Results storage (global scope only)
  final Map<String, bool> _results = {};

  RitaRuleEvaluator._(this.jsRuntime);

  static RitaRuleEvaluator create() {
    _logger.fine('Creating new Rita rule evaluator');
    final jsRuntime = getJavascriptRuntime(xhr: false);
    return RitaRuleEvaluator._(jsRuntime);
  }

  Future<void> initializeWithBundle() async {
    if (_initialized) return;

    _logger.fine('Initializing Rita evaluator with JS bundle');
    try {
      _logger.finest('Loading Rita JS bundle from $jsBundlePath');
      final jsBundle = await _loadJsBundle();
      _logger.finest('Loaded Rita JS bundle (${jsBundle.length} chars)');
      jsRuntime.evaluate(jsBundle);
      _logger.fine('Rita JS bundle loaded and evaluated');

      jsRuntime.onMessage('flutterCallback', (args) {
        _logger.fine('JS -> Dart message: $args (pending completer: ${_ritaCompleter != null})');
        _ritaCompleter?.complete(args);
      });

      _logger.finest('Registering Rita helper functions in JS runtime');

      String jsEval = '''
        var ritaEvaluators = {};
        function registerRitaRules(ruleset) {
          if (!ruleset.rules) return;
          for (var i = 0; i < ruleset.rules.length; i++) {
            var ruleObj = ruleset.rules[i];
            var parser = new rita.Parser();
            var ruleSet = parser.parseRuleSet({rules: [ruleObj]});
            ritaEvaluators[ruleObj.id] = ruleSet[0];
          }
        }
        async function ritaEvalById(ruleId, data) {
          try {
            var evaluator = ritaEvaluators[ruleId];
            if (!evaluator) {
              sendMessage("flutterCallback", "JS Exception: No evaluator for ruleId " + ruleId);
              return;
            }
            var result = await evaluator.evaluate(data);
            sendMessage("flutterCallback", result);
          } catch (e) {
            sendMessage("flutterCallback", JSON.stringify({ ruleId: ruleId, message: e.message, data: data}));
          }
        }
      ''';
      jsRuntime.evaluate(jsEval);
      _logger.finest('Helper functions registered');

      final rulesCleaned = <Map<String, dynamic>>[];
      for (final rule in ritaRules.values) {
        rulesCleaned.add({"id": rule.id, "comment": rule.comment ?? "", "rule": rule.rule});
      }
      final rita = jsonEncode({"\$schema": "../../src/schema/schema.json", "rules": rulesCleaned});
      _logger.finest('Registering ${rulesCleaned.length} Rita rules');
      jsRuntime.evaluate('registerRitaRules($rita);');

      _logger.fine('Rita evaluator initialized with ${ritaRules.length} rules');
      _initialized = true;
    } catch (e, stackTrace) {
      _logger.severe('Failed to initialize Rita evaluator', e, stackTrace);
      rethrow;
    }
  }

  void addRule(ui.ShowOnProperty rule) {
    if (rule.id != null) {
      _logger.fine('Adding Rita rule: ${rule.id} - ${rule.rule}');
      ritaRules[rule.id!] = rule;
    } else {
      _logger.warning('Attempted to add Rita rule without ID: ${rule.rule}');
    }
  }

  Future<bool> evaluate(String ruleId, String dataJson) async {
    if (_disposed) {
      _logger.warning('Attempted to evaluate rule $ruleId on disposed evaluator');
      return false;
    }
    if (!_initialized) {
      _logger.fine('Evaluator not initialized, initializing now for rule $ruleId');
      await initializeWithBundle();
    }

    _ritaCompleter = Completer<dynamic>();
    _logger.finer('Dispatching Rita rule $ruleId with payload: $dataJson');
    try {
      _logger.finest('Evaluating rule $ruleId');
      jsRuntime.evaluate('ritaEvalById("$ruleId", $dataJson);');
    } catch (e, stackTrace) {
      _logger.severe('JS Exception during evaluate for rule $ruleId', e, stackTrace);
      return false;
    }
    final result = await _ritaCompleter!.future;
    _logger.finer('Received Rita result for $ruleId: $result');
    return result == true || result.toString().trim() == 'true' || result.toString().trim() == '1';
  }

  // Future<void> evaluate(String ruleId, String dataJson) async {
  //   final result = await _evaluate(ruleId, dataJson);
  //   _ritaDependencies[ruleId] = result;
  // }

  Future<Map<String, bool>> evaluateAll(String dataJson) async {
    if (!_initialized) await initializeWithBundle();
    Map<String, bool> results = {};
    for (final rule in ritaRules.values) {
      if (_disposed) return results;
      final result = await evaluate(rule.id!, dataJson);
      results[rule.id!] = result;
    }
    _results.clear();
    _results.addAll(results);

    return results;
  }

  /// Get cached result for a rule
  bool? getResult(String ruleId) {
    return _results[ruleId];
  }

  /// Clear all results
  void clearResults() {
    _results.clear();
  }

  Future<void> dispose() async {
    if (!_initialized) return;
    _initialized = false;
    _disposed = true;
    ritaRules.clear();
    _results.clear();
    jsRuntime.clearXhrPendingCalls();
    jsRuntime.dispose();
  }

  // TODO: very hacky as with direct tests in the repo, paths differ
  Future<String> _loadJsBundle() async {
    // List of paths to try in order
    final pathsToTry = [
      jsBundlePath, // 'packages/flutter_json_forms/assets/js/rita-core.js' (when used as dependency)
      'assets/js/rita-core.js', // When running tests from package root
    ];

    Exception? lastException;
    for (final path in pathsToTry) {
      try {
        _logger.finest('Attempting to load Rita bundle from: $path');
        final bundle = await rootBundle.loadString(path).timeout(const Duration(seconds: 2));
        _logger.finest('✓ Successfully loaded Rita bundle from: $path (${bundle.length} chars)');
        return bundle;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        _logger.warning('✗ Failed to load from $path: ${e.runtimeType} - $e');
        // Continue to next path
      }
    }

    // If all rootBundle attempts failed, try file system as last resort (for local dev)
    try {
      _logger.finest('Attempting file system fallback');
      final result = await _loadBundleFromFile();
      _logger.finest('✓ Loaded from file system');
      return result;
    } catch (e) {
      _logger.severe(
        '✗ Unable to load Rita JS bundle from any source.\n'
        'Attempted asset paths: ${pathsToTry.join(", ")}\n'
        'File system fallback also failed.\n'
        'Last error: $lastException',
      );
      throw FlutterError('Unable to load Rita JS bundle from any source. '
          'Tried paths: ${pathsToTry.join(", ")}. '
          'Last error: $lastException');
    }
  }

  Future<String> _loadBundleFromFile() async {
    final localPath = jsBundlePath.replaceFirst('packages/flutter_json_forms/', '');
    final file = File(localPath);
    _logger.finest('Attempting Rita bundle file fallback at ${file.path}');
    if (file.existsSync()) {
      _logger.finest('Loaded Rita bundle from file system fallback at ${file.path}');
      return file.readAsStringSync();
    }
    throw Exception('File not found at ${file.path}');
  }
}
