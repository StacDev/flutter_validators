import 'dart:convert';

final _base64Url = RegExp(r'^[A-Za-z0-9_-]+$');

/// Checks whether [str] has JWT structure.
///
/// The compatibility default only checks the three Base64URL-like segments.
/// With [strict], header and payload must decode to JSON objects.
bool isJWT(String str, {bool strict = false, bool allowUnsigned = true}) {
  return _isJWT(str, strict: strict, allowUnsigned: allowUnsigned);
}

bool _isJWT(String str, {required bool strict, required bool allowUnsigned}) {
  final parts = str.split('.');
  if (parts.length != 3 || parts[0].isEmpty || parts[1].isEmpty) return false;
  if (!_base64Url.hasMatch(parts[0]) || !_base64Url.hasMatch(parts[1])) {
    return false;
  }
  if (parts[2].isNotEmpty && !_base64Url.hasMatch(parts[2])) return false;
  if (!allowUnsigned && parts[2].isEmpty) return false;
  if (!strict) return true;

  try {
    final header = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[0]))),
    );
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    if (header is! Map<String, dynamic> || payload is! Map<String, dynamic>) {
      return false;
    }
    if (header['alg'] == 'none' && !allowUnsigned) return false;
    return true;
  } on FormatException {
    return false;
  }
}

/// JWT validation helpers on [String].
extension JWTX on String {
  /// Uses the compatibility structural check.
  bool get isJWT => _isJWT(this, strict: false, allowUnsigned: true);

  /// Validates JWT structure with optional decoded JSON checks.
  bool isJWTWith({bool strict = false, bool allowUnsigned = true}) {
    return _isJWT(this, strict: strict, allowUnsigned: allowUnsigned);
  }
}
