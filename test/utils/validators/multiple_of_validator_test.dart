import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/utils/validators/multiple_of_validator.dart';

void main() {
  group('MultipleOfValidator', () {
    test('validates integer multiples', () {
      final validator = MultipleOfValidator<dynamic>(5);
      expect(validator.validateValue(10), isNull);
      expect(validator.validateValue(0), isNull);
      expect(validator.validateValue(7), isNotNull);
    });

    test('validates double multiples within epsilon', () {
      final validator = MultipleOfValidator<dynamic>(0.1);
      expect(validator.validateValue(0.2), isNull);
      expect(validator.validateValue(0.3000000001), isNull); // within epsilon
      expect(validator.validateValue(0.25), isNotNull);
    });

    test('validates string input', () {
      final validator = MultipleOfValidator<dynamic>(3);
      expect(validator.validateValue('6'), isNull);
      expect(validator.validateValue('7'), isNotNull);
      expect(validator.validateValue(''), isNull);
      expect(validator.validateValue('abc'), isNotNull);
    });

    test('returns null for step == 0', () {
      final validator = MultipleOfValidator<dynamic>(0);
      expect(validator.validateValue(10), isNull);
      expect(validator.validateValue('10'), isNull);
    });

    test('returns null for null candidate', () {
      final validator = MultipleOfValidator<dynamic>(2);
      expect(validator.validateValue(null), isNull);
    });

    test('uses custom errorTextBuilder', () {
      final validator = MultipleOfValidator<dynamic>(4, errorTextBuilder: (step) => 'Custom error: $step');
      expect(validator.translatedErrorText, 'Custom error: 4');
      expect(validator.validateValue(5), 'Custom error: 4');
    });
  });
}
