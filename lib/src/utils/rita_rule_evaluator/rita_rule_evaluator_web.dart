// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'package:flutter_json_forms/src/models/ui_schema.g.dart' as ui;

class RitaRuleEvaluator {
  bool _initialized = false;
  bool _jsLoaded = false;
  Map<String, ui.ShowOnProperty> ritaRules = {};
  static const String jsBundlePath = 'packages/flutter_json_forms/assets/js/rita-core.js';

  RitaRuleEvaluator._();

  static RitaRuleEvaluator create() => RitaRuleEvaluator._();

  Future<void> _loadJavaScript() async {
    if (_jsLoaded) return;

    try {
      // Load the JavaScript bundle from assets
      final jsBundle = await rootBundle.loadString(jsBundlePath);

      // Create and inject the script
      final scriptElement = web.HTMLScriptElement();
      scriptElement.text = jsBundle;
      web.document.head!.append(scriptElement);

      // Setup global functions
      final setupScript = web.HTMLScriptElement();
      setupScript.text = '''
        var ritaEvaluators = {};

        function registerRitaRules(rulesetJson) {
          var ruleset = JSON.parse(rulesetJson);
          if (!ruleset.rules) return;
          for (var i = 0; i < ruleset.rules.length; i++) {
            var ruleObj = ruleset.rules[i];
            var parser = new rita.Parser();
            var ruleSet = parser.parseRuleSet({rules: [ruleObj]});
            ritaEvaluators[ruleObj.id] = ruleSet[0];
          }
        }

        async function ritaEvalByIdAsync(ruleId, data) {
          var evaluator = ritaEvaluators[ruleId];
          if (!evaluator) return false;

          var parsedData = typeof data === 'string' ? JSON.parse(data) : data;
          var result = await evaluator.evaluate(parsedData);
          return result;
        }
      ''';
      web.document.head!.append(setupScript);

      _jsLoaded = true;
    } catch (e) {
      // print('Error loading Rita JavaScript: $e');
    }
  }

  Future<void> initializeWithBundle() async {
    if (_initialized) return;

    await _loadJavaScript();
    if (!_jsLoaded) return;

    // Prepare rules for registration
    final rulesCleaned = <Map<String, dynamic>>[];
    for (final rule in ritaRules.values) {
      rulesCleaned.add({"id": rule.id, "comment": rule.comment ?? "", "rule": rule.rule});
    }

    if (rulesCleaned.isEmpty) {
      _initialized = true;
      return;
    }

    final rita = jsonEncode({"\$schema": "../../src/schema/schema.json", "rules": rulesCleaned});

    try {
      // Use globalContext to access window's global functions
      globalContext.callMethod('registerRitaRules'.toJS, rita.toJS);
      _initialized = true;
    } catch (e) {
      // print('Error initializing Rita rules: $e');
    }
  }

  void addRule(ui.ShowOnProperty rule) {
    if (rule.id != null) {
      ritaRules[rule.id!] = rule;
    }
  }

  Future<bool> evaluate(String ruleId, String dataJson) async {
    if (!_initialized) await initializeWithBundle();
    if (!_initialized) return false;

    try {
      final jsPromise = globalContext.callMethod('ritaEvalByIdAsync'.toJS, ruleId.toJS, dataJson.toJS);
      final result = await (jsPromise! as JSPromise).toDart.timeout(Duration(seconds: 5));
      // Convert JS result to Dart and check if it's truthy
      final dartResult = result?.dartify();
      final boolResult = dartResult == true || dartResult.toString().trim() == 'true' || dartResult.toString().trim() == '1';
      return boolResult;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, bool>> evaluateAll(String dataJson) async {
    if (!_initialized) await initializeWithBundle();

    Map<String, bool> results = {};
    for (final rule in ritaRules.values) {
      final result = await evaluate(rule.id!, dataJson);
      results[rule.id!] = result;
    }
    return results;
  }

  void dispose() {
    // No specific disposal needed for web
    _initialized = false;
    _jsLoaded = false;
    ritaRules.clear();
  }
}
