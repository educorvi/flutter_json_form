import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;

class RitaRuleEvaluator {
  bool _initialized = false;
  Map<String, ui.ShowOnProperty> ritaRules = {};

  RitaRuleEvaluator._();

  static RitaRuleEvaluator create() => RitaRuleEvaluator._();

  Future<void> initializeWithBundle() async {
    if (_initialized) return;
    // Assume rita-core.js is loaded in index.html
    // You may need to expose registerRitaRules and ritaEvalById globally in JS
    final rulesCleaned = <Map<String, dynamic>>[];
    for (final rule in ritaRules.values) {
      rulesCleaned.add({"id": rule.id, "comment": rule.comment ?? "", "rule": rule.rule});
    }
    final rita = jsonEncode({"\$schema": "../../src/schema/schema.json", "rules": rulesCleaned});
    js.context.callMethod('registerRitaRules', [jsonDecode(rita)]);
    _initialized = true;
  }

  void addRule(ui.ShowOnProperty rule) {
    if (rule.id != null) {
      ritaRules[rule.id!] = rule;
    }
  }

  Future<bool> evaluate(String ruleId, String dataJson) async {
    if (!_initialized) await initializeWithBundle();
    final result = js.context.callMethod('ritaEvalByIdSync', [ruleId, jsonDecode(dataJson)]);
    return result == true || result.toString().trim() == 'true' || result.toString().trim() == '1';
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
}
