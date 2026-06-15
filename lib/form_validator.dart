import 'package:flutter_validators/field_validator.dart' as fields;
import 'package:flutter_validators/flutter_validators.dart' as rules;
import 'package:flutter_validators/validation_message.dart';

/// Factories and composition helpers for Flutter form validation.
///
/// Every non-required string validator treats `null` and the empty string as
/// valid so optional fields compose naturally with [required].
abstract final class Validator {
  /// The active dependency-free validation message resolver.
  static ValidationMessageResolver? get messageResolver {
    return ValidationMessages.resolver;
  }

  static set messageResolver(ValidationMessageResolver? value) {
    ValidationMessages.resolver = value;
  }

  /// Restores the built-in English messages.
  static void resetMessageResolver() => ValidationMessages.reset();

  /// Runs validators in order and returns the first error.
  static fields.FieldValidator<T> compose<T>(
    Iterable<fields.FieldValidator<T>> validators,
  ) {
    return fields.compose(validators);
  }

  /// Runs every validator and joins all errors.
  static fields.FieldValidator<T> aggregate<T>(
    Iterable<fields.FieldValidator<T>> validators, {
    String separator = '\n',
  }) {
    return fields.aggregate(validators, separator: separator);
  }

  /// Succeeds when at least one validator succeeds.
  static fields.FieldValidator<T> any<T>(
    Iterable<fields.FieldValidator<T>> validators, {
    String? errorMessage,
  }) {
    final rules = List<fields.FieldValidator<T>>.unmodifiable(validators);
    if (rules.isEmpty) {
      throw ArgumentError.value(validators, 'validators', 'Must not be empty');
    }
    return (value) {
      for (final validator in rules) {
        if (validator(value) == null) return null;
      }
      return _resolve(
        'any',
        'Value does not match any allowed format',
        errorMessage,
      );
    };
  }

  /// Runs [validator] when [predicate] is true.
  static fields.FieldValidator<T> conditional<T>(
    bool Function(T? value) predicate,
    fields.FieldValidator<T> validator,
  ) {
    return fields.conditional(predicate, validator);
  }

  /// Alias for [conditional].
  static fields.FieldValidator<T> when<T>(
    bool Function(T? value) predicate,
    fields.FieldValidator<T> validator,
  ) {
    return fields.when(predicate, validator);
  }

  /// Runs [validator] unless [predicate] is true.
  static fields.FieldValidator<T> unless<T>(
    bool Function(T? value) predicate,
    fields.FieldValidator<T> validator,
  ) {
    return fields.unless(predicate, validator);
  }

  /// Skips [validator] when [predicate] is true.
  static fields.FieldValidator<T> skipWhen<T>(
    bool Function(T? value) predicate,
    fields.FieldValidator<T> validator,
  ) {
    return fields.skipWhen(predicate, validator);
  }

  /// Transforms values before validating them.
  static fields.FieldValidator<T> transform<T, R>(
    R? Function(T? value) transformer,
    fields.FieldValidator<R> validator,
  ) {
    return fields.transform(transformer, validator);
  }

  /// Ensures the field is not null or blank.
  static fields.FieldValidator<String> required({String? errorMessage}) {
    return (value) =>
        value == null || value.trim().isEmpty
            ? _resolve('required', 'This field is required', errorMessage)
            : null;
  }

  /// Ensures the string is a valid email.
  static fields.FieldValidator<String> email({
    bool allowUnicode = false,
    bool requireTld = true,
    bool allowIpDomain = true,
    int maxLength = 254,
    String? errorMessage,
  }) {
    return _build(
      'email',
      'Please enter a valid email address',
      errorMessage,
      (value) => rules.isEmail(
        value,
        allowUnicode: allowUnicode,
        requireTld: requireTld,
        allowIpDomain: allowIpDomain,
        maxLength: maxLength,
      ),
      parameters: {'allowUnicode': allowUnicode, 'requireTld': requireTld},
    );
  }

