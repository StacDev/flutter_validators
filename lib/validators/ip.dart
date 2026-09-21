/// Checks if the string is a valid IP address (IPv4 or IPv6).
///
/// Provide [version] 4 or 6 to validate specifically for IPv4 or IPv6.
///
/// Example:
/// ```dart
/// isIP('192.168.1.1'); // true
/// isIP('invalid_ip'); // false
/// isIP('192.168.1.1', 6); // false
/// ```
bool isIP(String str, [int? version]) => _isIP(str, version);

/// Extension providing IP validation methods on [String].
extension IpX on String {
  /// Checks if the string is a valid IP address.
  bool get isIP {
    return _isIP(this);
  }

  /// Checks if the string is a valid IPv4 address.
  bool get isIPv4 {
    return _isIP(this, 4);
  }

  /// Checks if the string is a valid IPv6 address.
  bool get isIPv6 {
    return _isIP(this, 6);
  }
}

bool _isIP(String str, [int? version]) {
  if (version == null) return _isIPv4(str) || _isIPv6(str);
  if (version == 4) return _isIPv4(str);
  if (version == 6) return _isIPv6(str);
  return false;
}

final _ipv4 = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
final _ipv6 = RegExp(
  r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
);

bool _isIPv4(String str) {
  final match = _ipv4.firstMatch(str);
  if (match == null) return false;

  for (int i = 1; i <= 4; i++) {
    final val = int.parse(match.group(i)!);
    if (val < 0 || val > 255) return false;
  }
  return true;
}

bool _isIPv6(String str) {
  return _ipv6.hasMatch(str);
}
