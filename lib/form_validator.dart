import 'validators/alpha.dart';
import 'validators/ascii.dart';
import 'validators/base32.dart';
import 'validators/base58.dart';
import 'validators/base64.dart';
import 'validators/boolean.dart';
import 'validators/byte_length.dart';
import 'validators/contains.dart' as contains_fn;
import 'validators/credit_card.dart';
import 'validators/date.dart';
import 'validators/decimal.dart';
import 'validators/email.dart';
import 'validators/equals.dart';
import 'validators/float.dart';
import 'validators/fqdn.dart';
import 'validators/hex_color.dart';
import 'validators/hexadecimal.dart';
import 'validators/in.dart';
import 'validators/int.dart';
import 'validators/ip.dart';
import 'validators/json.dart';
import 'validators/jwt.dart';
import 'validators/lat_long.dart';
import 'validators/length.dart';
import 'validators/lowercase.dart';
import 'validators/mac_address.dart';
import 'validators/matches.dart';
import 'validators/md5.dart';
import 'validators/mongo_id.dart';
import 'validators/numeric.dart';
import 'validators/octal.dart';
import 'validators/phone.dart';
import 'validators/port.dart';
import 'validators/semver.dart';
import 'validators/slug.dart';
import 'validators/strong_password.dart';
import 'validators/uppercase.dart';
import 'validators/url.dart';
import 'validators/uuid.dart';

/// A utility class for Flutter Form validation.
/// Provides methods that return a validator function suitable for `TextFormField`.
///
/// Example:
/// ```dart
/// TextFormField(
///   validator: Validator.compose([
///     Validator.required(errorMessage: 'Email is required'),
///     Validator.email(errorMessage: 'Please enter a valid email'),
///   ]),
/// )
/// ```
class Validator {
  /// Ensures the field is not null or empty.
  static String? Function(String?) required({
    String errorMessage = 'This field is required',
  }) {
    return (String? value) =>
        value == null || value.trim().isEmpty ? errorMessage : null;
  }

