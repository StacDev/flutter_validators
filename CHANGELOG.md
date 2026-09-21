## 1.3.0

* Added `Validator.compose` to run multiple form validators in order.
* Fixed `isURL` to require a real host (`https://`, `http://.`, and `http://foo`
  are rejected; `localhost` and IP hosts remain valid).
* Fixed `isDate` to reject calendar-invalid dates such as `2023-13-01` and
  `2023-02-29`.
* Fixed `isInt` to accept decimal integers only (hex literals like `0x10` are
  rejected).
* The package is now a pure Dart package: the Flutter SDK is no longer required.

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
