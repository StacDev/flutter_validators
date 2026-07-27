/// Checks whether [str] uses the RFC 4648 Base32 alphabet.
///
/// Set [strict] to enforce valid encoded lengths and exact padding.
bool isBase32(String str, {bool strict = false}) {
  return _isBase32(str, strict: strict);
}

bool _isBase32(String str, {required bool strict}) {
  if (str.isEmpty || !RegExp(r'^[A-Z2-7]+={0,6}$').hasMatch(str)) return false;

  final paddingIndex = str.indexOf('=');
  final dataLength = paddingIndex == -1 ? str.length : paddingIndex;
  final padding = str.length - dataLength;
  if (padding > 0) {
    if (str.length % 8 != 0 || !const {1, 3, 4, 6}.contains(padding)) {
      return false;
    }
  }
  if (!strict) return true;

  final remainder = dataLength % 8;
  if (!const {0, 2, 4, 5, 7}.contains(remainder)) return false;
  final expectedPadding = switch (remainder) {
    0 => 0,
    2 => 6,
    4 => 4,
    5 => 3,
    7 => 1,
    _ => -1,
  };
  return padding == 0 || padding == expectedPadding;
}

/// Base32 validation helpers on [String].
extension Base32X on String {
  /// Uses the compatibility Base32 rules.
  bool get isBase32 => _isBase32(this, strict: false);

  /// Validates Base32 with optional strict length and padding rules.
  bool isBase32With({bool strict = false}) {
    return _isBase32(this, strict: strict);
  }
}