  /// Runs [validators] in order and returns the first error, or `null` if all pass.
  ///
  /// Example:
  /// ```dart
  /// validator: Validator.compose([
  ///   Validator.required(errorMessage: 'Email is required'),
  ///   Validator.email(errorMessage: 'Enter a valid email'),
  /// ])
  /// ```
  static String? Function(String?) compose(
    Iterable<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Ensures the string is a valid email.
  static String? Function(String?) email({
    String errorMessage = 'Please enter a valid email address',
  }) {
    return _build(errorMessage, (v) => v.isEmail);
  }

  /// Ensures the string is a valid URL.
  static String? Function(String?) url({
    String errorMessage = 'Please enter a valid URL',
  }) {
    return _build(errorMessage, (v) => v.isURL);
  }

  /// Ensures the string is a valid IP address.
  static String? Function(String?) ip({
    int? version,
    String errorMessage = 'Please enter a valid IP address',
  }) {
    return _build(errorMessage, (v) => isIP(v, version));
  }

  /// Ensures the string is a valid date.
  static String? Function(String?) date({
    String errorMessage = 'Please enter a valid date',
  }) {
    return _build(errorMessage, (v) => v.isDate);
  }

  /// Ensures the string is a valid number.
  static String? Function(String?) numeric({
    String errorMessage = 'Please enter a valid number',
  }) {
    return _build(errorMessage, (v) => v.isNumeric);
  }

  /// Ensures the string is a valid integer.
  static String? Function(String?) integer({
    String errorMessage = 'Please enter a valid whole number',
  }) {
    return _build(errorMessage, (v) => v.isInt);
  }

  /// Ensures the string consists only of letters.
  static String? Function(String?) alpha({
    String errorMessage = 'Only letters are allowed',
  }) {
    return _build(errorMessage, (v) => v.isAlpha);
  }

  /// Ensures the string consists only of letters and numbers.
  static String? Function(String?) alphanumeric({
    String errorMessage = 'Only letters and numbers are allowed',
  }) {
    return _build(errorMessage, (v) => v.isAlphanumeric);
  }

  /// Ensures the string is a valid phone number.
  static String? Function(String?) phone({
    String errorMessage = 'Please enter a valid phone number',
  }) {
    return _build(errorMessage, (v) => v.isPhone);
  }

  /// Ensures the string is a valid credit card.
  static String? Function(String?) creditCard({
    String errorMessage = 'Please enter a valid credit card number',
  }) {
    return _build(errorMessage, (v) => v.isCreditCard);
  }

  /// Ensures the string is valid JSON.
  static String? Function(String?) json({
    String errorMessage = 'Please enter valid JSON',
  }) {
    return _build(errorMessage, (v) => v.isJson);
  }

  /// Ensures the string is a valid UUID.
  static String? Function(String?) uuid({
    String errorMessage = 'Please enter a valid UUID',
  }) {
    return _build(errorMessage, (v) => v.isUUID);
  }

  /// Ensures the string is a valid hex color.
  static String? Function(String?) hexColor({
    String errorMessage = 'Please enter a valid hex color (e.g. #ff0000)',
  }) {
    return _build(errorMessage, (v) => v.isHexColor);
  }

  /// Ensures the string only contains ASCII characters.
  static String? Function(String?) ascii({
    String errorMessage = 'Only ASCII characters are allowed',
  }) {
    return _build(errorMessage, (v) => v.isAscii);
  }

  /// Ensures the string is a valid Base32 encoded string.
  static String? Function(String?) base32({
    String errorMessage = 'Please enter a valid Base32 encoded string',
  }) {
    return _build(errorMessage, (v) => v.isBase32);
  }

  /// Ensures the string is a valid Base58 encoded string.
  static String? Function(String?) base58({
    String errorMessage = 'Please enter a valid Base58 encoded string',
  }) {
    return _build(errorMessage, (v) => v.isBase58);
  }

  /// Ensures the string represents a boolean value.
  static String? Function(String?) boolean({
    String errorMessage = 'Please enter true or false',
  }) {
    return _build(errorMessage, (v) => v.isBoolean);
  }

  /// Ensures the string matches the comparison string exactly.
  static String? Function(String?) equals(
    String comparison, {
    String errorMessage = 'Values do not match',
  }) {
    return _build(errorMessage, (v) => v.equals(comparison));
  }

  /// Ensures the string length falls within the specified range.
  static String? Function(String?) length(
    int min, {
    int? max,
    String errorMessage = 'Length is out of range',
  }) {
    return _build(errorMessage, (v) => v.isLength(min, max));
  }

  /// Ensures the string is entirely lowercase.
  static String? Function(String?) lowercase({
    String errorMessage = 'Must be lowercase',
  }) {
    return _build(errorMessage, (v) => v.isLowercase);
  }

  /// Ensures the string is entirely uppercase.
  static String? Function(String?) uppercase({
    String errorMessage = 'Must be uppercase',
  }) {
    return _build(errorMessage, (v) => v.isUppercase);
  }

  /// Ensures the string is a hexadecimal number.
  static String? Function(String?) hexadecimal({
    String errorMessage = 'Please enter a valid hexadecimal number',
  }) {
    return _build(errorMessage, (v) => v.isHexadecimal);
  }

  /// Ensures the string is an octal number.
  static String? Function(String?) octal({
    String errorMessage = 'Please enter a valid octal number',
  }) {
    return _build(errorMessage, (v) => v.isOctal);
  }

  /// Ensures the string is a valid MongoDB ObjectId.
  static String? Function(String?) mongoId({
    String errorMessage = 'Please enter a valid MongoDB ObjectId',
  }) {
    return _build(errorMessage, (v) => v.isMongoId);
  }

  /// Ensures the string is a valid MD5 hash.
  static String? Function(String?) md5({
    String errorMessage = 'Please enter a valid MD5 hash',
  }) {
    return _build(errorMessage, (v) => v.isMD5);
  }

  /// Ensures the string is a valid port number.
  static String? Function(String?) port({
    String errorMessage = 'Please enter a valid port number',
  }) {
    return _build(errorMessage, (v) => v.isPort);
  }

  /// Ensures the string is a valid Semantic Version.
  static String? Function(String?) semVer({
    String errorMessage = 'Please enter a valid semantic version',
  }) {
    return _build(errorMessage, (v) => v.isSemVer);
  }

  /// Ensures the string is a valid URL slug.
  static String? Function(String?) slug({
    String errorMessage = 'Please enter a valid slug',
  }) {
    return _build(errorMessage, (v) => v.isSlug);
  }

  /// Ensures the string is a valid MAC address.
  static String? Function(String?) macAddress({
    String errorMessage = 'Please enter a valid MAC address',
  }) {
    return _build(errorMessage, (v) => v.isMACAddress);
  }

  /// Ensures the string is a valid `latitude,longitude` pair.
  static String? Function(String?) latLong({
    String errorMessage = 'Please enter valid coordinates',
  }) {
    return _build(errorMessage, (v) => v.isLatLong);
  }

  /// Ensures the string is a valid JSON Web Token.
  static String? Function(String?) jwt({
    String errorMessage = 'Please enter a valid JWT',
  }) {
    return _build(errorMessage, (v) => v.isJWT);
  }

  /// Ensures the string is a fully qualified domain name.
  static String? Function(String?) fqdn({
    String errorMessage = 'Please enter a valid domain name',
  }) {
    return _build(errorMessage, (v) => v.isFQDN);
  }

  /// Ensures the string is Base64 encoded.
  static String? Function(String?) base64({
    bool urlSafe = false,
    String errorMessage = 'Please enter a valid Base64 encoded string',
  }) {
    return _build(errorMessage, (v) => v.isBase64(urlSafe: urlSafe));
  }

  /// Ensures the string represents a decimal number.
  static String? Function(String?) decimal({
    String errorMessage = 'Please enter a valid decimal number',
  }) {
    return _build(errorMessage, (v) => v.isDecimal);
  }

  /// Ensures the string contains the [seed] substring.
  static String? Function(String?) contains(
    String seed, {
    bool ignoreCase = false,
    int minOccurrences = 1,
    String errorMessage = 'Required text is missing',
  }) {
    return _build(
      errorMessage,
      (v) => contains_fn.contains(
        v,
        seed,
        ignoreCase: ignoreCase,
        minOccurrences: minOccurrences,
      ),
    );
  }

  /// Ensures the string matches the given [pattern].
  static String? Function(String?) matches(
    Pattern pattern, {
    String errorMessage = 'Invalid format',
  }) {
    return _build(errorMessage, (v) => v.matches(pattern));
  }

  /// Ensures the string is one of the [allowed] values.
  static String? Function(String?) inList(
    Iterable<String> allowed, {
    String errorMessage = 'Value is not allowed',
  }) {
    return _build(errorMessage, (v) => isIn(v, allowed));
  }

  /// Ensures the string is a finite floating-point number.
  static String? Function(String?) float({
    double? min,
    double? max,
    String errorMessage = 'Please enter a valid number',
  }) {
    return _build(errorMessage, (v) => v.isFloat(min: min, max: max));
  }

  /// Ensures the string's UTF-8 byte length falls within a range.
  static String? Function(String?) byteLength(
    int min, {
    int? max,
    String errorMessage = 'Length is out of range',
  }) {
    return _build(errorMessage, (v) => v.isByteLength(min, max));
  }

  /// Ensures the string is a strong password.
  static String? Function(String?) strongPassword({
    int minLength = 8,
    int minLowercase = 1,
    int minUppercase = 1,
    int minNumbers = 1,
    int minSymbols = 1,
    String errorMessage = 'Password is not strong enough',
  }) {
    return _build(
      errorMessage,
      (v) => v.isStrongPassword(
        minLength: minLength,
        minLowercase: minLowercase,
        minUppercase: minUppercase,
        minNumbers: minNumbers,
        minSymbols: minSymbols,
      ),
    );
  }

  /// Internal helper to construct the validator closure
  static String? Function(String?) _build(
    String errorMessage,
    bool Function(String) test,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null; // Let 'required' handle empty states
      }
      return test(value) ? null : errorMessage;
    };
  }
}
