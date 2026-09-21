import 'package:flutter_validators/form_validator.dart';
import 'package:test/test.dart' hide contains, isIn;

void main() {
  group('Flutter Form Validator Tests', () {
    test('Required validator', () {
      final req = Validator.required(errorMessage: 'Empty');
      expect(req(''), equals('Empty'));
      expect(req(null), equals('Empty'));
      expect(req('  '), equals('Empty'));
      expect(req('hello'), isNull);
    });

    test('Email validator', () {
      final email = Validator.email(errorMessage: 'Bad email');
      expect(email('user@example.com'), isNull);
      expect(email('invalid'), equals('Bad email'));
      expect(
        email(''),
        isNull,
      ); // Empty strings are treated as valid (use 'required' for emptiness check)
      expect(email(null), isNull);
    });

    test('compose runs validators in order and returns the first error', () {
      final email = Validator.compose([
        Validator.required(errorMessage: 'Email is required'),
        Validator.email(errorMessage: 'Enter a valid email'),
      ]);
      expect(email(''), 'Email is required');
      expect(email(null), 'Email is required');
      expect(email('  '), 'Email is required');
      expect(email('invalid'), 'Enter a valid email');
      expect(email('user@example.com'), isNull);
    });

    test('Length validator', () {
      final len = Validator.length(3, max: 5, errorMessage: 'Bad len');
      expect(len('abc'), isNull);
      expect(len('ab'), equals('Bad len'));
      expect(len('abcdef'), equals('Bad len'));
    });

    test('Empty values are valid for all non-required validators', () {
      expect(Validator.url()(''), isNull);
      expect(Validator.url()(null), isNull);
      expect(Validator.email()(null), isNull);
    });

    test('URL validator', () {
      final url = Validator.url(errorMessage: 'Bad URL');
      expect(url('https://example.com'), isNull);
      expect(url('not a url'), equals('Bad URL'));
    });

    test('IP validator', () {
      final ip = Validator.ip(errorMessage: 'Bad IP');
      expect(ip('192.168.1.1'), isNull);
      expect(ip('999.999.999.999'), equals('Bad IP'));
      expect(Validator.ip(version: 4)('192.168.1.1'), isNull);
    });

    test('Date validator', () {
      final date = Validator.date(errorMessage: 'Bad date');
      expect(date('2024-01-15'), isNull);
      expect(date('not-a-date'), equals('Bad date'));
    });

    test('Numeric validator', () {
      final numeric = Validator.numeric(errorMessage: 'Bad number');
      expect(numeric('123.45'), isNull);
      expect(numeric('abc'), equals('Bad number'));
    });

    test('Integer validator', () {
      final integer = Validator.integer(errorMessage: 'Bad int');
      expect(integer('42'), isNull);
      expect(integer('4.2'), equals('Bad int'));
    });

    test('Alpha validator', () {
      final alpha = Validator.alpha(errorMessage: 'Bad alpha');
      expect(alpha('abc'), isNull);
      expect(alpha('abc1'), equals('Bad alpha'));
    });

    test('Alphanumeric validator', () {
      final alphanumeric = Validator.alphanumeric(errorMessage: 'Bad');
      expect(alphanumeric('abc123'), isNull);
      expect(alphanumeric('abc!'), equals('Bad'));
    });

    test('Phone validator', () {
      final phone = Validator.phone(errorMessage: 'Bad phone');
      expect(phone('+1234567890'), isNull);
      expect(phone('abc'), equals('Bad phone'));
    });

    test('Credit card validator', () {
      final creditCard = Validator.creditCard(errorMessage: 'Bad card');
      expect(creditCard('4111111111111111'), isNull);
      expect(creditCard('1234'), equals('Bad card'));
    });

    test('JSON validator', () {
      final json = Validator.json(errorMessage: 'Bad JSON');
      expect(json('{"a":1}'), isNull);
      expect(json('{bad'), equals('Bad JSON'));
    });

    test('UUID validator', () {
      final uuid = Validator.uuid(errorMessage: 'Bad UUID');
      expect(uuid('550e8400-e29b-41d4-a716-446655440000'), isNull);
      expect(uuid('not-a-uuid'), equals('Bad UUID'));
    });

    test('Hex color validator', () {
      final hexColor = Validator.hexColor(errorMessage: 'Bad color');
      expect(hexColor('#ff0000'), isNull);
      expect(hexColor('zzz'), equals('Bad color'));
    });

    test('ASCII validator', () {
      final ascii = Validator.ascii(errorMessage: 'Bad ASCII');
      expect(ascii('hello'), isNull);
      expect(ascii('héllo'), equals('Bad ASCII'));
    });

    test('Base32 validator', () {
      final base32 = Validator.base32(errorMessage: 'Bad base32');
      expect(base32('JBSWY3DP'), isNull);
      expect(base32('1'), equals('Bad base32'));
    });

    test('Base58 validator', () {
      final base58 = Validator.base58(errorMessage: 'Bad base58');
      expect(base58('3yDKLZJ4PC1HE4Y8L8Esx'), isNull);
      expect(base58('0OIl'), equals('Bad base58'));
    });

    test('Boolean validator', () {
      final boolean = Validator.boolean(errorMessage: 'Bad boolean');
      expect(boolean('true'), isNull);
      expect(boolean('maybe'), equals('Bad boolean'));
    });

    test('Equals validator', () {
      final eq = Validator.equals('secret', errorMessage: 'No match');
      expect(eq('secret'), isNull);
      expect(eq('other'), equals('No match'));
    });

    test('Lowercase validator', () {
      final lowercase = Validator.lowercase(errorMessage: 'Bad case');
      expect(lowercase('hello'), isNull);
      expect(lowercase('Hello'), equals('Bad case'));
    });

    test('Uppercase validator', () {
      final uppercase = Validator.uppercase(errorMessage: 'Bad case');
      expect(uppercase('HELLO'), isNull);
      expect(uppercase('Hello'), equals('Bad case'));
    });

    test('Hexadecimal validator', () {
      final hexadecimal = Validator.hexadecimal(errorMessage: 'Bad hex');
      expect(hexadecimal('deadBEEF'), isNull);
      expect(hexadecimal('xyz'), equals('Bad hex'));
    });

    test('Octal validator', () {
      final octal = Validator.octal(errorMessage: 'Bad octal');
      expect(octal('777'), isNull);
      expect(octal('088'), equals('Bad octal'));
    });

    test('Decimal validator', () {
      final decimal = Validator.decimal(errorMessage: 'Bad decimal');
      expect(decimal('1.5'), isNull);
      expect(decimal('1.'), equals('Bad decimal'));
    });

    test('Float validator', () {
      final float = Validator.float(errorMessage: 'Bad float');
      expect(float('3.14'), isNull);
      expect(float('abc'), equals('Bad float'));
      final ranged = Validator.float(min: 0, max: 10, errorMessage: 'Range');
      expect(ranged('5'), isNull);
      expect(ranged('20'), equals('Range'));
    });

    test('MongoId validator', () {
      final mongoId = Validator.mongoId(errorMessage: 'Bad id');
      expect(mongoId('507f1f77bcf86cd799439011'), isNull);
      expect(mongoId('507f1f77'), equals('Bad id'));
    });

    test('MD5 validator', () {
      final md5 = Validator.md5(errorMessage: 'Bad hash');
      expect(md5('d41d8cd98f00b204e9800998ecf8427e'), isNull);
      expect(md5('abc'), equals('Bad hash'));
    });

    test('Port validator', () {
      final port = Validator.port(errorMessage: 'Bad port');
      expect(port('8080'), isNull);
      expect(port('65536'), equals('Bad port'));
    });

    test('SemVer validator', () {
      final semVer = Validator.semVer(errorMessage: 'Bad version');
      expect(semVer('1.2.3'), isNull);
      expect(semVer('1.2'), equals('Bad version'));
    });

    test('Slug validator', () {
      final slug = Validator.slug(errorMessage: 'Bad slug');
      expect(slug('my-blog-post'), isNull);
      expect(slug('Bad Slug'), equals('Bad slug'));
    });

    test('MAC address validator', () {
      final macAddress = Validator.macAddress(errorMessage: 'Bad MAC');
      expect(macAddress('00:1B:44:11:3A:B7'), isNull);
      expect(macAddress('00:1B:44'), equals('Bad MAC'));
    });

    test('LatLong validator', () {
      final latLong = Validator.latLong(errorMessage: 'Bad coords');
      expect(latLong('40.7128,-74.0060'), isNull);
      expect(latLong('91,0'), equals('Bad coords'));
    });

    test('JWT validator', () {
      final jwt = Validator.jwt(errorMessage: 'Bad JWT');
      expect(jwt('eyJhbGci.eyJzdWIi.SflKxwRJ'), isNull);
      expect(jwt('eyJhbGci.eyJzdWIi'), equals('Bad JWT'));
    });

    test('FQDN validator', () {
      final fqdn = Validator.fqdn(errorMessage: 'Bad domain');
      expect(fqdn('example.com'), isNull);
      expect(fqdn('localhost'), equals('Bad domain'));
    });

    test('Base64 validator', () {
      final base64 = Validator.base64(errorMessage: 'Bad base64');
      expect(base64('aGVsbG8='), isNull);
      expect(base64('@@@@'), equals('Bad base64'));
      final urlSafe = Validator.base64(
        urlSafe: true,
        errorMessage: 'Bad url64',
      );
      expect(urlSafe('a-b_cdef'), isNull);
    });

    test('ByteLength validator', () {
      final byteLength = Validator.byteLength(
        2,
        max: 5,
        errorMessage: 'Bad len',
      );
      expect(byteLength('abc'), isNull);
      expect(byteLength('a'), equals('Bad len'));
      expect(byteLength('abcdef'), equals('Bad len'));
    });

    test('StrongPassword validator', () {
      final strongPassword = Validator.strongPassword(errorMessage: 'Weak');
      expect(strongPassword('Abcd1234!'), isNull);
      expect(strongPassword('weak'), equals('Weak'));
      final relaxed = Validator.strongPassword(
        minUppercase: 0,
        minNumbers: 0,
        minSymbols: 0,
        errorMessage: 'Weak',
      );
      expect(relaxed('abcdefgh'), isNull);
    });

    test('Contains validator', () {
      final containsWorld = Validator.contains(
        'world',
        errorMessage: 'Missing',
      );
      expect(containsWorld('hello world'), isNull);
      expect(containsWorld('hello there'), equals('Missing'));
      final caseInsensitive = Validator.contains(
        'WORLD',
        ignoreCase: true,
        errorMessage: 'Missing',
      );
      expect(caseInsensitive('hello world'), isNull);
    });

    test('Matches validator', () {
      final matches = Validator.matches(
        RegExp(r'^\d{4}$'),
        errorMessage: 'Bad format',
      );
      expect(matches('1234'), isNull);
      expect(matches('abc'), equals('Bad format'));
    });

    test('InList validator', () {
      final inList = Validator.inList([
        'red',
        'green',
        'blue',
      ], errorMessage: 'Not allowed');
      expect(inList('red'), isNull);
      expect(inList('yellow'), equals('Not allowed'));
    });
  });
}
