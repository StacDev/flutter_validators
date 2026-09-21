import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart';

void main() {
  group('URL Validator Tests', () {
    test('Valid URLs', () {
      expect('https://google.com'.isURL, isTrue);
      expect('http://example.com/path?query=1'.isURL, isTrue);
      expect('https://sub.domain.org'.isURL, isTrue);
      expect('http://localhost'.isURL, isTrue);
      expect('http://127.0.0.1'.isURL, isTrue);
    });

    test('Invalid URLs', () {
      expect('invalid-url'.isURL, isFalse);
      expect('ftp://server.com'.isURL, isFalse); // We only support http/https
      expect('javascript:alert(1)'.isURL, isFalse);
      expect('https://'.isURL, isFalse);
      expect('http://.'.isURL, isFalse);
      expect('http://foo'.isURL, isFalse);
      expect(''.isURL, isFalse);
    });
  });
}