  /// Ensures the string is a valid URL.
  static fields.FieldValidator<String> url({
    Iterable<String> protocols = const ['http', 'https'],
    bool requireTld = false,
    bool allowLocalhost = true,
    bool allowUnderscores = false,
    int maxLength = 2083,
    String? errorMessage,
  }) {
    return _build(
      'url',
      'Please enter a valid URL',
      errorMessage,
      (value) => rules.isURL(
        value,
        protocols: protocols,
        requireTld: requireTld,
        allowLocalhost: allowLocalhost,
        allowUnderscores: allowUnderscores,
        maxLength: maxLength,
      ),
    );
  }

  /// Ensures the string is a valid IP address.
  static fields.FieldValidator<String> ip({
    int? version,
    String? errorMessage,
  }) {
    return _build(
      'ip',
      'Please enter a valid IP address',
      errorMessage,
      (value) => rules.isIP(value, version),
      parameters: {'version': version},
    );
  }

  /// Ensures the string is parseable using Dart's permissive date parser.
  static fields.FieldValidator<String> date({String? errorMessage}) {
    return _build(
      'date',
      'Please enter a valid date',
      errorMessage,
      rules.isDate,
    );
  }

  /// Ensures the string is a real `YYYY-MM-DD` calendar date.
  static fields.FieldValidator<String> iso8601Date({String? errorMessage}) {
    return _build(
      'iso8601Date',
      'Please enter a valid date in YYYY-MM-DD format',
      errorMessage,
      rules.isISO8601Date,
    );
  }

  /// Ensures the string is a 24-hour time.
  static fields.FieldValidator<String> time({
    bool allowSeconds = true,
    String? errorMessage,
  }) {
    return _build(
      'time',
      'Please enter a valid time',
      errorMessage,
      (value) => rules.isTime(value, allowSeconds: allowSeconds),
      parameters: {'allowSeconds': allowSeconds},
    );
  }

  /// Ensures the date is before [reference].
  static fields.FieldValidator<String> before(
    DateTime reference, {
    String? errorMessage,
  }) {
    return _build(
      'before',
      'Date must be before the allowed limit',
      errorMessage,
      (value) => rules.isBefore(value, reference),
      parameters: {'reference': reference},
    );
  }

  /// Ensures the date is after [reference].
  static fields.FieldValidator<String> after(
    DateTime reference, {
    String? errorMessage,
  }) {
    return _build(
      'after',
      'Date must be after the allowed limit',
      errorMessage,
      (value) => rules.isAfter(value, reference),
      parameters: {'reference': reference},
    );
  }

  /// Ensures the string is numeric.
  static fields.FieldValidator<String> numeric({String? errorMessage}) {
    return _build(
      'numeric',
      'Please enter a valid number',
      errorMessage,
      rules.isNumeric,
    );
  }

  /// Ensures the string is an integer.
  static fields.FieldValidator<String> integer({String? errorMessage}) {
    return _build(
      'integer',
      'Please enter a valid whole number',
      errorMessage,
      rules.isInt,
    );
  }

  /// Ensures the number is positive.
  static fields.FieldValidator<String> positive({String? errorMessage}) {
    return _build(
      'positive',
      'Please enter a number greater than zero',
      errorMessage,
      rules.isPositive,
    );
  }

  /// Ensures the number is negative.
  static fields.FieldValidator<String> negative({String? errorMessage}) {
    return _build(
      'negative',
      'Please enter a number less than zero',
      errorMessage,
      rules.isNegative,
    );
  }

  /// Ensures the number is in range.
  static fields.FieldValidator<String> range(
    num min,
    num max, {
    bool inclusive = true,
    String? errorMessage,
  }) {
    return _build(
      'range',
      'Please enter a number between $min and $max',
      errorMessage,
      (value) => rules.isInRange(value, min, max, inclusive: inclusive),
      parameters: {'min': min, 'max': max, 'inclusive': inclusive},
    );
  }

