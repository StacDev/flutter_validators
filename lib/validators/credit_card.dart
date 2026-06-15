/// Checks whether [str] passes the Luhn credit-card checksum.
///
/// Set [strict] to also reject repeated digits and require a known card-network
/// prefix and length. This never proves that a card exists or can be charged.
bool isCreditCard(String str, {bool strict = false}) {
  return _isCreditCard(str, strict: strict);
}

bool _isCreditCard(String str, {required bool strict}) {
  final value = str.replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^\d{13,19}$').hasMatch(value)) return false;
  if (strict) {
    if (RegExp(r'^(\d)\1+$').hasMatch(value) || !_hasKnownCardPattern(value)) {
      return false;
    }
  }

  var sum = 0;
  var alternate = false;
  for (var i = value.length - 1; i >= 0; i--) {
    var digit = int.parse(value[i]);
    if (alternate) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }
    sum += digit;
    alternate = !alternate;
  }
  return sum % 10 == 0;
}

bool _hasKnownCardPattern(String value) {
  final visa = RegExp(r'^4(?:\d{12}|\d{15}|\d{18})$');
  final mastercard = RegExp(
    r'^(?:5[1-5]\d{14}|2(?:2(?:2[1-9]|[3-9]\d)|[3-6]\d{2}|7(?:[01]\d|20))\d{12})$',
  );
  final amex = RegExp(r'^3[47]\d{13}$');
  final discover = RegExp(r'^6(?:011|5\d{2})\d{12}$');
  final jcb = RegExp(r'^(?:2131|1800)\d{11}$|^35\d{14}$');
  return [
    visa,
    mastercard,
    amex,
    discover,
    jcb,
  ].any((pattern) => pattern.hasMatch(value));
}

/// Credit-card validation helpers on [String].
extension CreditCardX on String {
  /// Uses the compatibility Luhn-only rules.
  bool get isCreditCard => _isCreditCard(this, strict: false);

  /// Validates with optional strict network and repeated-digit checks.
  bool isCreditCardWith({bool strict = false}) {
    return _isCreditCard(this, strict: strict);
  }
}
