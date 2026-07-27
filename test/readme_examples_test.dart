import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart'
    hide endsWith, isNegative, isPositive, startsWith;

void main() {
  tearDown(Validator.resetMessageResolver);

  test('five-minute quick start', () {
    final cleaned = trim('  Test.User+news@GMAIL.com  ');
    final normalized = normalizeEmail(cleaned);
    final emailRule = compose<String>([
      Validator.required(),
      Validator.email(),
    ]);

    expect(normalized, 'testuser@gmail.com');
    expect(emailRule(normalized), isNull);
    expect(isURL('https://dart.dev'), isTrue);
    expect('2024-02-29'.isISO8601Date, isTrue);
  });

  test('composition examples', () {
    final passwordReport = aggregate<String>([
      Validator.length(12, errorMessage: 'Use at least 12 characters'),
      Validator.matches(RegExp(r'\d'), errorMessage: 'Add a number'),
    ]);
    expect(passwordReport('short'), 'Use at least 12 characters\nAdd a number');

    final contact = any<String>([
      Validator.email(),
      Validator.url(),
    ], errorMessage: 'Enter an email or URL');
    expect(contact('https://dart.dev'), isNull);

    final fluent = Validator.required()
        .and(Validator.email())
        .when((value) => value != 'skip')
        .withMessage('Enter a usable email');
    expect(fluent('bad'), 'Enter a usable email');

    final positiveAge = when<int>(
      (value) => value != null,
      (value) => value! > 0 ? null : 'Age must be positive',
    );
    expect(positiveAge(-1), 'Age must be positive');

    final evenItemCount = transform<List<String>, int>(
      (items) => items?.length,
      (length) => length == null || length.isEven ? null : 'Use an even count',
    );
    expect(evenItemCount(['one']), 'Use an even count');
  });

  test('strict and configurable examples', () {
    expect(isDate('2023-13-01'), isTrue);
    expect(isISO8601Date('2023-13-01'), isFalse);
    expect(isJWT('aaa.bbb.'), isTrue);
    expect(isJWT('aaa.bbb.', strict: true), isFalse);
    expect(isBase32('ABC'), isTrue);
    expect(isBase32('ABC', strict: true), isFalse);
    expect(isCreditCard('0000000000000000'), isTrue);
    expect(isCreditCard('0000000000000000', strict: true), isFalse);
    expect(isEmail('δοκιμή@παράδειγμα.δοκιμή', allowUnicode: true), isTrue);
    expect(
      isURL('ftp://example.com', protocols: const ['ftp'], requireTld: true),
      isTrue,
    );
    expect(isFQDN('service_name.example.com', allowUnderscores: true), isTrue);
    expect(isUUID('550e8400-e29b-41d4-a716-446655440000', 4), isTrue);
  });

  test('new validator examples', () {
    expect(isPositive('12.5'), isTrue);
    expect(isNegative('-2'), isTrue);
    expect(isInRange('18', 13, 120), isTrue);
    expect(isDivisibleBy('24', 6), isTrue);
    expect(isTime('23:59:59'), isTrue);
    expect(isBefore('2024-12-31', DateTime.utc(2025)), isTrue);
    expect(isAfter('2025-01-02', DateTime.utc(2025)), isTrue);
    expect(startsWith('Flutter', 'flutter', ignoreCase: true), isTrue);
    expect(endsWith('report.pdf', '.pdf'), isTrue);
    expect(isSingleLine('one line'), isTrue);
    expect(hasWordCount('a short profile', min: 2, max: 20), isTrue);
    expect(isIBAN('GB82 WEST 1234 5698 7654 32'), isTrue);
    expect(isBIC('DEUTDEFF'), isTrue);
    expect(isCreditCardCVC('123'), isTrue);
    expect(
      isCreditCardExpirationDate('06/30', referenceDate: DateTime(2030, 6)),
      isTrue,
    );
    expect(isISBN('0-306-40615-2', version: 10), isTrue);
    expect(isISBN('978-0-306-40615-7', version: 13), isTrue);
    expect(
      isHash(
        'e3b0c44298fc1c149afbf4c8996fb924'
        '27ae41e4649b934ca495991b7852b855',
        HashAlgorithm.sha256,
      ),
      isTrue,
    );
    expect(isMimeType('application/json'), isTrue);
    expect(isDataURI('data:text/plain;base64,SGVsbG8='), isTrue);
  });

  test('sanitization and messages examples', () {
    final email = normalizeEmail(trim('  User@Example.COM  '));
    expect(email, 'User@example.com');
    expect(Validator.required().and(Validator.email())(email), isNull);
    expect(whitelist('+1 (415) 555-0100', '0123456789'), '14155550100');
    expect(toInt('42'), 42);

    var locale = 'en';
    Validator.messageResolver = (message) {
      const translations = {
        'es': {
          'required': 'Este campo es obligatorio',
          'email': 'Introduce un correo válido',
        },
      };
      return translations[locale]?[message.key] ?? message.fallback;
    };
    final rule = Validator.required().and(Validator.email());
    locale = 'es';
    expect(rule('bad'), 'Introduce un correo válido');
    expect(
      Validator.email(errorMessage: 'Account email is invalid')('bad'),
      'Account email is invalid',
    );
  });
}
