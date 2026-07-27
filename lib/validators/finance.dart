/// Checks an International Bank Account Number checksum.
bool isIBAN(String str) {
  final value = str.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{11,30}$').hasMatch(value)) {
    return false;
  }

  final rearranged = '${value.substring(4)}${value.substring(0, 4)}';
  var remainder = 0;
  for (final codeUnit in rearranged.codeUnits) {
    final chunk =
        codeUnit >= 65 ? '${codeUnit - 55}' : String.fromCharCode(codeUnit);
    for (final digit in chunk.codeUnits) {
      remainder = (remainder * 10 + digit - 48) % 97;
    }
  }
  return remainder == 1;
}

/// Checks a SWIFT Business Identifier Code.
bool isBIC(String str) {
  return RegExp(
    r'^[A-Z]{6}[A-Z0-9]{2}(?:[A-Z0-9]{3})?$',
  ).hasMatch(str.toUpperCase());
}

/// Checks a card verification code without identifying a specific card.
bool isCreditCardCVC(String str, {int minLength = 3, int maxLength = 4}) {
  if (minLength < 1 || maxLength < minLength) {
    throw ArgumentError('CVC length bounds are invalid');
  }
  return RegExp('^\\d{$minLength,$maxLength}\$').hasMatch(str);
}

/// Checks a card expiry in `MM/YY` or `MM/YYYY` format.
///
/// [referenceDate] makes boundary-sensitive tests and server workflows
/// deterministic. A card remains valid through the end of its expiry month.
bool isCreditCardExpirationDate(
  String str, {
  bool requireFuture = true,
  DateTime? referenceDate,
}) {
  final match = RegExp(r'^(0[1-9]|1[0-2])\/(\d{2}|\d{4})$').firstMatch(str);
  if (match == null) return false;
  final month = int.parse(match.group(1)!);
  var year = int.parse(match.group(2)!);
  if (year < 100) year += 2000;
  if (!requireFuture) return true;

  final now = referenceDate ?? DateTime.now();
  return year > now.year || (year == now.year && month >= now.month);
}

/// Finance validation helpers on [String].
extension FinanceX on String {
  /// Whether this is a checksum-valid IBAN.
  bool get isIBAN => _FinanceValidation.iban(this);

  /// Whether this is a valid 8- or 11-character BIC.
  bool get isBIC => _FinanceValidation.bic(this);

  /// Whether this is a numeric CVC with the configured length.
  bool isCardCVC({int minLength = 3, int maxLength = 4}) {
    return isCreditCardCVC(this, minLength: minLength, maxLength: maxLength);
  }

  /// Whether this is a valid card expiry.
  bool isCardExpiration({bool requireFuture = true, DateTime? referenceDate}) {
    return isCreditCardExpirationDate(
      this,
      requireFuture: requireFuture,
      referenceDate: referenceDate,
    );
  }
}

abstract final class _FinanceValidation {
  static bool iban(String value) => isIBAN(value);
  static bool bic(String value) => isBIC(value);
}
