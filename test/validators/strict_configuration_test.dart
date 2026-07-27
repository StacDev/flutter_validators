import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart';

void main() {
  group('strict validation is opt-in', () {
    test('JWT checks decoded JSON only in strict mode', () {
      const valid =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJzdWIiOiIxMjM0NTY3ODkwIn0.signature';
      expect(isJWT('aaa.bbb.'), isTrue);
      expect(isJWT('aaa.bbb.', strict: true), isFalse);
      expect('aaa.bbb.'.isJWTWith(strict: true), isFalse);
      expect(isJWT(valid, strict: true), isTrue);
      expect(Validator.jwt(strict: true, allowUnsigned: false)(valid), isNull);
    });

    test('Base32 enforces legal encoded lengths in strict mode', () {
      expect(isBase32('ABC'), isTrue);
      expect(isBase32('ABC', strict: true), isFalse);
      expect('MZXW6YTB'.isBase32With(strict: true), isTrue);
      expect(Validator.base32(strict: true)('ABC'), isNotNull);
    });

    test('credit-card strict mode rejects repeated and unknown patterns', () {
      expect(isCreditCard('0000000000000000'), isTrue);
      expect(isCreditCard('0000000000000000', strict: true), isFalse);
      expect('4111111111111111'.isCreditCardWith(strict: true), isTrue);
      expect(Validator.creditCard(strict: true)('0000000000000000'), isNotNull);
    });
  });

  group('configurable validators', () {
    test('email supports Unicode and local domains by request', () {
      expect(isEmail('δοκιμή@παράδειγμα.δοκιμή'), isFalse);
      expect(isEmail('δοκιμή@παράδειγμα.δοκιμή', allowUnicode: true), isTrue);
      expect(
        'δοκιμή@παράδειγμα.δοκιμή'.isEmailWith(allowUnicode: true),
        isTrue,
      );
      expect(isEmail('user@localhost', requireTld: false), isTrue);
      expect(
        Validator.email(allowUnicode: true)('δοκιμή@παράδειγμα.δοκιμή'),
        isNull,
      );
    });

    test('URL protocols, TLD, localhost, and underscore options', () {
      expect(isURL('ftp://example.com'), isFalse);
      expect(
        isURL('ftp://example.com', protocols: const ['ftp'], requireTld: true),
        isTrue,
      );
      expect(
        'ftp://example.com'.isURLWith(
          protocols: const ['ftp'],
          requireTld: true,
        ),
        isTrue,
      );
      expect(
        isURL('https://localhost', requireTld: true, allowLocalhost: false),
        isFalse,
      );
      expect(Validator.url(requireTld: true)('https://example.com'), isNull);
    });

    test('FQDN and UUID expose rule options', () {
      expect(isFQDN('service_name.example.com'), isFalse);
      expect(
        isFQDN('service_name.example.com', allowUnderscores: true),
        isTrue,
      );
      expect(
        'service_name.example.com'.isFQDNWith(allowUnderscores: true),
        isTrue,
      );
      expect(isFQDN('example.com.', allowTrailingDot: false), isFalse);
      const v4 = '550e8400-e29b-41d4-a716-446655440000';
      expect(isUUID(v4, 4), isTrue);
      expect(isUUID(v4, 1), isFalse);
      expect(v4.isUUIDVersion(4), isTrue);
      expect(Validator.uuid(version: 4)(v4), isNull);
    });
  });
}
