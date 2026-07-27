/// Checks whether [str] is a UUID.
///
/// With no [version], versions 1, 3, 4, and 5 are accepted for compatibility.
bool isUUID(String str, [int? version]) {
  return _isUUID(str, version);
}

bool _isUUID(String str, [int? version]) {
  final versionPattern = version == null ? '[1345]' : '$version';
  if (version != null && (version < 1 || version > 5)) return false;
  return RegExp(
    '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-$versionPattern[0-9a-fA-F]{3}-'
    '[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\$',
  ).hasMatch(str);
}

/// UUID validation helpers on [String].
extension UuidX on String {
  /// Accepts UUID versions 1, 3, 4, and 5.
  bool get isUUID => _isUUID(this);

  /// Validates a specific UUID [version], or the compatibility set when null.
  bool isUUIDVersion([int? version]) => _isUUID(this, version);
}
