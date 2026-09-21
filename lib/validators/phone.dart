/// Checks if the string is a valid phone number.
///
/// Validates a variety of phone number formats using regular expressions,
/// covering the most common international and local phone number formats.
///
/// Supported formats include:
/// - International format with country code: +1234567890, +1 234 567 890
/// - US/North American formats: (123) 456-7890, 123-456-7890
/// - Format with dots: 123.456.7890
/// - Simple digit sequence (7-15 digits): 1234567890
///
/// Returns `true` if the string is a valid phone number, otherwise returns `false`.
///
/// Example:
/// ```dart
/// isPhone('+1 234 567 8901'); // true
/// isPhone('(123) 456-7890'); // true
/// isPhone('123.456.7890'); // true
/// isPhone('1234567890'); // true
/// isPhone('not-a-number'); // false
/// isPhone(''); // false (empty string)
/// ```
bool isPhone(String str) => _isPhone(str);

/// Extension providing phone number validation methods on [String].
extension PhoneX on String {
  /// Checks if the string is a valid phone number.
  ///
  /// Validates a variety of phone number formats using regular expressions,
  /// covering the most common international and local phone number formats.
  ///
  /// Supported formats include:
  /// - International format with country code: +1234567890, +1 234 567 890
  /// - US/North American formats: (123) 456-7890, 123-456-7890
  /// - Format with dots: 123.456.7890
  /// - Simple digit sequence (7-15 digits): 1234567890
  ///
  /// Returns `true` if the string is a valid phone number, otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// '+1 234 567 8901'.isPhone; // true
  /// '(123) 456-7890'.isPhone; // true
  /// '123.456.7890'.isPhone; // true
  /// '1234567890'.isPhone; // true
  /// 'not-a-number'.isPhone; // false
  /// ''.isPhone; // false (empty string)
  /// ```
  bool get isPhone {
    return _isPhone(this);
  }
}

/// Internal implementation for phone number validation.
///
/// The implementation:
/// 1. First checks if the string is empty, returning false if it is
/// 2. Uses a list of regular expression patterns to match various phone number formats
/// 3. Iterates through each pattern and returns true on the first match
/// 4. Returns false if none of the patterns match
///
/// The patterns include:
/// - International format with + and country code
/// - International format with separators (spaces, dots, hyphens)
/// - US/North American formats with parentheses and hyphens
/// - Formats with dots as separators
/// - Simple sequences of digits (7-15 digits)
bool _isPhone(String str) {
  if (str.isEmpty) {
    return false;
  }

  for (final pattern in _phonePatterns) {
    if (pattern.hasMatch(str)) {
      return true;
    }
  }

  return false;
}

final _phonePatterns = [
  // International format with + and country code
  RegExp(r'^\+[1-9]\d{1,14}$'),

  // International format with spaces/dashes after country code
  RegExp(r'^\+[1-9][\s.-]?\d{1,3}[\s.-]?\d{3,4}[\s.-]?\d{3,4}$'),

  // US/North American format
  RegExp(r'^\([0-9]{3}\)\s[0-9]{3}-[0-9]{4}$'),
  RegExp(r'^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),

  // Format with dots
  RegExp(r'^[0-9]{3}\.[0-9]{3}\.[0-9]{4}$'),

  // Simple sequence of digits (at least 7, at most 15)
  RegExp(r'^[0-9]{7,15}$'),
];
