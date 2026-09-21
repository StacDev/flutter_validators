/// Checks if the string represents a valid calendar date.
///
/// Accepts ISO-8601 strings such as `2023-12-01`, `2023-12-01 12:00:00`, and
/// `2023-12-01T12:00:00Z`. The `YYYY-MM-DD` prefix must be a real calendar
/// date — month/day overflow such as `2023-13-01` or `2023-02-29` is rejected.
///
/// Example:
/// ```dart
/// isDate('2023-12-01'); // true
/// isDate('2023-13-01'); // false
/// isDate('2023-02-29'); // false
/// isDate('invalid date'); // false
/// ```
bool isDate(String str) => _isDate(str);

/// Extension providing date validation methods on [String].
extension DateX on String {
  /// Checks if the string represents a valid calendar date.
  bool get isDate {
    return _isDate(this);
  }
}

final _isoDatePrefix = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');

bool _isDate(String str) {
  if (DateTime.tryParse(str) == null) return false;
  final match = _isoDatePrefix.firstMatch(str);
  if (match == null) return false;

  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final reconstructed = DateTime.utc(year, month, day);
  return reconstructed.year == year &&
      reconstructed.month == month &&
      reconstructed.day == day;
}
