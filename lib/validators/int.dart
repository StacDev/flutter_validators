/// Checks if the string represents a decimal integer.
///
/// Accepts an optional sign, leading zeros, and surrounding whitespace.
/// Hex literals such as `0x10` are rejected.
///
/// Returns `true` if the string is a decimal integer, otherwise returns `false`.
///
/// Example:
/// ```dart
/// isInt('123'); // true
/// isInt('-123'); // true
/// isInt('01'); // true
/// isInt('0x10'); // false
/// isInt('12.34'); // false
/// isInt('abc'); // false
/// ```
bool isInt(String str) => _isInt(str);

/// Extension providing integer validation methods on [String].
extension IntX on String {
  /// Checks if the string represents a decimal integer.
  ///
  /// Accepts an optional sign, leading zeros, and surrounding whitespace.
  /// Hex literals such as `0x10` are rejected.
  ///
  /// Returns `true` if the string is a decimal integer, otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// '123'.isInt; // true
  /// '-123'.isInt; // true
  /// '01'.isInt; // true
  /// '0x10'.isInt; // false
  /// '12.34'.isInt; // false
  /// 'abc'.isInt; // false
  /// ```
  bool get isInt {
    return _isInt(this);
  }
}

final _decimalInt = RegExp(r'^[+-]?\d+$');

bool _isInt(String str) {
  return _decimalInt.hasMatch(str.trim());
}
