export 'rita_rule_evaluator_native.dart' if (dart.library.html) 'rita_rule_evaluator_web.dart';

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:flutter_js/flutter_js.dart' show getJavascriptRuntime, JavascriptRuntime;
// import 'package:flutter_js/flutter_js.dart';
// import 'package:flutter_json_forms/src/models/ui_schema.dart' as ui;

// class RitaRuleEvaluator {
//   final JavascriptRuntime jsRuntime;
//   final String jsBundlePath = 'packages/flutter_json_forms/assets/js/rita-core.js';
//   bool _initialized = false;
//   Completer<dynamic>? _ritaCompleter;
//   Map<String, ui.ShowOnProperty> ritaRules = {};

//   RitaRuleEvaluator._(this.jsRuntime);

//   /// Factory to load the bundle from assets and create the evaluator
//   static RitaRuleEvaluator create() {
//     final jsRuntime = getJavascriptRuntime();
//     // jsRuntime.evaluate(jsBundle);
//     return RitaRuleEvaluator._(jsRuntime);
//   }

//   Future<void> initializeWithBundle() async {
//     if (_initialized) return;

//     final jsBundle = await rootBundle.loadString(jsBundlePath);

//     // Polyfill globalThis if needed
//     // jsRuntime.evaluate('var globalThis = this;');

//     // Expose the Dart callback to JS as a global function
//     // jsRuntime.evaluate('flutterCallback = function(result) { sendMessage("flutterCallback", result); };');

//     // Load the Rita bundle
//     jsRuntime.evaluate(jsBundle);

//     // Register the Dart-side callback for JS to call
//     jsRuntime.onMessage('flutterCallback', (args) {
//       _ritaCompleter?.complete(args);
//     });

//     // // Define the async ritaEval function in JS
//     // String jsEval = '''
//     //   async function ritaEval(rule, data) {
//     //     try {
//     //       // sendMessage("flutterCallback", JSON.stringify(data));
//     //       var parser = new rita.Parser();
//     //       var ruleSet = parser.parseRuleSet(rule);
//     //       var result = await ruleSet[0].evaluate(data);
//     //       sendMessage("flutterCallback", result);
//     //     } catch (e) {
//     //       sendMessage("flutterCallback", "JS Exception: " + (e && e.message ? e.message : e));
//     //     }
//     //   }
//     // ''';
//     // jsRuntime.evaluate(jsEval);
//     String jsEval = '''
//       // Store all evaluators by rule id
//       var ritaEvaluators = {};

//       // Register all rules at once
//       function registerRitaRules(ruleset) {
//         if (!ruleset.rules) return;
//         for (var i = 0; i < ruleset.rules.length; i++) {
//           var ruleObj = ruleset.rules[i];
//           var parser = new rita.Parser();
//           var ruleSet = parser.parseRuleSet({rules: [ruleObj]});
//           // Store the evaluator for this rule id
//           ritaEvaluators[ruleObj.id] = ruleSet[0];
//         }
//       }

//       // Evaluate a rule by id
//       async function ritaEvalById(ruleId, data) {
//         try {
//           var evaluator = ritaEvaluators[ruleId];
//           if (!evaluator) {
//             sendMessage("flutterCallback", "JS Exception: No evaluator for ruleId " + ruleId);
//             return;
//           }
//           var result = await evaluator.evaluate(data);
//           sendMessage("flutterCallback", result);
//         } catch (e) {
//           sendMessage("flutterCallback", "JS Exception: " + (e && e.message ? e.message : e));
//         }
//       }
//     ''';
//     jsRuntime.evaluate(jsEval);

//     final rulesCleaned = <Map<String, dynamic>>[];
//     for (final rule in ritaRules.values) {
//       rulesCleaned.add({"id": rule.id, "comment": rule.comment ?? "", "rule": rule.rule});
//     }
//     final rita = jsonEncode({"\$schema": "../../src/schema/schema.json", "rules": rulesCleaned});
//     jsRuntime.evaluate('registerRitaRules($rita);');

//     _initialized = true;
//   }

//   void addRule(ui.ShowOnProperty rule) {
//     if (rule.id != null) {
//       ritaRules[rule.id!] = rule;
//     }
//   }

//   /// Evaluate a Rita rule and data (both as JSON strings)
//   Future<bool> evaluate(String ruleId, String dataJson) async {
//     if (!_initialized) {
//       print("should already be initialized!");
//       await initializeWithBundle();
//     }
//     // final rulesCleaned = <Map<String, dynamic>>[];
//     // for (final rule in rules) {
//     //   rulesCleaned.add({"id": rule.id, "comment": rule.comment ?? "", "rule": rule.rule});
//     // }

//     // final rita = jsonEncode({"\$schema": "../../src/schema/schema.json", "rules": rulesCleaned});
//     // _ritaCompleter = Completer<dynamic>();

//     // jsRuntime.evaluate('ritaEval($rita, "");');

//     // // Wait for the callback to complete
//     // final result = await _ritaCompleter!.future;
//     // return result;

//     _ritaCompleter = Completer<dynamic>();
//     try {
//       jsRuntime.evaluate('ritaEvalById("$ruleId", $dataJson);');
//     } catch (e) {
//       print("JS Exception during evaluate: $e");
//       return false;
//     }
//     final result = await _ritaCompleter!.future;
//     // Handle result as before
//     return result == true || result.toString().trim() == 'true' || result.toString().trim() == '1';
//   }

//   /// Evaluate All
//   /// TODO slow, use javascript evaluate all function so no dart overhead
//   Future<Map<String, bool>> evaluateAll(String dataJson) async {
//     if (!_initialized) {
//       print("should already be initialized!");
//       await initializeWithBundle();
//     }

//     // dataJson =
//     //     '{"description":"This good text was set as default","group_selector":"Groups","rating":12,"weekdays":[],"testObject":{"age":10},"fancyness":"unicorn","hiddenDateTime":"2025-08-23T21:06:00.980323","hiddenDate":"\$now","hiddenTime":"\$now"}';

//     Map<String, bool> results = {};

//     for (final rule in ritaRules.values) {
//       // _ritaCompleter = Completer<dynamic>();
//       // jsRuntime.evaluate('ritaEvalById("${rule.id}", $dataJson);');
//       final result = await evaluate(rule.id!, dataJson);
//       results[rule.id!] = result;
//     }
//     return results;
//   }
// }
