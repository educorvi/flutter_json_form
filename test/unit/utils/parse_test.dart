import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_json_forms/src/utils/parse.dart';

void main() {
  group('Parse Utils Tests', () {
    group('safeParseNum', () {
      test('should return num unchanged when input is num', () {
        expect(safeParseNum(42), equals(42));
        expect(safeParseNum(42.5), equals(42.5));
        expect(safeParseNum(-10), equals(-10));
        expect(safeParseNum(0), equals(0));
      });

      test('should parse valid string numbers', () {
        expect(safeParseNum('42'), equals(42));
        expect(safeParseNum('42.5'), equals(42.5));
        expect(safeParseNum('-10'), equals(-10));
        expect(safeParseNum('0'), equals(0));
        expect(safeParseNum('0.0'), equals(0.0));
      });

      test('should return 0 for invalid string numbers', () {
        expect(safeParseNum('invalid'), equals(0));
        expect(safeParseNum(''), equals(0));
        expect(safeParseNum('abc123'), equals(0));
        expect(safeParseNum('12.34.56'), equals(0));
      });

      test('should return 0 for non-string, non-num types', () {
        expect(safeParseNum(null), equals(0));
        expect(safeParseNum(true), equals(0));
        expect(safeParseNum(false), equals(0));
        expect(safeParseNum([]), equals(0));
        expect(safeParseNum({}), equals(0));
      });

      test('should handle edge cases', () {
        expect(safeParseNum('   42   '), equals(42)); // whitespace
        expect(safeParseNum('Infinity'), equals(double.infinity));
        expect(safeParseNum('-Infinity'), equals(double.negativeInfinity));
        expect(safeParseNum('NaN').isNaN, isTrue);
      });
    });

    group('safeParseDouble', () {
      test('should convert num to double', () {
        expect(safeParseDouble(42), equals(42.0));
        expect(safeParseDouble(42.5), equals(42.5));
        expect(safeParseDouble(-10), equals(-10.0));
        expect(safeParseDouble(0), equals(0.0));
      });

      test('should parse valid string numbers to double', () {
        expect(safeParseDouble('42'), equals(42.0));
        expect(safeParseDouble('42.5'), equals(42.5));
        expect(safeParseDouble('-10.75'), equals(-10.75));
        expect(safeParseDouble('0'), equals(0.0));
        expect(safeParseDouble('0.0'), equals(0.0));
      });

      test('should return 0.0 for invalid string numbers', () {
        expect(safeParseDouble('invalid'), equals(0.0));
        expect(safeParseDouble(''), equals(0.0));
        expect(safeParseDouble('abc123'), equals(0.0));
        expect(safeParseDouble('12.34.56'), equals(0.0));
      });

      test('should return 0.0 for non-string, non-num types', () {
        expect(safeParseDouble(null), equals(0.0));
        expect(safeParseDouble(true), equals(0.0));
        expect(safeParseDouble(false), equals(0.0));
        expect(safeParseDouble([]), equals(0.0));
        expect(safeParseDouble({}), equals(0.0));
      });

      test('should handle edge cases', () {
        expect(safeParseDouble('   42.5   '), equals(42.5)); // whitespace
        expect(safeParseDouble('Infinity'), equals(double.infinity));
        expect(safeParseDouble('-Infinity'), equals(double.negativeInfinity));
        expect(safeParseDouble('NaN').isNaN, isTrue);
      });

      test('should ensure return type is always double', () {
        final result = safeParseDouble(42);
        expect(result, isA<double>());
        expect(result.runtimeType, equals(double));
      });
    });

    group('trySafeParseInt', () {
      test('should return int unchanged when input is int', () {
        expect(trySafeParseInt(42), equals(42));
        expect(trySafeParseInt(-10), equals(-10));
        expect(trySafeParseInt(0), equals(0));
      });

      test('should convert double to int (truncated)', () {
        expect(trySafeParseInt(42.0), equals(42));
        expect(trySafeParseInt(42.9), equals(42));
        expect(trySafeParseInt(-10.5), equals(-10));
      });

      test('should parse valid string integers', () {
        expect(trySafeParseInt('42'), equals(42));
        expect(trySafeParseInt('-10'), equals(-10));
        expect(trySafeParseInt('0'), equals(0));
      });

      test('should return null for invalid string numbers', () {
        expect(trySafeParseInt('42.5'), isNull); // decimal string
        expect(trySafeParseInt('invalid'), isNull);
        expect(trySafeParseInt(''), isNull);
        expect(trySafeParseInt('abc123'), isNull);
        expect(trySafeParseInt('12.34'), isNull);
      });

      test('should return null for non-string, non-num types', () {
        expect(trySafeParseInt(null), isNull);
        expect(trySafeParseInt(true), isNull);
        expect(trySafeParseInt(false), isNull);
        expect(trySafeParseInt([]), isNull);
        expect(trySafeParseInt({}), isNull);
      });

      test('should handle edge cases', () {
        expect(trySafeParseInt('   42   '), equals(42)); // whitespace
        expect(trySafeParseInt('Infinity'), isNull);
        expect(trySafeParseInt('-Infinity'), isNull);
        expect(trySafeParseInt('NaN'), isNull);
      });

      test('should handle large integers', () {
        expect(trySafeParseInt('9223372036854775807'), equals(9223372036854775807)); // max int64
        expect(trySafeParseInt('-9223372036854775808'), equals(-9223372036854775808)); // min int64
      });
    });

    group('safeParseInt', () {
      test('should convert num to int', () {
        expect(safeParseInt(42), equals(42));
        expect(safeParseInt(42.0), equals(42));
        expect(safeParseInt(42.9), equals(42)); // truncated
        expect(safeParseInt(-10.5), equals(-10));
        expect(safeParseInt(0), equals(0));
      });

      test('should parse valid string integers', () {
        expect(safeParseInt('42'), equals(42));
        expect(safeParseInt('-10'), equals(-10));
        expect(safeParseInt('0'), equals(0));
      });

      test('should return 0 for invalid string numbers', () {
        expect(safeParseInt('42.5'), equals(0)); // decimal string
        expect(safeParseInt('invalid'), equals(0));
        expect(safeParseInt(''), equals(0));
        expect(safeParseInt('abc123'), equals(0));
        expect(safeParseInt('12.34'), equals(0));
      });

      test('should return 0 for non-string, non-num types', () {
        expect(safeParseInt(null), equals(0));
        expect(safeParseInt(true), equals(0));
        expect(safeParseInt(false), equals(0));
        expect(safeParseInt([]), equals(0));
        expect(safeParseInt({}), equals(0));
      });

      test('should handle edge cases', () {
        expect(safeParseInt('   42   '), equals(42)); // whitespace
        expect(safeParseInt('Infinity'), equals(0));
        expect(safeParseInt('-Infinity'), equals(0));
        expect(safeParseInt('NaN'), equals(0));
      });

      test('should ensure return type is always int', () {
        final result = safeParseInt(42.7);
        expect(result, isA<int>());
        expect(result.runtimeType, equals(int));
        expect(result, equals(42));
      });

      test('should handle large integers', () {
        expect(safeParseInt('9223372036854775807'), equals(9223372036854775807));
        expect(safeParseInt('-9223372036854775808'), equals(-9223372036854775808));
      });
    });

    group('Comparative behavior tests', () {
      test('safeParseInt vs trySafeParseInt for valid inputs', () {
        const validInputs = [42, '42', '-10', '0'];

        for (final input in validInputs) {
          final safeResult = safeParseInt(input);
          final tryResult = trySafeParseInt(input);

          expect(tryResult, isNotNull, reason: 'trySafeParseInt should not return null for valid input: $input');
          expect(safeResult, equals(tryResult), reason: 'Results should match for valid input: $input');
        }
      });

      test('safeParseInt vs trySafeParseInt for invalid inputs', () {
        const invalidInputs = ['invalid', '42.5', null, true, []];

        for (final input in invalidInputs) {
          final safeResult = safeParseInt(input);
          final tryResult = trySafeParseInt(input);

          expect(safeResult, equals(0), reason: 'safeParseInt should return 0 for invalid input: $input');
          expect(tryResult, isNull, reason: 'trySafeParseInt should return null for invalid input: $input');
        }
      });

      test('type consistency across all parse functions', () {
        const testValue = 42;

        expect(safeParseNum(testValue), isA<num>());
        expect(safeParseDouble(testValue), isA<double>());
        expect(safeParseInt(testValue), isA<int>());
        expect(trySafeParseInt(testValue), isA<int?>());
      });
    });
  });
}
