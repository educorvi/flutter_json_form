/// The RitaRuleEvaluator uses javaScript behind the scenes to evaluate Rita rules.
/// This means on web platforms a different implementation is needed than on native platforms.
/// On web javascript is available natively, while on native platforms a plugin to run javascript code is required.
library;

export 'rita_rule_evaluator_native.dart' if (dart.library.html) 'rita_rule_evaluator_web.dart';
