/// Checks whether [str] is a number greater than zero.
bool isPositive(String str) {
  final value = num.tryParse(str);
  return value != null && value.isFinite && value > 0;
}

/// Checks whether [str] is a number less than zero.
bool isNegative(String str) {
  final value = num.tryParse(str);
  return value != null && value.isFinite && value < 0;
}

/// Checks whether [str] is between [min] and [max].
bool isInRange(String str, num min, num max, {bool inclusive = true}) {
  if (min > max) {
    throw ArgumentError.value(min, 'min', 'Must be less than or equal to max');
  }
  final value = num.tryParse(str);
  if (value == null || !value.isFinite) return false;
  return inclusive ? value >= min && value <= max : value > min && value < max;
}

/// Checks whether [str] is evenly divisible by [divisor].
bool isDivisibleBy(String str, num divisor) {
  if (divisor == 0) return false;
  final value = num.tryParse(str);
  return value != null && value.isFinite && value % divisor == 0;
}

/// Additional numeric validation helpers on [String].
extension NumberRulesX on String {
  /// Whether this is a finite number greater than zero.
  bool get isPositive {
    final value = num.tryParse(this);
    return value != null && value.isFinite && value > 0;
  }

  /// Whether this is a finite number less than zero.
  bool get isNegative {
    final value = num.tryParse(this);
    return value != null && value.isFinite && value < 0;
  }

  /// Whether this is within the configured numeric range.
  bool isInNumericRange(num min, num max, {bool inclusive = true}) {
    return isInRange(this, min, max, inclusive: inclusive);
  }

  /// Whether this is evenly divisible by [divisor].
  bool isDivisibleByNumber(num divisor) => isDivisibleBy(this, divisor);
}
