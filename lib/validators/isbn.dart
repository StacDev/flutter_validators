/// Checks an ISBN-10 or ISBN-13 identifier.
///
/// Spaces and hyphens are ignored. Set [version] to `10` or `13` to require a
/// specific format.
bool isISBN(String str, {int? version}) {
  return _isISBN(str, version: version);
}

bool _isISBN(String str, {int? version}) {
  if (version != null && version != 10 && version != 13) {
    throw ArgumentError.value(version, 'version', 'Must be 10 or 13');
  }
  final value = str.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  if ((version == null || version == 10) && _isISBN10(value)) return true;
  if ((version == null || version == 13) && _isISBN13(value)) return true;
  return false;
}

bool _isISBN10(String value) {
  if (!RegExp(r'^\d{9}[\dX]$').hasMatch(value)) return false;
  var sum = 0;
  for (var i = 0; i < 10; i++) {
    final digit = value[i] == 'X' ? 10 : int.parse(value[i]);
    sum += digit * (10 - i);
  }
  return sum % 11 == 0;
}

bool _isISBN13(String value) {
  if (!RegExp(r'^\d{13}$').hasMatch(value)) return false;
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    sum += int.parse(value[i]) * (i.isEven ? 1 : 3);
  }
  final check = (10 - sum % 10) % 10;
  return check == int.parse(value[12]);
}

/// ISBN validation helpers on [String].
extension ISBNX on String {
  /// Whether this is a checksum-valid ISBN-10 or ISBN-13.
  bool get isISBN => _isISBN(this);

  /// Checks a specific ISBN version.
  bool isISBNVersion([int? version]) => _isISBN(this, version: version);
}
