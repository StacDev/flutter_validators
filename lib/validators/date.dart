/// Checks whether [str] can be parsed by [DateTime.tryParse].
///
/// This intentionally preserves permissive 1.2 behavior, including rollover.
bool isDate(String str) => DateTime.tryParse(str) != null;

/// Checks a calendar date in exactly `YYYY-MM-DD` format.
bool isISO8601Date(String str) => _isISO8601Date(str);

bool _isISO8601Date(String str) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(str);
  if (match == null) return false;
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  if (month < 1 || month > 12 || day < 1) return false;
  final parsed = DateTime.utc(year, month, day);
  return parsed.year == year && parsed.month == month && parsed.day == day;
}

/// Checks a 24-hour time in `HH:mm` or `HH:mm:ss` format.
bool isTime(String str, {bool allowSeconds = true}) {
  return _isTime(str, allowSeconds: allowSeconds);
}

bool _isTime(String str, {required bool allowSeconds}) {
  final pattern =
      allowSeconds
          ? RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d(?::[0-5]\d)?$')
          : RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
  return pattern.hasMatch(str);
}

/// Checks whether [str] parses to a date before [reference].
bool isBefore(String str, DateTime reference) {
  final value = DateTime.tryParse(str);
  return value != null && value.isBefore(reference);
}

/// Checks whether [str] parses to a date after [reference].
bool isAfter(String str, DateTime reference) {
  final value = DateTime.tryParse(str);
  return value != null && value.isAfter(reference);
}

/// Date and time validation helpers on [String].
extension DateX on String {
  /// Uses Dart's permissive date parser.
  bool get isDate => DateTime.tryParse(this) != null;

  /// Requires a real `YYYY-MM-DD` calendar date.
  bool get isISO8601Date => _isISO8601Date(this);

  /// Checks a 24-hour time.
  bool isValidTime({bool allowSeconds = true}) {
    return _isTime(this, allowSeconds: allowSeconds);
  }

  /// Checks whether this value parses before [reference].
  bool isBeforeDate(DateTime reference) => isBefore(this, reference);

  /// Checks whether this value parses after [reference].
  bool isAfterDate(DateTime reference) => isAfter(this, reference);
}
