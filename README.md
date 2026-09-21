<p align="center">
  <img src="https://raw.githubusercontent.com/StacDev/flutter_validators/main/assets/banner.png" alt="Flutter Validators Banner" />
</p>

<p align="center">
  <h1 align="center">Flutter Validators</h1>
</p>

<p align="center">
  <strong>The most comprehensive string validation package for Dart & Flutter.</strong>
</p>

<p align="center">
  <a href="https://pub.dev/packages/flutter_validators"><img src="https://img.shields.io/pub/v/flutter_validators.svg?logo=dart&color=blue" alt="Pub Version"></a>
  <a href="https://github.com/StacDev/flutter_validators/actions"><img src="https://github.com/StacDev/flutter_validators/actions/workflows/test.yml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>
  <a href="https://github.com/StacDev/flutter_validators/stargazers"><img src="https://img.shields.io/github/stars/StacDev/flutter_validators?style=flat&logo=github&colorB=green&label=stars" alt="Stars"></a>
</p>

<p align="center">
  Inspired by <a href="https://github.com/validatorjs/validator.js">validator.js</a> · 40+ validators & sanitizers · Works with Flutter Forms out of the box
</p>

---

**Flutter Validators** is a pure Dart package with **40+ string validators** and **13 sanitizers** — from emails and URLs to credit cards, UUIDs, JWTs and strong-password checks. Every validator works three ways:

- as a **top-level function** — `isEmail('foo@bar.com')`
- as a **`String` extension** — `'foo@bar.com'.isEmail`
- as a **Flutter form validator** — `Validator.email()` plugs straight into `TextFormField`

Zero runtime dependencies. Fully tested. Works with both Dart and Flutter.

---

## 📚 Table of Contents

- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [🚀 Quick Start](#-quick-start)
- [🧩 Validators](#-validators)
  - [Contact and Web](#contact-and-web)
  - [Numbers](#numbers)
  - [Text and Format](#text-and-format)
  - [Encoding and Data](#encoding-and-data)
  - [Identifiers and Crypto](#identifiers-and-crypto)
  - [Security](#security)
- [🧹 Sanitizers](#-sanitizers)
  - [Trimming](#trimming)
  - [HTML Escaping](#html-escaping)
  - [Character Filtering](#character-filtering)
  - [Type Conversion](#type-conversion)
  - [Email Normalization](#email-normalization)
- [📝 Flutter Form Integration](#-flutter-form-integration)
- [💡 Behavior Notes and FAQ](#-behavior-notes-and-faq)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## ✨ Features

- **40+ validators** covering email, URL, numbers, encodings, identifiers, crypto hashes and more.
- **13 sanitizers** for trimming, HTML escaping, character filtering and type conversion.
- **Three usage styles** — top-level functions, `String` extensions, and Flutter form validators — pick whatever reads best.
- **First-class Flutter form support** via the `Validator` class, which returns `String? Function(String?)` closures with customizable error messages.
- **Pure Dart, zero runtime dependencies** — lightweight and safe to add to any project.
- **Fully tested** — every validator and sanitizer has dedicated test coverage.

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_validators: ^1.3.0
```

Then run:

```sh
dart pub get
```

---

## 🚀 Quick Start

Import the package:

```dart
import 'package:flutter_validators/flutter_validators.dart';
```

**As `String` extensions** — the most concise style:

```dart
'foo@bar.com'.isEmail;           // true
'https://google.com'.isURL;      // true
'4111111111111111'.isCreditCard; // true
'abc123'.isAlphanumeric;         // true
```

**As top-level functions** — handy when the value isn't a literal:

```dart
isEmail('foo@bar.com');     // true
isURL('https://google.com'); // true
isIP('192.168.1.1');        // true
```

**As Flutter form validators** — drop straight into `TextFormField`:

```dart
TextFormField(
  validator: Validator.email(errorMessage: 'Enter a valid email'),
)
```

---

## 🧩 Validators

Every validator is available **both** as a top-level function and as a `String` extension. Parameterized validators accept their options as named/positional arguments.

### Contact and Web

| Validator | Extension | Description |
|---|---|---|
| `isEmail(str)` | `str.isEmail` | Valid email address |
| `isURL(str)` | `str.isURL` | Valid HTTP/HTTPS URL |
| `isFQDN(str)` | `str.isFQDN` | Fully qualified domain name |
| `isPhone(str)` | `str.isPhone` | Phone number (international & US formats) |
| `isLatLong(str)` | `str.isLatLong` | `latitude,longitude` coordinate pair |

```dart
'user@example.com'.isEmail;   // true
'https://dart.dev'.isURL;     // true
'sub.example.co.uk'.isFQDN;   // true
'localhost'.isFQDN;           // false (no TLD)
'(123) 456-7890'.isPhone;     // true
'40.7128,-74.0060'.isLatLong; // true
```

### Numbers

| Validator | Extension | Description |
|---|---|---|
| `isInt(str)` | `str.isInt` | Decimal integer (positive or negative) |
| `isNumeric(str)` | `str.isNumeric` | Number (integer or float) |
| `isFloat(str, {min, max})` | `str.isFloat({min, max})` | Finite float, optionally within a range |
| `isDecimal(str)` | `str.isDecimal` | Decimal number |
| `isHexadecimal(str)` | `str.isHexadecimal` | Hexadecimal number |
| `isOctal(str)` | `str.isOctal` | Octal number |
| `isPort(str)` | `str.isPort` | Port number (0–65535) |

```dart
'42'.isInt;                      // true
'3.14'.isNumeric;                // true
'1.5'.isFloat();                 // true
'5'.isFloat(min: 0, max: 2);     // false (out of range)
'.5'.isDecimal;                  // true
'deadBEEF'.isHexadecimal;        // true
'0o17'.isOctal;                  // true
'8080'.isPort;                   // true
'65536'.isPort;                  // false (out of range)
```

### Text and Format

| Validator | Extension | Description |
|---|---|---|
| `isAlpha(str)` | `str.isAlpha` | Letters only (a–z, A–Z) |
| `isAlphanumeric(str)` | `str.isAlphanumeric` | Letters and numbers only |
| `isAscii(str)` | `str.isAscii` | ASCII characters only |
| `isLowercase(str)` | `str.isLowercase` | Entirely lowercase |
| `isUppercase(str)` | `str.isUppercase` | Entirely uppercase |
| `isLength(str, min, [max])` | `str.isLength(min, [max])` | Length within a range |
| `isByteLength(str, min, [max])` | `str.isByteLength(min, [max])` | UTF-8 byte length within a range |
| `isSlug(str)` | `str.isSlug` | URL slug (`my-blog-post`) |
| `isIn(str, values)` | `str.isIn(values)` | One of an allowed set of values |
| `matches(str, pattern)` | `str.matches(pattern)` | Matches a `Pattern` / `RegExp` |
| `contains(str, seed, {ignoreCase, minOccurrences})` | — | Contains a substring |
| `equals(str, comparison)` | `str.equals(comparison)` | Exact (case-sensitive) string match |

```dart
'Hello'.isAlpha;                       // true
'abc123'.isAlphanumeric;               // true
'héllo'.isAscii;                       // false
'hello'.isLowercase;                   // true
'abc'.isLength(2, 5);                  // true
'é'.isByteLength(2, 2);                // true ('é' is 2 bytes in UTF-8)
'my-blog-post'.isSlug;                 // true
'red'.isIn(['red', 'green', 'blue']);  // true
'abc123'.matches(RegExp(r'\d+'));      // true
'foo'.equals('foo');                   // true

// `contains` is a top-level function only (see Behavior Notes)
contains('hello world', 'world');                  // true
contains('Hello World', 'world', ignoreCase: true); // true
contains('a-a-a', 'a', minOccurrences: 3);          // true
```

### Encoding and Data

| Validator | Extension | Description |
|---|---|---|
| `isBase32(str)` | `str.isBase32` | Base32 encoded |
| `isBase58(str)` | `str.isBase58` | Base58 encoded |
| `isBase64(str, {urlSafe})` | `str.isBase64({urlSafe})` | Base64 encoded (standard or URL-safe) |
| `isJson(str)` | `str.isJson` | Valid JSON |
| `isHexColor(str)` | `str.isHexColor` | Hex color code (`#fff`, `ff0000`) |
| `isBoolean(str)` | `str.isBoolean` | Boolean string (`true`/`false`/`1`/`0`) |
| `isDate(str)` | `str.isDate` | Parseable date string |

```dart
'JBSWY3DP'.isBase32;             // true
'aGVsbG8='.isBase64();           // true
'a-b_cdef'.isBase64(urlSafe: true); // true
'{"name":"Dart"}'.isJson;        // true
'#ff0000'.isHexColor;            // true
'true'.isBoolean;                // true
'2024-01-15'.isDate;             // true
```

### Identifiers and Crypto

| Validator | Extension | Description |
|---|---|---|
| `isUUID(str)` | `str.isUUID` | UUID (v1, v3, v4, v5) |
| `isMongoId(str)` | `str.isMongoId` | MongoDB ObjectId (24-char hex) |
| `isMD5(str)` | `str.isMD5` | MD5 hash |
| `isJWT(str)` | `str.isJWT` | JSON Web Token |
| `isCreditCard(str)` | `str.isCreditCard` | Credit card number (Luhn algorithm) |
| `isMACAddress(str)` | `str.isMACAddress` | MAC address (EUI-48 / EUI-64) |
| `isSemVer(str)` | `str.isSemVer` | Semantic version |

```dart
'550e8400-e29b-41d4-a716-446655440000'.isUUID; // true
'507f1f77bcf86cd799439011'.isMongoId;          // true
'd41d8cd98f00b204e9800998ecf8427e'.isMD5;      // true
'eyJhbGci.eyJzdWIi.SflKxwRJ'.isJWT;            // true
'4111111111111111'.isCreditCard;               // true
'00:1B:44:11:3A:B7'.isMACAddress;              // true
'2.1.0-alpha.1'.isSemVer;                       // true
```

### Security

| Validator | Extension | Description |
|---|---|---|
| `isStrongPassword(str, {...})` | `str.isStrongPassword({...})` | Password meets configurable strength rules |

`isStrongPassword` accepts five options, all with sensible defaults:

| Option | Default | Meaning |
|---|---|---|
| `minLength` | `8` | Minimum total length |
| `minLowercase` | `1` | Minimum lowercase letters |
| `minUppercase` | `1` | Minimum uppercase letters |
| `minNumbers` | `1` | Minimum digits |
| `minSymbols` | `1` | Minimum non-alphanumeric symbols |

```dart
'Abcd1234!'.isStrongPassword();  // true
'weak'.isStrongPassword();       // false

// Relax the rules — e.g. allow passphrases with no symbols or digits
'abcdefghij'.isStrongPassword(
  minUppercase: 0,
  minNumbers: 0,
  minSymbols: 0,
); // true
```

---

## 🧹 Sanitizers

Sanitizers transform or coerce strings. Like validators, they're available as both top-level functions and `String` extensions. Import them via the main library or directly:

```dart
import 'package:flutter_validators/flutter_validators.dart';
// or, sanitizers only:
import 'package:flutter_validators/sanitizers.dart';
```

### Trimming

| Sanitizer | Extension | Description |
|---|---|---|
| `trim(str, [chars])` | `str.trimChars(chars)` | Trim whitespace/chars from both ends |
| `ltrim(str, [chars])` | `str.ltrimChars(chars)` | Trim from the start |
| `rtrim(str, [chars])` | `str.rtrimChars(chars)` | Trim from the end |

```dart
trim('  hello  ');        // 'hello'
trim('xxhelloxx', 'x');   // 'hello'
ltrim('00042', '0');      // '42'
rtrim('hello!!!', '!');   // 'hello'
```

### HTML Escaping

| Sanitizer | Extension | Description |
|---|---|---|
| `escape(str)` | `str.escape()` | Escape HTML-unsafe characters |
| `unescape(str)` | `str.unescape()` | Reverse of `escape` |

```dart
escape('<script>alert(1)</script>');
// '&lt;script&gt;alert(1)&lt;&#x2F;script&gt;'

unescape('&lt;b&gt;hi&lt;&#x2F;b&gt;'); // '<b>hi</b>'
```

### Character Filtering

| Sanitizer | Extension | Description |
|---|---|---|
| `blacklist(str, chars)` | `str.blacklist(chars)` | Remove the listed characters |
| `whitelist(str, chars)` | `str.whitelist(chars)` | Keep only the listed characters |
| `stripLow(str, {keepNewLines})` | `str.stripLow({keepNewLines})` | Remove ASCII control characters |

```dart
blacklist('hello world', 'lo');              // 'he wrd'
whitelist('a1b2c3', '0123456789');           // '123'
stripLow('line1\nline2');                    // 'line1line2'
stripLow('line1\nline2', keepNewLines: true); // 'line1\nline2'
```

### Type Conversion

| Sanitizer | Extension | Returns | Description |
|---|---|---|---|
| `toBoolean(str, {strict})` | `str.toBoolean({strict})` | `bool` | Convert to a boolean |
| `toInt(str, {radix})` | `str.toInt({radix})` | `int?` | Parse to an integer |
| `toFloat(str)` | `str.toFloat()` | `double?` | Parse to a double |
| `toDate(str)` | `str.toDate()` | `DateTime?` | Parse to a `DateTime` |

```dart
toBoolean('true');             // true
toBoolean('0');                // false
toBoolean('yes', strict: true); // false (strict: only '1'/'true' are true)
toInt('42');                   // 42
toInt('ff', radix: 16);        // 255
toInt('abc');                  // null
toFloat('3.14');               // 3.14
toDate('2024-01-15');          // DateTime(2024, 1, 15)
```

### Email Normalization

| Sanitizer | Extension | Returns | Description |
|---|---|---|---|
| `normalizeEmail(str)` | `str.normalizeEmail()` | `String?` | Canonicalize an email address |

```dart
normalizeEmail('Test.User+promo@GMAIL.com'); // 'testuser@gmail.com'
normalizeEmail('User@Example.COM');          // 'User@example.com'
normalizeEmail('not-an-email');              // null
```

---

## 📝 Flutter Form Integration

The `Validator` class returns `String? Function(String?)` closures — exactly the type `TextFormField.validator` expects. A closure returns `null` when the value is valid, or the error message when it isn't. Every method accepts a custom `errorMessage`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_validators/flutter_validators.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Combine `required` with `email` to enforce a non-empty, valid email.
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validator.compose([
              Validator.required(errorMessage: 'Email is required'),
              Validator.email(errorMessage: 'Enter a valid email'),
            ]),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Website'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validator.url(),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validator.strongPassword(
              errorMessage: 'Use 8+ chars with upper, lower, number & symbol',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form is valid!')),
                );
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
```

A complete, runnable app is in the [`example/`](example/) directory.

### Validator API Reference

Every method on the `Validator` class returns `String? Function(String?)`:

```dart
Validator.compose(Iterable<String? Function(String?)> validators)
Validator.required({String errorMessage})
Validator.email({String errorMessage})
Validator.url({String errorMessage})
Validator.ip({int? version, String errorMessage})
Validator.fqdn({String errorMessage})
Validator.phone({String errorMessage})
Validator.latLong({String errorMessage})
Validator.date({String errorMessage})
Validator.numeric({String errorMessage})
Validator.integer({String errorMessage})
Validator.float({double? min, double? max, String errorMessage})
Validator.decimal({String errorMessage})
Validator.hexadecimal({String errorMessage})
Validator.octal({String errorMessage})
Validator.port({String errorMessage})
Validator.alpha({String errorMessage})
Validator.alphanumeric({String errorMessage})
Validator.ascii({String errorMessage})
Validator.lowercase({String errorMessage})
Validator.uppercase({String errorMessage})
Validator.slug({String errorMessage})
Validator.length(int min, {int? max, String errorMessage})
Validator.byteLength(int min, {int? max, String errorMessage})
Validator.contains(String seed, {bool ignoreCase, int minOccurrences, String errorMessage})
Validator.matches(Pattern pattern, {String errorMessage})
Validator.inList(Iterable<String> allowed, {String errorMessage})
Validator.equals(String comparison, {String errorMessage})
Validator.base32({String errorMessage})
Validator.base58({String errorMessage})
Validator.base64({bool urlSafe, String errorMessage})
Validator.json({String errorMessage})
Validator.hexColor({String errorMessage})
Validator.boolean({String errorMessage})
Validator.uuid({String errorMessage})
Validator.mongoId({String errorMessage})
Validator.md5({String errorMessage})
Validator.jwt({String errorMessage})
Validator.creditCard({String errorMessage})
Validator.macAddress({String errorMessage})
Validator.semVer({String errorMessage})
Validator.strongPassword({int minLength, int minLowercase, int minUppercase, int minNumbers, int minSymbols, String errorMessage})
```

---

## 💡 Behavior Notes and FAQ

**`Validator` methods treat `null` and empty strings as valid.** This is intentional — it lets you compose validators freely. Individual validators still skip empty values; to make a field mandatory, pair them with `Validator.required()` using `Validator.compose`:

```dart
validator: Validator.compose([
  Validator.required(),
  Validator.email(),
])
```

**`contains` is a top-level function only.** Dart's `String` already has a built-in `.contains()` method, so the package does not add a conflicting extension. Use `contains(str, seed)` instead of `str.contains(...)` when you need the case-insensitivity or `minOccurrences` options.

**Trimming extensions are named `trimChars` / `ltrimChars` / `rtrimChars`.** Dart's `String` already provides `.trim()`, `.trimLeft()` and `.trimRight()` for whitespace, so the custom-character variants use distinct names to avoid collisions. The top-level functions keep the plain `trim` / `ltrim` / `rtrim` names.

**`isURL` accepts only `http` and `https` schemes** and requires a real host. Other schemes such as `ftp://` are rejected. The host must be `localhost`, an IP address, or a name that contains a dot — so `https://` and `http://foo` fail, while `http://localhost` and `https://example.com` pass.

**`isDate` requires a real calendar date.** ISO-8601 strings whose `YYYY-MM-DD` prefix is not a valid calendar date (for example `2023-13-01` or `2023-02-29`) are rejected.

**`isInt` accepts decimal integers only.** Hex literals such as `0x10` are rejected. Leading zeros and surrounding whitespace are still allowed.

**`isBase64` has a `urlSafe` option.** By default it validates the standard Base64 alphabet (with padding); pass `urlSafe: true` to validate the URL- and filename-safe alphabet instead.

**`isBoolean` accepts `'true'`, `'false'`, `'1'` and `'0'`.** Any other value is not a boolean string.

**`isFloat` rejects non-finite values.** `'Infinity'` and `'NaN'` return `false`, even though Dart's `double.tryParse` can parse them.

**`normalizeEmail` applies Gmail-specific rules.** For `gmail.com` / `googlemail.com` addresses it lowercases the local part, removes dots, and strips any `+tag` suffix. For other providers it only lowercases the domain. It returns `null` if the input isn't a valid email.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check the [issues page](https://github.com/StacDev/flutter_validators/issues).

---

## 📄 License

This project is [MIT](LICENSE) licensed.
