/// Checks if the string is a valid UUID (versions 1, 3, 4, or 5).
///
/// Returns `true` if the string matches the UUID format, otherwise returns `false`.
///
/// Example:
/// ```dart
/// isUUID('123e4567-e89b-12d3-a456-426614174000'); // true
/// isUUID('invalid-uuid'); // false
/// ```
bool isUUID(String str) => _isUUID(str);

/// Extension providing UUID validation methods on [String].
extension UuidX on String {
  /// Checks if the string is a valid UUID.
  bool get isUUID {
    return _isUUID(this);
  }
}

final _uuid = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1345][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
);

bool _isUUID(String str) {
  return _uuid.hasMatch(str);
}
