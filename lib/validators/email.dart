/// Checks whether [str] is an email address.
///
/// The defaults preserve the package's 1.2 behavior. Set [allowUnicode] to
/// accept Unicode local parts and internationalized domain labels.
bool isEmail(
  String str, {
  bool allowUnicode = false,
  bool requireTld = true,
  bool allowIpDomain = true,
  int maxLength = 254,
}) {
  return _isEmail(
    str,
    allowUnicode: allowUnicode,
    requireTld: requireTld,
    allowIpDomain: allowIpDomain,
    maxLength: maxLength,
  );
}

bool _isEmail(
  String str, {
  required bool allowUnicode,
  required bool requireTld,
  required bool allowIpDomain,
  required int maxLength,
}) {
  if (!allowUnicode && requireTld && allowIpDomain && maxLength == 254) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(str);
  }
  if (str.isEmpty || str.length > maxLength) return false;
  final at = str.lastIndexOf('@');
  if (at <= 0 || at == str.length - 1) return false;

  final local = str.substring(0, at);
  final domain = str.substring(at + 1);
  if (local.length > 64) return false;

  if (allowIpDomain &&
      RegExp(r'^\[(?:\d{1,3}\.){3}\d{1,3}\]$').hasMatch(domain)) {
    final octets = domain.substring(1, domain.length - 1).split('.');
    return octets.every((part) => int.parse(part) <= 255);
  }

  final localPattern =
      allowUnicode
          ? RegExp(
            r'^[^\s<>()[\]\\,;:@"\u0000-\u001F\u007F]+(?:\.[^\s<>()[\]\\,;:@"\u0000-\u001F\u007F]+)*$',
            unicode: true,
          )
          : RegExp(
            r'^([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+")$',
          );
  if (!localPattern.hasMatch(local)) return false;

  final labels = domain.split('.');
  if (requireTld && labels.length < 2) return false;
  if (labels.any((label) => label.isEmpty || label.length > 63)) return false;

  final labelPattern =
      allowUnicode
          ? RegExp(
            r'^[\p{L}\p{N}](?:[\p{L}\p{N}-]*[\p{L}\p{N}])?$',
            unicode: true,
          )
          : RegExp(r'^[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$');
  if (!labels.every(labelPattern.hasMatch)) return false;

  if (requireTld) {
    final tld = labels.last;
    final validTld =
        allowUnicode
            ? RegExp(r'^(?:[\p{L}]{2,}|xn--[a-zA-Z0-9-]+)$', unicode: true)
            : RegExp(r'^(?:[a-zA-Z]{2,}|xn--[a-zA-Z0-9-]+)$');
    if (!validTld.hasMatch(tld)) return false;
  }
  return true;
}

/// Email validation helpers on [String].
extension EmailX on String {
  /// Uses the backward-compatible default email rules.
  bool get isEmail => _isEmail(
    this,
    allowUnicode: false,
    requireTld: true,
    allowIpDomain: true,
    maxLength: 254,
  );

  /// Validates with configurable email rules.
  bool isEmailWith({
    bool allowUnicode = false,
    bool requireTld = true,
    bool allowIpDomain = true,
    int maxLength = 254,
  }) {
    return _isEmail(
      this,
      allowUnicode: allowUnicode,
      requireTld: requireTld,
      allowIpDomain: allowIpDomain,
      maxLength: maxLength,
    );
  }
}
