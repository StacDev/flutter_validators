/// Checks whether [str] is a fully qualified domain name.
bool isFQDN(
  String str, {
  bool requireTld = true,
  bool allowTrailingDot = true,
  bool allowUnderscores = false,
  bool strict = false,
}) {
  return _isFQDN(
    str,
    requireTld: requireTld,
    allowTrailingDot: allowTrailingDot,
    allowUnderscores: allowUnderscores,
    strict: strict,
  );
}

bool _isFQDN(
  String str, {
  required bool requireTld,
  required bool allowTrailingDot,
  required bool allowUnderscores,
  required bool strict,
}) {
  if (str.isEmpty) return false;
  var domain = str;
  if (domain.endsWith('.')) {
    if (!allowTrailingDot) return false;
    domain = domain.substring(0, domain.length - 1);
  }
  if (strict && domain.length > 253) return false;

  final parts = domain.split('.');
  if (requireTld && parts.length < 2) return false;
  if (parts.any((part) => part.isEmpty || part.length > 63)) return false;

  if (requireTld) {
    final tld = parts.last;
    if (!RegExp(r'^[a-zA-Z]{2,}$|^xn--[a-zA-Z0-9-]+$').hasMatch(tld)) {
      return false;
    }
  }

  final label =
      allowUnderscores
          ? RegExp(r'^[a-zA-Z0-9_](?:[a-zA-Z0-9_-]*[a-zA-Z0-9_])?$')
          : RegExp(r'^[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$');
  return parts.every(label.hasMatch);
}

/// FQDN validation helpers on [String].
extension FQDNX on String {
  /// Uses the backward-compatible FQDN rules.
  bool get isFQDN => _isFQDN(
    this,
    requireTld: true,
    allowTrailingDot: true,
    allowUnderscores: false,
    strict: false,
  );

  /// Validates with configurable FQDN rules.
  bool isFQDNWith({
    bool requireTld = true,
    bool allowTrailingDot = true,
    bool allowUnderscores = false,
    bool strict = false,
  }) {
    return _isFQDN(
      this,
      requireTld: requireTld,
      allowTrailingDot: allowTrailingDot,
      allowUnderscores: allowUnderscores,
      strict: strict,
    );
  }
}
