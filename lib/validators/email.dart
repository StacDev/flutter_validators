/// Checks if the string is a valid email address.
///
/// Uses a regular expression to verify if the string matches standard email format.
/// Validates both local part (before @) and domain part (after @) of the email.
///
/// Returns `true` if the string is a valid email address, otherwise returns `false`.
///
/// Example:
/// ```dart
/// isEmail('user@example.com'); // true
/// isEmail('user.name+tag@example.co.uk'); // true
/// isEmail('invalid@email'); // false
/// ```
bool isEmail(String str) => _isEmail(str);

/// Extension providing email validation methods on [String].
extension EmailX on String {
  /// Checks if the string is a valid email address.
  ///
  /// Uses a regular expression to verify if the string matches standard email format.
  /// Validates both local part (before @) and domain part (after @) of the email.
  ///
  /// Returns `true` if the string is a valid email address, otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// 'user@example.com'.isEmail; // true
  /// 'user.name+tag@example.co.uk'.isEmail; // true
  /// 'invalid@email'.isEmail; // false
  /// ```
  bool get isEmail {
    return _isEmail(this);
  }
}

/// Internal implementation for email validation.
///
/// Uses a comprehensive regular expression that validates:
/// - Local part: can include alphanumerics, dots, and special characters
/// - Domain part: can be an IP address or domain name with TLD of at least 2 characters
///
/// The regex handles common email formats including quoted strings and subdomains.
final _email = RegExp(
  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);

bool _isEmail(String str) {
  return _email.hasMatch(str);
}
