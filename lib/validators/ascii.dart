/// Checks if the string contains only ASCII characters.
///
/// Returns `true` if the string only contains ASCII characters (code points 0-127),
/// otherwise returns `false`.
///
/// Example:
/// ```dart
/// isAscii('abc123'); // true
/// isAscii('äbc123'); // false
/// ```
bool isAscii(String str) => _isAscii(str);

/// Extension providing ASCII validation methods on [String].
extension AsciiX on String {
  /// Checks if the string contains only ASCII characters.
  ///
  /// Returns `true` if the string only contains ASCII characters (code points 0-127),
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// 'abc123'.isAscii; // true
  /// 'äbc123'.isAscii; // false
  /// ```
  bool get isAscii {
    return _isAscii(this);
  }
}

/// Internal implementation for ASCII validation.
///
/// Validates if a string contains only ASCII characters using a regular expression
/// that matches characters in the range \x00-\x7F (code points 0-127).
final _ascii = RegExp(r'^[\x00-\x7F]+$');

bool _isAscii(String str) {
  return _ascii.hasMatch(str);
}
