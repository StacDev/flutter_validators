/// Checks whether [str] starts with [prefix].
bool startsWith(String str, String prefix, {bool ignoreCase = false}) {
  if (!ignoreCase) return str.startsWith(prefix);
  return str.toLowerCase().startsWith(prefix.toLowerCase());
}

/// Checks whether [str] ends with [suffix].
bool endsWith(String str, String suffix, {bool ignoreCase = false}) {
  if (!ignoreCase) return str.endsWith(suffix);
  return str.toLowerCase().endsWith(suffix.toLowerCase());
}

/// Checks whether [str] contains no line breaks.
bool isSingleLine(String str) => !str.contains(RegExp(r'[\r\n]'));

/// Checks whether the whitespace-delimited word count is in range.
bool hasWordCount(String str, {int min = 0, int? max}) {
  if (min < 0 || (max != null && max < min)) {
    throw ArgumentError('Word-count bounds are invalid');
  }
  final trimmed = str.trim();
  final count = trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
  return count >= min && (max == null || count <= max);
}

/// Text-rule helpers on [String].
extension TextRulesX on String {
  /// Checks a prefix with optional case folding.
  bool startsWithText(String prefix, {bool ignoreCase = false}) {
    return startsWith(this, prefix, ignoreCase: ignoreCase);
  }

  /// Checks a suffix with optional case folding.
  bool endsWithText(String suffix, {bool ignoreCase = false}) {
    return endsWith(this, suffix, ignoreCase: ignoreCase);
  }

  /// Whether this string contains no line breaks.
  bool get isSingleLine => !contains(RegExp(r'[\r\n]'));

  /// Whether this string's word count is in range.
  bool hasWords({int min = 0, int? max}) {
    return hasWordCount(this, min: min, max: max);
  }
}
