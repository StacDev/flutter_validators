import 'dart:convert';

/// Supported fixed-length hexadecimal hash formats.
enum HashAlgorithm {
  md5(32),
  sha1(40),
  sha256(64),
  sha384(96),
  sha512(128);

  const HashAlgorithm(this.hexLength);

  /// Number of hexadecimal characters in the encoded digest.
  final int hexLength;
}

/// Checks whether [str] is a hexadecimal digest for [algorithm].
bool isHash(String str, HashAlgorithm algorithm) {
  return RegExp('^[a-fA-F0-9]{${algorithm.hexLength}}\$').hasMatch(str);
}

/// Checks an Internet media type such as `application/json`.
bool isMimeType(String str) {
  const token = r"[A-Za-z0-9!#$&^_.+-]+";
  return RegExp('^$token/$token\$').hasMatch(str);
}

/// Checks an RFC 2397-style data URI.
bool isDataURI(String str) {
  if (!str.startsWith('data:')) return false;
  final comma = str.indexOf(',');
  if (comma < 5) return false;
  final metadata = str.substring(5, comma);
  final payload = str.substring(comma + 1);
  final parts = metadata.split(';');
  if (parts.first.isNotEmpty && !isMimeType(parts.first)) return false;

  final isBase64 = parts.skip(1).contains('base64');
  for (final parameter in parts.skip(1)) {
    if (parameter == 'base64') continue;
    if (!RegExp(r'^[A-Za-z0-9!#$&^_.+-]+=[^;\s]+$').hasMatch(parameter)) {
      return false;
    }
  }

  try {
    if (isBase64) {
      base64.decode(payload);
    } else {
      Uri.decodeComponent(payload);
    }
    return true;
  } on FormatException {
    return false;
  }
}

/// Data and security validation helpers on [String].
extension DataRulesX on String {
  /// Whether this is a fixed-length hexadecimal digest.
  bool isHashFor(HashAlgorithm algorithm) => isHash(this, algorithm);

  /// Whether this is an Internet media type.
  bool get isMimeType => _DataValidation.mimeType(this);

  /// Whether this is a valid data URI.
  bool get isDataURI => _DataValidation.dataUri(this);
}

abstract final class _DataValidation {
  static bool mimeType(String value) => isMimeType(value);
  static bool dataUri(String value) => isDataURI(value);
}
