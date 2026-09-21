import 'ip.dart';

/// Checks if the string is a valid HTTP or HTTPS URL.
///
/// The URL must have a non-empty host. The host must be `localhost`, an IP
/// address, or a name that contains a dot (a TLD).
///
/// Example:
/// ```dart
/// isURL('https://google.com'); // true
/// isURL('http://localhost'); // true
/// isURL('https://'); // false
/// isURL('http://foo'); // false
/// isURL('invalid-url'); // false
/// ```
bool isURL(String str) => _isURL(str);

/// Extension providing URL validation methods on [String].
extension UrlX on String {
  /// Checks if the string is a valid HTTP or HTTPS URL.
  bool get isURL {
    return _isURL(this);
  }
}

bool _isURL(String str) {
  if (str.isEmpty) return false;
  final uri = Uri.tryParse(str);
  if (uri == null) return false;
  if (uri.scheme != 'http' && uri.scheme != 'https') return false;

  final host = uri.host;
  if (host.isEmpty || host == '.') return false;
  if (host.toLowerCase() == 'localhost') return true;
  if (isIP(host)) return true;
  return host.contains('.');
}