  /// Ensures the number is divisible by [divisor].
  static fields.FieldValidator<String> divisibleBy(
    num divisor, {
    String? errorMessage,
  }) {
    return _build(
      'divisibleBy',
      'Please enter a number divisible by $divisor',
      errorMessage,
      (value) => rules.isDivisibleBy(value, divisor),
      parameters: {'divisor': divisor},
    );
  }

  /// Ensures the string consists only of letters.
  static fields.FieldValidator<String> alpha({String? errorMessage}) {
    return _build(
      'alpha',
      'Only letters are allowed',
      errorMessage,
      rules.isAlpha,
    );
  }

  /// Ensures the string consists only of letters and numbers.
  static fields.FieldValidator<String> alphanumeric({String? errorMessage}) {
    return _build(
      'alphanumeric',
      'Only letters and numbers are allowed',
      errorMessage,
      rules.isAlphanumeric,
    );
  }

  /// Ensures the string is a valid phone number.
  static fields.FieldValidator<String> phone({String? errorMessage}) {
    return _build(
      'phone',
      'Please enter a valid phone number',
      errorMessage,
      rules.isPhone,
    );
  }

  /// Ensures the string passes credit-card checks.
  static fields.FieldValidator<String> creditCard({
    bool strict = false,
    String? errorMessage,
  }) {
    return _build(
      'creditCard',
      'Please enter a valid credit card number',
      errorMessage,
      (value) => rules.isCreditCard(value, strict: strict),
      parameters: {'strict': strict},
    );
  }

  /// Ensures the string is a valid CVC.
  static fields.FieldValidator<String> cardCVC({
    int minLength = 3,
    int maxLength = 4,
    String? errorMessage,
  }) {
    return _build(
      'cardCVC',
      'Please enter a valid card security code',
      errorMessage,
      (value) => rules.isCreditCardCVC(
        value,
        minLength: minLength,
        maxLength: maxLength,
      ),
      parameters: {'minLength': minLength, 'maxLength': maxLength},
    );
  }

  /// Ensures the string is a valid card expiry.
  static fields.FieldValidator<String> cardExpiration({
    bool requireFuture = true,
    DateTime? referenceDate,
    String? errorMessage,
  }) {
    return _build(
      'cardExpiration',
      'Please enter a valid card expiration date',
      errorMessage,
      (value) => rules.isCreditCardExpirationDate(
        value,
        requireFuture: requireFuture,
        referenceDate: referenceDate,
      ),
    );
  }

  /// Ensures the string is a valid IBAN.
  static fields.FieldValidator<String> iban({String? errorMessage}) {
    return _build(
      'iban',
      'Please enter a valid IBAN',
      errorMessage,
      rules.isIBAN,
    );
  }

  /// Ensures the string is a valid BIC.
  static fields.FieldValidator<String> bic({String? errorMessage}) {
    return _build('bic', 'Please enter a valid BIC', errorMessage, rules.isBIC);
  }

  /// Ensures the string is valid JSON.
  static fields.FieldValidator<String> json({String? errorMessage}) {
    return _build(
      'json',
      'Please enter valid JSON',
      errorMessage,
      rules.isJson,
    );
  }

  /// Ensures the string is a valid UUID.
  static fields.FieldValidator<String> uuid({
    int? version,
    String? errorMessage,
  }) {
    return _build(
      'uuid',
      'Please enter a valid UUID',
      errorMessage,
      (value) => rules.isUUID(value, version),
      parameters: {'version': version},
    );
  }

  /// Ensures the string is a valid ISBN.
  static fields.FieldValidator<String> isbn({
    int? version,
    String? errorMessage,
  }) {
    return _build(
      'isbn',
      'Please enter a valid ISBN',
      errorMessage,
      (value) => rules.isISBN(value, version: version),
      parameters: {'version': version},
    );
  }

  /// Ensures the string is a valid hex color.
  static fields.FieldValidator<String> hexColor({String? errorMessage}) {
    return _build(
      'hexColor',
      'Please enter a valid hex color (e.g. #ff0000)',
      errorMessage,
      rules.isHexColor,
    );
  }

