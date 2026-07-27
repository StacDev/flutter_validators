import 'fqdn.dart';

/// Checks whether [str] is a URL accepted by the configured rules.
bool isURL(
  String str, {
  Iterable<String> protocols = const ['http', 'https'],
  bool requireTld = false,
  bool allowLocalhost = true,
  bool allowUnderscores = false,
  int maxLength = 2083,
}) {
  return _isURL(
    str,
    protocols: protocols,
    requireTld: requireTld,
    allowLocalhost: allowLocalhost,
    allowUnderscores: allowUnderscores,
    maxLength: maxLength,
  );
}

bool _isURL(
  String str, {
  required Iterable<String> protocols,
  required bool requireTld,
  required bool allowLocalhost,
  required bool allowUnderscores,
  required int maxLength,
}) {
  if (protocols.length == 2 &&
      protocols.contains('http') &&
      protocols.contains('https') &&
      !requireTld &&
      allowLocalhost &&
      !allowUnderscores &&
      maxLength == 2083) {
    if (str.isEmpty) return false;
    final uri = Uri.tryParse(str);
    return uri != null &&
        uri.hasAuthority &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }
  if (str.isEmpty || str.length > maxLength) return false;
  final uri = Uri.tryParse(str);
  if (uri == null || !uri.hasAuthority || !protocols.contains(uri.scheme)) {
    return false;
  }

  final host = uri.host;
  if (host.isEmpty) return false;
  if (host == 'localhost') return allowLocalhost;
  if (Uri.tryParse('http://$host')?.host.isEmpty ?? true) return false;
  if (RegExp(r'^\d{1,3}(?:\.\d{1,3}){3}$').hasMatch(host)) {
    return host.split('.').every((part) => int.parse(part) <= 255);
  }
  if (host.contains(':')) return true;
  if (!requireTld && !host.contains('.')) {
    return RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(host) &&
        (allowUnderscores || !host.contains('_'));
  }
  return isFQDN(
    host,
    requireTld: requireTld,
    allowUnderscores: allowUnderscores,
    strict: requireTld,
  );
}

/// URL validation helpers on [String].
extension UrlX on String {
  /// Uses the backward-compatible HTTP/HTTPS URL rules.
  bool get isURL => _isURL(
    this,
    protocols: const ['http', 'https'],
    requireTld: false,
    allowLocalhost: true,
    allowUnderscores: false,
    maxLength: 2083,
  );

  /// Validates with configurable URL rules.
  bool isURLWith({
    Iterable<String> protocols = const ['http', 'https'],
    bool requireTld = false,
    bool allowLocalhost = true,
    bool allowUnderscores = false,
    int maxLength = 2083,
  }) {
    return _isURL(
      this,
      protocols: protocols,
      requireTld: requireTld,
      allowLocalhost: allowLocalhost,
      allowUnderscores: allowUnderscores,
      maxLength: maxLength,
    );
  }
}
