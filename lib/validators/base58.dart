/// Checks if the string is base58 encoded.
///
/// Base58 encoding is a binary-to-text encoding used to represent large integers as
/// alphanumeric text. It uses a 58-character subset of ASCII excluding the similar-looking
/// characters: 0 (zero), O (capital o), I (capital i), and l (lowercase L).
///
/// Returns `true` if the string is valid base58 encoded, otherwise returns `false`.
///
/// Example:
/// ```dart
/// isBase58('3yDKLZJ4PC1HE4Y8L8Esx'); // true
/// isBase58('hello 0OIl world'); // false
/// ```
bool isBase58(String str) => _isBase58(str);

/// Extension providing base58 validation methods on [String].
extension Base58X on String {
  /// Checks if the string is base58 encoded.
  ///
  /// Base58 encoding is a binary-to-text encoding used to represent large integers as
  /// alphanumeric text. It uses a 58-character subset of ASCII excluding the similar-looking
  /// characters: 0 (zero), O (capital o), I (capital i), and l (lowercase L).
  ///
  /// Returns `true` if the string is valid base58 encoded, otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// '3yDKLZJ4PC1HE4Y8L8Esx'.isBase58; // true
  /// 'hello 0OIl world'.isBase58; // false
  /// ```
  bool get isBase58 {
    return _isBase58(this);
  }
}

/// Internal implementation for base58 validation.
///
/// Validates if a string is base58 encoded using a regular expression
/// that matches the base58 character set: A-H, J-N, P-Z, a-k, m-z, and 1-9.
/// The omitted characters are: 0, O, I, and l to avoid visual ambiguity.
final _base58 = RegExp(r'^[A-HJ-NP-Za-km-z1-9]+$');

bool _isBase58(String str) {
  return _base58.hasMatch(str);
}
