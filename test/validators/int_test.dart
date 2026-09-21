import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart';

void main() {
  group('Int Validator Tests', () {
    test('Valid integers', () {
      expect('123'.isInt, isTrue);
      expect('-123'.isInt, isTrue);
      expect('01'.isInt, isTrue);
      expect('0'.isInt, isTrue);
      expect('123 '.isInt, isTrue);
    });

    test('Invalid integers', () {
      expect('12.34'.isInt, isFalse);
      expect('abc'.isInt, isFalse);
      expect('0x10'.isInt, isFalse);
      expect('0X10'.isInt, isFalse);
      expect(''.isInt, isFalse);
    });
  });
}