  /// Ensures the string only contains ASCII.
  static fields.FieldValidator<String> ascii({String? errorMessage}) {
    return _build(
      'ascii',
      'Only ASCII characters are allowed',
      errorMessage,
      rules.isAscii,
    );
  }

  /// Ensures the string uses Base32 encoding.
  static fields.FieldValidator<String> base32({
    bool strict = false,
    String? errorMessage,
  }) {
    return _build(
      'base32',
      'Please enter a valid Base32 encoded string',
      errorMessage,
      (value) => rules.isBase32(value, strict: strict),
      parameters: {'strict': strict},
    );
  }

  /// Ensures the string uses Base58 encoding.
  static fields.FieldValidator<String> base58({String? errorMessage}) {
    return _build(
      'base58',
      'Please enter a valid Base58 encoded string',
      errorMessage,
      rules.isBase58,
    );
  }

  /// Ensures the string represents a boolean.
  static fields.FieldValidator<String> boolean({String? errorMessage}) {
    return _build(
      'boolean',
      'Please enter true or false',
      errorMessage,
      rules.isBoolean,
    );
  }

  /// Ensures an exact match.
  static fields.FieldValidator<String> equals(
    String comparison, {
    String? errorMessage,
  }) {
    return _build(
      'equals',
      'Values do not match',
      errorMessage,
      (value) => rules.equals(value, comparison),
      parameters: {'comparison': comparison},
    );
  }

  /// Ensures the character length is in range.
  static fields.FieldValidator<String> length(
    int min, {
    int? max,
    String? errorMessage,
  }) {
    return _build(
      'length',
      'Length is out of range',
      errorMessage,
      (value) => rules.isLength(value, min, max),
      parameters: {'min': min, 'max': max},
    );
  }

  /// Ensures the string starts with [prefix].
  static fields.FieldValidator<String> startsWith(
    String prefix, {
    bool ignoreCase = false,
    String? errorMessage,
  }) {
    return _build(
      'startsWith',
      'Value must start with $prefix',
      errorMessage,
      (value) => rules.startsWith(value, prefix, ignoreCase: ignoreCase),
      parameters: {'prefix': prefix, 'ignoreCase': ignoreCase},
    );
  }

  /// Ensures the string ends with [suffix].
  static fields.FieldValidator<String> endsWith(
    String suffix, {
    bool ignoreCase = false,
    String? errorMessage,
  }) {
    return _build(
      'endsWith',
      'Value must end with $suffix',
      errorMessage,
      (value) => rules.endsWith(value, suffix, ignoreCase: ignoreCase),
      parameters: {'suffix': suffix, 'ignoreCase': ignoreCase},
    );
  }

  /// Ensures the string contains no line breaks.
  static fields.FieldValidator<String> singleLine({String? errorMessage}) {
    return _build(
      'singleLine',
      'Please enter a single line',
      errorMessage,
      rules.isSingleLine,
    );
  }

  /// Ensures the word count is in range.
  static fields.FieldValidator<String> wordCount({
    int min = 0,
    int? max,
    String? errorMessage,
  }) {
    return _build(
      'wordCount',
      'Word count is out of range',
      errorMessage,
      (value) => rules.hasWordCount(value, min: min, max: max),
      parameters: {'min': min, 'max': max},
    );
  }

  /// Ensures the string is lowercase.
  static fields.FieldValidator<String> lowercase({String? errorMessage}) {
    return _build(
      'lowercase',
      'Must be lowercase',
      errorMessage,
      rules.isLowercase,
    );
  }

  /// Ensures the string is uppercase.
  static fields.FieldValidator<String> uppercase({String? errorMessage}) {
    return _build(
      'uppercase',
      'Must be uppercase',
      errorMessage,
      rules.isUppercase,
    );
  }

  /// Ensures the string is hexadecimal.
  static fields.FieldValidator<String> hexadecimal({String? errorMessage}) {
    return _build(
      'hexadecimal',
      'Please enter a valid hexadecimal number',
      errorMessage,
      rules.isHexadecimal,
    );
  }

