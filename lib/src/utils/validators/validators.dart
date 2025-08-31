import 'package:flutter/widgets.dart';
import 'package:flutter_json_forms/src/utils/validators/multiple_of_validator.dart';

/// Static accessors for JSON Schema related validators.
class JsonSchemaValidators {
  /// Validates that the value is a multiple of [step] (JSON Schema `multipleOf`).
  ///
  /// - Pass [errorText] to provide a fixed error message (highest priority).
  /// - Or pass [errorTextBuilder] to build a translated message (e.g. via your
  ///   own AppLocalizations.of(context).multipleOfError(step)).
  /// - If neither are provided, a simple English fallback is used.
  static FormFieldValidator<T> multipleOf<T>(
    num step, {
    String? errorText,
    bool checkNullOrEmpty = true,
    MultipleOfErrorTextBuilder? errorTextBuilder,
    double epsilon = 1e-9,
  }) =>
      MultipleOfValidator<T>(
        step,
        errorText: errorText,
        checkNullOrEmpty: checkNullOrEmpty,
        errorTextBuilder: errorTextBuilder,
        epsilon: epsilon,
      ).validate;
}
