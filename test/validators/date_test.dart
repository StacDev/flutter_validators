import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart';

void main() {
  group('Date Validator Tests', () {
    test('Valid Dates', () {
      expect('2023-12-01'.isDate, isTrue);
      expect('2023-12-01 12:00:00'.isDate, isTrue);
      expect('2023-12-01T12:00:00Z'.isDate, isTrue);
      expect('2024-02-29'.isDate, isTrue); // leap year
    });

    test('Invalid Dates', () {
      expect('invalid date'.isDate, isFalse);
      expect('2023-13-01'.isDate, isFalse);
      expect('2023-02-29'.isDate, isFalse);
      expect(''.isDate, isFalse);
    });
  });
}