  /// Ensures the string is octal.
  static fields.FieldValidator<String> octal({String? errorMessage}) {
    return _build(
      'octal',
      'Please enter a valid octal number',
      errorMessage,
      rules.isOctal,
    );
  }

  /// Ensures the string is a MongoDB ObjectId.
  static fields.FieldValidator<String> mongoId({String? errorMessage}) {
    return _build(
      'mongoId',
      'Please enter a valid MongoDB ObjectId',
      errorMessage,
      rules.isMongoId,
    );
  }

  /// Ensures the string is an MD5 hash.
  static fields.FieldValidator<String> md5({String? errorMessage}) {
    return _build(
      'md5',
      'Please enter a valid MD5 hash',
      errorMessage,
      rules.isMD5,
    );
  }

  /// Ensures the string is a digest for [algorithm].
  static fields.FieldValidator<String> hash(
    rules.HashAlgorithm algorithm, {
    String? errorMessage,
  }) {
    return _build(
      'hash',
      'Please enter a valid ${algorithm.name.toUpperCase()} hash',
      errorMessage,
      (value) => rules.isHash(value, algorithm),
      parameters: {'algorithm': algorithm.name},
    );
  }

  /// Ensures the string is a MIME type.
  static fields.FieldValidator<String> mimeType({String? errorMessage}) {
    return _build(
      'mimeType',
      'Please enter a valid MIME type',
      errorMessage,
      rules.isMimeType,
    );
  }

  /// Ensures the string is a data URI.
  static fields.FieldValidator<String> dataURI({String? errorMessage}) {
    return _build(
      'dataURI',
      'Please enter a valid data URI',
      errorMessage,
      rules.isDataURI,
    );
  }

  /// Ensures the string is a port.
  static fields.FieldValidator<String> port({String? errorMessage}) {
    return _build(
      'port',
      'Please enter a valid port number',
      errorMessage,
      rules.isPort,
    );
  }

  /// Ensures the string is a semantic version.
  static fields.FieldValidator<String> semVer({String? errorMessage}) {
    return _build(
      'semVer',
      'Please enter a valid semantic version',
      errorMessage,
      rules.isSemVer,
    );
  }

  /// Ensures the string is a slug.
  static fields.FieldValidator<String> slug({String? errorMessage}) {
    return _build(
      'slug',
      'Please enter a valid slug',
      errorMessage,
      rules.isSlug,
    );
  }

  /// Ensures the string is a MAC address.
  static fields.FieldValidator<String> macAddress({String? errorMessage}) {
    return _build(
      'macAddress',
      'Please enter a valid MAC address',
      errorMessage,
      rules.isMACAddress,
    );
  }

  /// Ensures the string is a latitude/longitude pair.
  static fields.FieldValidator<String> latLong({String? errorMessage}) {
    return _build(
      'latLong',
      'Please enter valid coordinates',
      errorMessage,
      rules.isLatLong,
    );
  }

  /// Ensures the string has JWT structure.
  static fields.FieldValidator<String> jwt({
    bool strict = false,
    bool allowUnsigned = true,
    String? errorMessage,
  }) {
    return _build(
      'jwt',
      'Please enter a valid JWT',
      errorMessage,
      (value) =>
          rules.isJWT(value, strict: strict, allowUnsigned: allowUnsigned),
      parameters: {'strict': strict, 'allowUnsigned': allowUnsigned},
    );
  }

  /// Ensures the string is a fully qualified domain name.
  static fields.FieldValidator<String> fqdn({
    bool requireTld = true,
    bool allowTrailingDot = true,
    bool allowUnderscores = false,
    bool strict = false,
    String? errorMessage,
  }) {
    return _build(
      'fqdn',
      'Please enter a valid domain name',
      errorMessage,
      (value) => rules.isFQDN(
        value,
        requireTld: requireTld,
        allowTrailingDot: allowTrailingDot,
        allowUnderscores: allowUnderscores,
        strict: strict,
      ),
    );
  }

