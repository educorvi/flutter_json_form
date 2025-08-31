import 'package:form_builder_validators/form_builder_validators.dart';

typedef MultipleOfErrorTextBuilder = String Function(num step);

/// Validator class for JSON Schema `multipleOf`.
class MultipleOfValidator<T> extends TranslatedValidator<T> {
  const MultipleOfValidator(
    this.step, {
    this.errorTextBuilder,
    this.epsilon = 1e-9,
    super.errorText,
    super.checkNullOrEmpty,
  });

  /// The divisor to check against.
  final num step;

  /// Optional builder for localized error text.
  final MultipleOfErrorTextBuilder? errorTextBuilder;

  /// Tolerance for floating-point comparisons.
  final double epsilon;

  @override
  String get translatedErrorText => errorTextBuilder?.call(step) ?? 'Value must be a multiple of $step'; // TODO: use correct localisations

  @override
  String? validateValue(T valueCandidate) {
    // Ignore invalid configuration
    if (step == 0) return null;

    num? value;
    if (valueCandidate == null) return null;
    if (valueCandidate is num) {
      value = valueCandidate;
    } else if (valueCandidate is String) {
      final s = valueCandidate.trim();
      if (s.isEmpty) return null;
      value = num.tryParse(s);
    } else {
      // Unsupported type
      return errorText;
    }

    if (value == null) return errorText;

    // Check if value / step is an integer within epsilon tolerance.
    final double ratio = value.toDouble() / step.toDouble();
    final double nearest = ratio.roundToDouble();
    final double diff = (ratio - nearest).abs();
    if (diff <= epsilon) return null;

    return errorText;
  }
}
