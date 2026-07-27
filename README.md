<p align="center">
  <img src="https://raw.githubusercontent.com/StacDev/flutter_validators/main/assets/banner.png" alt="Flutter Validators Banner" />
</p>

# Flutter Validators

Dependency-free validation, sanitization, generic composition, localized
messages, and Flutter form helpers for Dart and Flutter.

[![Pub Version](https://img.shields.io/pub/v/flutter_validators.svg?logo=dart&color=blue)](https://pub.dev/packages/flutter_validators)
[![CI](https://github.com/StacDev/flutter_validators/actions/workflows/test.yml/badge.svg)](https://github.com/StacDev/flutter_validators/actions/workflows/test.yml)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

Version 1.3 keeps all 1.2 validation defaults and adds opt-in strict rules,
generic `FieldValidator<T>` composition, resolver-backed messages, and
high-value validators for dates, finance, identifiers, and data formats.

## Features

- Pure Dart with zero runtime dependencies.
- Functions, `String` extensions, and `TextFormField`-ready factories.
- Generic composition for strings, numbers, booleans, collections, and models.
- Optional strict validation without breaking permissive 1.2 defaults.
- Dependency-free localized message resolution.
- 60+ validators and 13 sanitizers.

## Which API Should I Use?

| API | Best for | Example | Return type |
|---|---|---|---|
| Function | services, parsing, tests | `isEmail(value)` | `bool` |
| Extension | concise application code | `value.isEmail` | `bool` |
| Form factory | Flutter forms and messages | `Validator.email()` | `FieldValidator<String>` |
| Composition | reusable business rules | `compose([ruleA, ruleB])` | `FieldValidator<T>` |

All non-required form validators accept `null` and `''`. Add
`Validator.required()` when a value must be present.

## Installation

Pure Dart:

```sh
dart pub add flutter_validators
```

Flutter:

```sh
flutter pub add flutter_validators
```

Then import the public library:

```dart
import 'package:flutter_validators/flutter_validators.dart';
```

## Five-Minute Quick Start

This complete Dart program validates, sanitizes, and composes rules:

```dart
import 'package:flutter_validators/flutter_validators.dart';

void main() {
  final rawEmail = '  Test.User+news@GMAIL.com  ';
  final cleaned = trim(rawEmail);
  final normalized = normalizeEmail(cleaned);

  final emailRule = compose<String>([
    Validator.required(),
    Validator.email(),
  ]);

  print(normalized); // testuser@gmail.com
  print(emailRule(normalized)); // null
  print(isURL('https://dart.dev')); // true
  print('2024-02-29'.isISO8601Date); // true
}
```

A complete Flutter field:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_validators/flutter_validators.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: Validator.required(errorMessage: 'Email is required')
          .and(Validator.email(errorMessage: 'Enter a valid email')),
    );
  }
}
```

## Registration Form

The runnable example contains the full screen. This smaller complete form shows
required fields, composition, password rules, conditional validation, and
custom messages:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_validators/flutter_validators.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final key = GlobalKey<FormState>();
  bool createTeam = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validator.required().and(Validator.email()),
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: Validator.required().and(
              Validator.strongPassword(
                errorMessage: 'Use upper, lower, number, and symbol',
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Create a team'),
            value: createTeam,
            onChanged: (value) => setState(() => createTeam = value),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Team name'),
            validator: Validator.required().when((_) => createTeam),
          ),
          ElevatedButton(
            onPressed: () => key.currentState!.validate(),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

Run all interactive examples:

```sh
cd example
flutter run
```

## Composition

`compose` stops at the first error. `aggregate` returns all errors. `any`
succeeds when one rule succeeds.

```dart
final requiredEmail = compose<String>([
  Validator.required(),
  Validator.email(),
]);

final passwordReport = aggregate<String>([
  Validator.length(12, errorMessage: 'Use at least 12 characters'),
  Validator.matches(RegExp(r'\d'), errorMessage: 'Add a number'),
]);

final contact = any<String>([
  Validator.email(),
  Validator.url(),
], errorMessage: 'Enter an email or URL');

final fluent = Validator.required()
    .and(Validator.email())
    .when((value) => value != 'skip')
    .withMessage('Enter a usable email');
```

Generic rules work beyond strings:

```dart
final positiveAge = when<int>(
  (value) => value != null,
  (value) => value! > 0 ? null : 'Age must be positive',
);

final evenItemCount = transform<List<String>, int>(
  (items) => items?.length,
  (length) => length == null || length.isEven ? null : 'Use an even count',
);
```

See [Composition recipes](doc/composition.md) for `unless`, `skipWhen`, `.or()`,
and model validation.

## Optional And Required Fields

```dart
final optionalWebsite = Validator.url();
optionalWebsite(null); // null
optionalWebsite(''); // null

final requiredWebsite = Validator.required().and(Validator.url());
requiredWebsite(''); // "This field is required"
```

## Strict And Configurable Validation

Old behavior remains the default. Strictness is explicit:

```dart
isDate('2023-13-01'); // true: DateTime.tryParse rollover
isISO8601Date('2023-13-01'); // false: real YYYY-MM-DD calendar date

isJWT('aaa.bbb.'); // true: structural compatibility check
isJWT('aaa.bbb.', strict: true); // false: decoded JSON is required

isBase32('ABC'); // true: compatibility mode
isBase32('ABC', strict: true); // false: invalid encoded length

isCreditCard('0000000000000000'); // true: Luhn compatibility mode
isCreditCard('0000000000000000', strict: true); // false
```

Configure web and identifier rules:

```dart
isEmail('δοκιμή@παράδειγμα.δοκιμή', allowUnicode: true);
isEmail('person@localhost', requireTld: false);
isURL('ftp://example.com', protocols: const ['ftp'], requireTld: true);
isFQDN('service_name.example.com', allowUnderscores: true);
isUUID('550e8400-e29b-41d4-a716-446655440000', 4);
```

The same options are available from `Validator.email`, `Validator.url`,
`Validator.fqdn`, `Validator.uuid`, `Validator.jwt`, `Validator.base32`, and
`Validator.creditCard`. See [Strict validation](doc/strict-validation.md).

## New Validator Recipes

Numeric and date ranges:

```dart
isPositive('12.5');
isNegative('-2');
isInRange('18', 13, 120);
isDivisibleBy('24', 6);

isTime('23:59:59');
isBefore('2024-12-31', DateTime.utc(2025));
isAfter('2025-01-02', DateTime.utc(2025));
```

Text:

```dart
startsWith('Flutter validators', 'flutter', ignoreCase: true);
endsWith('report.pdf', '.pdf');
isSingleLine('one line');
hasWordCount('a short profile', min: 2, max: 20);
```

Finance and identifiers:

```dart
isIBAN('GB82 WEST 1234 5698 7654 32');
isBIC('DEUTDEFF');
isCreditCardCVC('123');
isCreditCardExpirationDate(
  '06/30',
  referenceDate: DateTime(2030, 6),
);
isISBN('0-306-40615-2', version: 10);
isISBN('978-0-306-40615-7', version: 13);
```

Data and security:

```dart
isHash(
  'e3b0c44298fc1c149afbf4c8996fb924'
  '27ae41e4649b934ca495991b7852b855',
  HashAlgorithm.sha256,
);
isMimeType('application/json');
isDataURI('data:text/plain;base64,SGVsbG8=');
```

Each has a form factory such as `Validator.range`, `Validator.before`,
`Validator.wordCount`, `Validator.iban`, `Validator.isbn`,
`Validator.mimeType`, and `Validator.dataURI`.

## Sanitization

Validation answers whether input is acceptable. Sanitization changes input.

```dart
final cleaned = trim('  User@Example.COM  ');
final normalized = normalizeEmail(cleaned); // User@example.com

final safeText = escape('<b>Hello</b>');
final digits = whitelist('+1 (415) 555-0100', '0123456789');
final count = toInt('42');
```

Sanitize first, then validate the transformed value:

```dart
final email = normalizeEmail(trim(rawInput));
final error = Validator.required().and(Validator.email())(email);
```

## Localized Messages

No localization package is required. Set a resolver that maps stable keys and
parameters into the current locale:

```dart
var locale = 'en';

Validator.messageResolver = (message) {
  final translations = {
    'es': {
      'required': 'Este campo es obligatorio',
      'email': 'Introduce un correo válido',
    },
  };
  return translations[locale]?[message.key] ?? message.fallback;
};

final rule = Validator.required().and(Validator.email());
locale = 'es';
rule('bad'); // "Introduce un correo válido"

Validator.email(errorMessage: 'Account email is invalid')('bad');
// Explicit text always wins.

Validator.resetMessageResolver();
```

See [Message resolution](doc/messages.md) for parameter interpolation and
locale lifecycle guidance.

## Behavior Reference

| Area | Default | Opt-in behavior |
|---|---|---|
| Non-required form validators | `null` and `''` are valid | compose with `required()` |
| Date | `DateTime.tryParse` | `isISO8601Date` |
| JWT | three valid-looking segments | `strict: true` decodes JSON |
| Base32 | valid alphabet and compatible padding | strict encoded lengths |
| Credit card | length plus Luhn | network pattern and repeated-digit rejection |
| URL | HTTP/HTTPS URI with authority | protocols, TLD, localhost, underscore rules |
| Email | 1.2 ASCII behavior | Unicode, local domain, IP domain, max length |
| Messages | English fallback | application resolver or explicit message |

| API kind | Empty string | Invalid input | Valid input |
|---|---|---|---|
| Function/extension | validator-specific `false` | `false` | `true` |
| Form factory except `required` | `null` | error string | `null` |
| `required` | error string | `null` | `null` |
| Sanitizer | transformed value | transformed value or nullable conversion | transformed value |

## Common Mistakes

- `Validator.email()` does not require a value. Compose it with
  `Validator.required()`.
- `isDate()` intentionally uses permissive Dart parsing. Use
  `isISO8601Date()` for calendar input.
- Sanitizers do not prove validity. Validate the sanitized result.
- Credit-card validation checks syntax and checksums only. It cannot verify
  ownership, funds, issuer status, or whether a payment will succeed.
- Strict JWT validation decodes structure; it does not verify signatures.

## Migration

From `flutter_validators 1.2`: no existing public symbol was removed or
renamed, and permissive defaults remain. Update the constraint and adopt strict
options gradually.

```yaml
dependencies:
  flutter_validators: ^1.3.0
```

From the legacy `validators` package, import this package and replace calls
incrementally. Most common function names are compatible; parameterized and
form APIs should be migrated explicitly.

See the full [Migration guide](doc/migration.md).

## Public API Index

- Composition: `FieldValidator`, `compose`, `aggregate`, `any`, `conditional`,
  `when`, `unless`, `skipWhen`, `transform`, `.and()`, `.or()`,
  `.withMessage()`.
- Messages: `ValidationMessage`, `ValidationMessageResolver`,
  `ValidationMessages`, `Validator.messageResolver`.
- Web/contact: `isEmail`, `isURL`, `isFQDN`, `isPhone`, `isIP`, `isLatLong`.
- Numbers: `isInt`, `isNumeric`, `isDecimal`, `isFloat`, `isPositive`,
  `isNegative`, `isInRange`, `isDivisibleBy`, `isPort`.
- Dates: `isDate`, `isISO8601Date`, `isTime`, `isBefore`, `isAfter`.
- Text: `isAlpha`, `isAlphanumeric`, `isAscii`, `isLength`, `isByteLength`,
  `isLowercase`, `isUppercase`, `startsWith`, `endsWith`, `isSingleLine`,
  `hasWordCount`, `contains`, `matches`, `equals`, `isIn`, `isSlug`.
- Finance/IDs: `isCreditCard`, `isCreditCardCVC`,
  `isCreditCardExpirationDate`, `isIBAN`, `isBIC`, `isISBN`, `isUUID`,
  `isMongoId`, `isMACAddress`.
- Data/security: `isJson`, `isJWT`, `isBase32`, `isBase58`, `isBase64`,
  `isHexadecimal`, `isHexColor`, `isMD5`, `isHash`, `HashAlgorithm`,
  `isMimeType`, `isDataURI`, `isSemVer`, `isStrongPassword`, `isBoolean`,
  `isOctal`.
- Sanitizers: `trim`, `ltrim`, `rtrim`, `escape`, `unescape`, `blacklist`,
  `whitelist`, `stripLow`, `normalizeEmail`, `toBoolean`, `toInt`, `toFloat`,
  `toDate`.
- Forms: `Validator` exposes factories for every validator where form input is
  appropriate.

API reference is generated from source documentation on
[pub.dev](https://pub.dev/documentation/flutter_validators/latest/).

## Contributing

Run the same checks as CI:

```sh
dart format --output=none --set-exit-if-changed lib test tool
dart analyze
dart test
cd example && flutter test
```

Issues and pull requests are welcome at the
[GitHub repository](https://github.com/StacDev/flutter_validators).
Maintainers should follow the [1.3 release checklist](doc/releasing.md).

## License

MIT. See [LICENSE](LICENSE).