  /// Ensures the string is Base64.
  static fields.FieldValidator<String> base64({
    bool urlSafe = false,
    String? errorMessage,
  }) {
    return _build(
      'base64',
      'Please enter a valid Base64 encoded string',
      errorMessage,
      (value) => rules.isBase64(value, urlSafe: urlSafe),
      parameters: {'urlSafe': urlSafe},
    );
  }

  /// Ensures the string is decimal.
  static fields.FieldValidator<String> decimal({String? errorMessage}) {
    return _build(
      'decimal',
      'Please enter a valid decimal number',
      errorMessage,
      rules.isDecimal,
    );
  }

  /// Ensures the string contains [seed].
  static fields.FieldValidator<String> contains(
    String seed, {
    bool ignoreCase = false,
    int minOccurrences = 1,
    String? errorMessage,
  }) {
    return _build(
      'contains',
      'Required text is missing',
      errorMessage,
      (value) => rules.contains(
        value,
        seed,
        ignoreCase: ignoreCase,
        minOccurrences: minOccurrences,
      ),
      parameters: {
        'seed': seed,
        'ignoreCase': ignoreCase,
        'minOccurrences': minOccurrences,
      },
    );
  }

  /// Ensures the string matches [pattern].
  static fields.FieldValidator<String> matches(
    Pattern pattern, {
    String? errorMessage,
  }) {
    return _build(
      'matches',
      'Invalid format',
      errorMessage,
      (value) => rules.matches(value, pattern),
    );
  }

  /// Ensures the string is one of [allowed].
  static fields.FieldValidator<String> inList(
    Iterable<String> allowed, {
    String? errorMessage,
  }) {
    return _build(
      'inList',
      'Value is not allowed',
      errorMessage,
      (value) => rules.isIn(value, allowed),
    );
  }

  /// Ensures the string is a finite floating-point number.
  static fields.FieldValidator<String> float({
    double? min,
    double? max,
    String? errorMessage,
  }) {
    return _build(
      'float',
      'Please enter a valid number',
      errorMessage,
      (value) => rules.isFloat(value, min: min, max: max),
      parameters: {'min': min, 'max': max},
    );
  }

  /// Ensures UTF-8 byte length is in range.
  static fields.FieldValidator<String> byteLength(
    int min, {
    int? max,
    String? errorMessage,
  }) {
    return _build(
      'byteLength',
      'Length is out of range',
      errorMessage,
      (value) => rules.isByteLength(value, min, max),
      parameters: {'min': min, 'max': max},
    );
  }

  /// Ensures the password meets configurable strength rules.
  static fields.FieldValidator<String> strongPassword({
    int minLength = 8,
    int minLowercase = 1,
    int minUppercase = 1,
    int minNumbers = 1,
    int minSymbols = 1,
    String? errorMessage,
  }) {
    return _build(
      'strongPassword',
      'Password is not strong enough',
      errorMessage,
      (value) => rules.isStrongPassword(
        value,
        minLength: minLength,
        minLowercase: minLowercase,
        minUppercase: minUppercase,
        minNumbers: minNumbers,
        minSymbols: minSymbols,
      ),
      parameters: {
        'minLength': minLength,
        'minLowercase': minLowercase,
        'minUppercase': minUppercase,
        'minNumbers': minNumbers,
        'minSymbols': minSymbols,
      },
    );
  }

  static fields.FieldValidator<String> _build(
    String key,
    String fallback,
    String? errorMessage,
    bool Function(String value) test, {
    Map<String, Object?> parameters = const {},
  }) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      return test(value)
          ? null
          : _resolve(key, fallback, errorMessage, parameters: parameters);
    };
  }

  static String _resolve(
    String key,
    String fallback,
    String? errorMessage, {
    Map<String, Object?> parameters = const {},
  }) {
    return ValidationMessages.resolve(
      ValidationMessage(key, fallback, parameters: parameters),
      errorMessage: errorMessage,
    );
  }
}
