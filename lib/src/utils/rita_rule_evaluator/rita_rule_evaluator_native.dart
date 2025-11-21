import 'dart:async';
import 'dart:convert';
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
      final jsBundle = await rootBundle.loadString(jsBundlePath);
      jsRuntime.evaluate(jsBundle);
      _logger.fine('Rita JS bundle loaded and evaluated');

      jsRuntime.onMessage('flutterCallback', (args) {
        _ritaCompleter?.complete(args);
      });

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
            sendMessage("flutterCallback", "JS Exception: " + (e && e.message ? e.message : e));
          }
        }
      ''';
      jsRuntime.evaluate(jsEval);

      final rulesCleaned = <Map<String, dynamic>>[];
      for (final rule in ritaRules.values) {
        rulesCleaned.add({"id": rule.id, "comment": rule.comment ?? "", "rule": rule.rule});
      }
      final rita = jsonEncode({"\$schema": "../../src/schema/schema.json", "rules": rulesCleaned});
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
    try {
      _logger.finest('Evaluating rule $ruleId');
      jsRuntime.evaluate('ritaEvalById("$ruleId", $dataJson);');
    } catch (e, stackTrace) {
      _logger.severe('JS Exception during evaluate for rule $ruleId', e, stackTrace);
      return false;
    }
    final result = await _ritaCompleter!.future;
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
    return results;
  }

  Future<void> dispose() async {
    if (!_initialized) return;
    _initialized = false;
    _disposed = true;
    ritaRules.clear();
    // _ritaCompleter?.completeError('Disposed');
    // _ritaCompleter = null;
    jsRuntime.clearXhrPendingCalls();
    jsRuntime.dispose();
    // If this method exists and cleans up timers/resources
  }

  // Future<void> evaluateAll(String dataJson) async {
  //   _ritaDependencies = await _evaluateAll(dataJson);
  // }

  // Map<String, bool> get ritaDependencies => _ritaDependencies;
}
