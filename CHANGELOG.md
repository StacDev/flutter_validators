## 1.3.0

* Added generic `FieldValidator<T>` composition with `compose`, `aggregate`,
  `any`, conditional rules, transforms, and fluent chaining.
* Added dependency-free `ValidationMessage` resolution with runtime locale
  switching and explicit-message precedence.
* Added opt-in strict JWT, Base32, credit-card, URL, email, FQDN, UUID, and
  ISO-8601 calendar validation without changing 1.2 defaults.
* Added numeric range rules; date and time rules; text boundaries and word
  counts; IBAN, BIC, CVC, and card-expiry checks; ISBN-10/13; hash, MIME, and
  data-URI validation.
* Expanded form factories, documentation, migration guides, executable
  examples, adversarial tests, and release-quality CI checks.

## 1.2.0

* Added 21 new validators inspired by validator.js: `isLowercase`, `isUppercase`,
  `isHexadecimal`, `isOctal`, `isDecimal`, `isFloat`, `isMongoId`, `isMD5`,
  `isPort`, `isSemVer`, `isSlug`, `isMACAddress`, `isLatLong`, `isJWT`, `isFQDN`,
  `isBase64`, `isByteLength`, `isStrongPassword`, `isIn`, `matches` and `contains`.
* Added a new sanitizers module (`package:flutter_validators/sanitizers.dart`):
  `trim`, `ltrim`, `rtrim`, `escape`, `unescape`, `blacklist`, `whitelist`,
  `stripLow`, `normalizeEmail`, `toBoolean`, `toInt`, `toFloat` and `toDate`.
* Extended the `Validator` form class with methods for every new validator.
* Added test coverage for all new validators and sanitizers.

## 1.1.0

* Major upgrade! Added 9 new standard validators (URL, UUID, Date, Numeric, Alpha, IP, Hex Color, Credit Card, Length).
* Added `form_validator.dart` for seamless Flutter `TextFormField` integration.
* Added 100% test coverage for all validators.
* Fixed regex edge cases in existing validators.

## 1.0.3
* Added documentation for all validators
* minor changes

## 1.0.2

* Fixed linting issues
* update README.md

## 1.0.0
y
* Added `isPhone` validator
* Added `isJson` validator

## 0.0.4

* Initial release
