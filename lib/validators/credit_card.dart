/// Checks if the string is a valid credit card number.
///
/// Strips hyphens and spaces before validating using the Luhn algorithm.
///
/// Example:
/// ```dart
/// isCreditCard('4111111111111111'); // true
/// isCreditCard('1234567890123456'); // false
/// ```
bool isCreditCard(String str) => _isCreditCard(str);

/// Extension providing credit card validation methods on [String].
extension CreditCardX on String {
  /// Checks if the string is a valid credit card number.
  bool get isCreditCard {
    return _isCreditCard(this);
  }
}

final _creditCardSeparators = RegExp(r'[\s\-]');
final _creditCardDigits = RegExp(r'^\d{13,19}$');

bool _isCreditCard(String str) {
  final sanitized = str.replaceAll(_creditCardSeparators, '');
  if (!_creditCardDigits.hasMatch(sanitized)) return false;

  int sum = 0;
  bool alternate = false;

  for (int i = sanitized.length - 1; i >= 0; i--) {
    int n = int.parse(sanitized[i]);
    if (alternate) {
      n *= 2;
      if (n > 9) {
        n = (n % 10) + 1;
      }
    }
    sum += n;
    alternate = !alternate;
  }

  return sum % 10 == 0;
}
