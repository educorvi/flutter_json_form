import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_json_forms/src/utils/logger.dart';
import 'package:flutter_json_forms/src/utils/rita_rule_evaluator/rita_rule_evaluator.dart';

/// Simple manager for array-specific Rita rule evaluations.
/// When an array element needs visibility check and the result isn't cached,
/// it schedules evaluation and notifies when done so UI can update.
class VisibilityManager {
  final RitaRuleEvaluator _ritaEvaluator;
  final String Function(Map<String, int>? selfIndices) _buildPayloadJson;
  static final _logger = FormLogger.showOn;

  // Cache for array-specific Rita results: "ruleId|{indices}" -> bool
  final Map<String, bool> _arrayResults = {};
  final Set<String> _pendingEvaluations = <String>{};

  // Notify when evaluations complete
  final ValueNotifier<int> _changeNotifier = ValueNotifier(0);
  ValueListenable<int> get changes => _changeNotifier;

  VisibilityManager({
    required RitaRuleEvaluator ritaEvaluator,
    required String Function(Map<String, int>? selfIndices) buildPayloadJson,
  })  : _ritaEvaluator = ritaEvaluator,
        _buildPayloadJson = buildPayloadJson;

  /// Get cached result for array-specific Rita rule, or schedule evaluation if not cached
  bool? getArrayResult(String ruleId, Map<String, int> selfIndices) {
    final key = _generateArrayKey(ruleId, selfIndices);

    // If we have a cached result, return it (even if stale)
    if (_arrayResults.containsKey(key)) {
      return _arrayResults[key];
    }

    // Otherwise, schedule evaluation
    _scheduleEvaluation(ruleId, selfIndices, key);
    return null; // Not yet evaluated
  }

  void _scheduleEvaluation(String ruleId, Map<String, int> selfIndices, String key) {
    if (_pendingEvaluations.contains(key)) return; // Already scheduled

    _evaluate(ruleId, selfIndices, key).then((_) {
      // Notify after individual evaluation completes
      _changeNotifier.value++;
    });
  }

  Future<void> _evaluate(String ruleId, Map<String, int> selfIndices, String key) async {
    _pendingEvaluations.add(key);
    try {
      final payloadJson = _buildPayloadJson(selfIndices);
      _logger.finer('Evaluating Rita rule $ruleId for indices $selfIndices');
      _logger.finer('Payload for Rita evaluation: $payloadJson');

      final result = await _ritaEvaluator.evaluate(ruleId, payloadJson);
      _arrayResults[key] = result;
      _logger.finer('Rita rule $ruleId evaluated to: $result for indices $selfIndices');
    } catch (e, stackTrace) {
      _logger.severe('Rita evaluation failed for $ruleId with $selfIndices', e, stackTrace);
    } finally {
      _pendingEvaluations.remove(key);
    }
  }

  String _generateArrayKey(String ruleId, Map<String, int> selfIndices) {
    final sorted = Map.fromEntries(
      selfIndices.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$ruleId|${jsonEncode(sorted)}';
  }

  /// Re-evaluate all cached array rules with fresh data
  Future<void> reEvaluateAll() async {
    if (_arrayResults.isEmpty) return;

    _logger.finer('Re-evaluating ${_arrayResults.length} cached array rules');
    final evaluations = <Future<void>>[];

    // Extract rule IDs and indices from cached keys
    for (final key in _arrayResults.keys.toList()) {
      final parts = key.split('|');
      if (parts.length != 2) continue;

      final ruleId = parts[0];
      final selfIndices = Map<String, int>.from(jsonDecode(parts[1]));

      // Schedule re-evaluation (will update cache when complete)
      if (!_pendingEvaluations.contains(key)) {
        evaluations.add(_evaluate(ruleId, selfIndices, key));
      }
    }

    // Wait for all re-evaluations to complete
    // Note: Don't notify here - caller will handle setState after all evaluations
    if (evaluations.isNotEmpty) {
      await Future.wait(evaluations);
      _logger.finer('Re-evaluation complete');
    }
  }

  void clearArrayResults() {
    _arrayResults.clear();
    _pendingEvaluations.clear();
    _changeNotifier.value++;
  }

  void dispose() {
    _changeNotifier.dispose();
  }
}
