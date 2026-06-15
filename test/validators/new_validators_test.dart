import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart'
    hide endsWith, isNegative, isPositive, startsWith;

void main() {
  group('numeric rules', () {
    test('function and extension APIs', () {
      expect(isPositive('1.5'), isTrue);
      expect('1'.isPositive, isTrue);
      expect(isNegative('-2'), isTrue);
      expect('-2'.isNegative, isTrue);
      expect(isInRange('10', 1, 10), isTrue);
      expect('10'.isInNumericRange(1, 10), isTrue);
      expect(isInRange('10', 1, 10, inclusive: false), isFalse);
      expect(isDivisibleBy('12', 3), isTrue);
      expect('12'.isDivisibleByNumber(5), isFalse);
      expect(isDivisibleBy('12', 0), isFalse);
    });

    test('form APIs skip empty values', () {
      expect(Validator.positive()('2'), isNull);
      expect(Validator.negative()('2'), isNotNull);
      expect(Validator.range(1, 3)('2'), isNull);
      expect(Validator.divisibleBy(2)('3'), isNotNull);
      expect(Validator.range(1, 3)(''), isNull);
    });
  });

  group('date and time rules', () {
    final boundary = DateTime.utc(2025, 1, 1);

    test('strict date, time, before, and after', () {
      expect(isISO8601Date('2024-02-29'), isTrue);
      expect('2024-02-29'.isISO8601Date, isTrue);
      expect(isISO8601Date('2023-02-29'), isFalse);
      expect(isISO8601Date('2023-13-01'), isFalse);
      expect(isTime('23:59:59'), isTrue);
      expect('23:59'.isValidTime(), isTrue);
      expect(isTime('23:59:59', allowSeconds: false), isFalse);
      expect(isBefore('2024-12-31', boundary), isTrue);
      expect('2024-12-31'.isBeforeDate(boundary), isTrue);
      expect('2025-01-02'.isAfterDate(boundary), isTrue);
    });

    test('form APIs', () {
      expect(Validator.iso8601Date()('2023-02-29'), isNotNull);
      expect(Validator.time()('12:30'), isNull);
      expect(Validator.before(boundary)('2025-01-02'), isNotNull);
      expect(Validator.after(boundary)('2025-01-02'), isNull);
    });
  });

  group('text rules', () {
    test('function and extension APIs', () {
      expect(startsWith('Flutter', 'flu', ignoreCase: true), isTrue);
      expect('Flutter'.startsWithText('Flu'), isTrue);
      expect(endsWith('photo.JPG', '.jpg', ignoreCase: true), isTrue);
      expect('photo.jpg'.endsWithText('.jpg'), isTrue);
      expect(isSingleLine('one line'), isTrue);
      expect('two\nlines'.isSingleLine, isFalse);
      expect(hasWordCount('one two three', min: 2, max: 3), isTrue);
      expect('one two'.hasWords(min: 3), isFalse);
    });

    test('form APIs', () {
      expect(Validator.startsWith('app-')('app-user'), isNull);
      expect(Validator.endsWith('.dev')('example.com'), isNotNull);
      expect(Validator.singleLine()('a\nb'), isNotNull);
      expect(Validator.wordCount(min: 2, max: 3)('one two'), isNull);
    });
  });

  group('finance and identifiers', () {
    const iban = 'GB82 WEST 1234 5698 7654 32';

    test('IBAN, BIC, CVC, and expiry', () {
      expect(isIBAN(iban), isTrue);
      expect(iban.isIBAN, isTrue);
      expect(isIBAN('GB82 TEST 1234'), isFalse);
      expect(isBIC('DEUTDEFF'), isTrue);
      expect('DEUTDEFF500'.isBIC, isTrue);
      expect(isCreditCardCVC('123'), isTrue);
      expect('1234'.isCardCVC(), isTrue);
      expect(
        isCreditCardExpirationDate(
          '06/25',
          referenceDate: DateTime(2025, 6, 30),
        ),
        isTrue,
      );
      expect(
        isCreditCardExpirationDate(
          '05/25',
          referenceDate: DateTime(2025, 6, 1),
        ),
        isFalse,
      );
      expect(
        '06/25'.isCardExpiration(referenceDate: DateTime(2025, 6)),
        isTrue,
      );
    });

    test('ISBN-10 and ISBN-13 checksums', () {
      expect(isISBN('0-306-40615-2', version: 10), isTrue);
      expect('978-0-306-40615-7'.isISBN, isTrue);
      expect('0-8044-2957-X'.isISBNVersion(10), isTrue);
      expect(isISBN('9780306406158'), isFalse);
    });

    test('form APIs', () {
      expect(Validator.iban()(iban), isNull);
      expect(Validator.bic()('bad'), isNotNull);
      expect(Validator.cardCVC()('12'), isNotNull);
      expect(
        Validator.cardExpiration(referenceDate: DateTime(2025, 6))('06/25'),
        isNull,
      );
      expect(Validator.isbn(version: 13)('9780306406157'), isNull);
    });
  });

  group('data and security', () {
    const sha256 =
        'e3b0c44298fc1c149afbf4c8996fb924'
        '27ae41e4649b934ca495991b7852b855';

    test('hash, MIME, and data URI', () {
      expect(isHash(sha256, HashAlgorithm.sha256), isTrue);
      expect(sha256.isHashFor(HashAlgorithm.sha256), isTrue);
      expect(isMimeType('application/json'), isTrue);
      expect('image/svg+xml'.isMimeType, isTrue);
      expect(isMimeType('not a/type'), isFalse);
      expect(isDataURI('data:text/plain;base64,SGVsbG8='), isTrue);
      expect('data:,Hello%20World'.isDataURI, isTrue);
      expect(isDataURI('data:text/plain;base64,***'), isFalse);
    });

    test('form APIs', () {
      expect(Validator.hash(HashAlgorithm.sha256)(sha256), isNull);
      expect(Validator.mimeType()('application/json'), isNull);
      expect(Validator.dataURI()('bad'), isNotNull);
    });
  });
}
