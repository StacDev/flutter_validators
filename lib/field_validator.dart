/// A synchronous validator for nullable values.
///
/// Returning `null` means the value is valid. Returning a string means the
/// value is invalid and the string should be shown to the user.
typedef FieldValidator<T> = String? Function(T? value);

/// Runs [validators] in order and returns the first validation error.
FieldValidator<T> compose<T>(Iterable<FieldValidator<T>> validators) {
  final rules = List<FieldValidator<T>>.unmodifiable(validators);
  return (value) {
    for (final validator in rules) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  };
}

/// Runs every validator and joins all validation errors.
FieldValidator<T> aggregate<T>(
  Iterable<FieldValidator<T>> validators, {
  String separator = '\n',
}) {
  final rules = List<FieldValidator<T>>.unmodifiable(validators);
  return (value) {
    final errors = <String>[];
    for (final validator in rules) {
      final error = validator(value);
      if (error != null) errors.add(error);
    }
    return errors.isEmpty ? null : errors.join(separator);
  };
}

/// Succeeds when at least one of [validators] succeeds.
FieldValidator<T> any<T>(
  Iterable<FieldValidator<T>> validators, {
  String errorMessage = 'Value does not match any allowed format',
}) {
  final rules = List<FieldValidator<T>>.unmodifiable(validators);
  if (rules.isEmpty) {
    throw ArgumentError.value(validators, 'validators', 'Must not be empty');
  }

  return (value) {
    for (final validator in rules) {
      if (validator(value) == null) return null;
    }
    return errorMessage;
  };
}

/// Runs [validator] only when [predicate] returns `true`.
FieldValidator<T> conditional<T>(
  bool Function(T? value) predicate,
  FieldValidator<T> validator,
) {
  return (value) => predicate(value) ? validator(value) : null;
}

/// Alias for [conditional], useful when reading a validation rule as a sentence.
FieldValidator<T> when<T>(
  bool Function(T? value) predicate,
  FieldValidator<T> validator,
) {
  return conditional(predicate, validator);
}

/// Runs [validator] unless [predicate] returns `true`.
FieldValidator<T> unless<T>(
  bool Function(T? value) predicate,
  FieldValidator<T> validator,
) {
  return conditional((value) => !predicate(value), validator);
}

/// Skips [validator] when [predicate] returns `true`.
FieldValidator<T> skipWhen<T>(
  bool Function(T? value) predicate,
  FieldValidator<T> validator,
) {
  return unless(predicate, validator);
}

/// Transforms a value before passing it to [validator].
FieldValidator<T> transform<T, R>(
  R? Function(T? value) transformer,
  FieldValidator<R> validator,
) {
  return (value) => validator(transformer(value));
}

/// Fluent composition helpers for any [FieldValidator].
extension FieldValidatorComposition<T> on FieldValidator<T> {
  /// Runs this validator, then [other], returning the first error.
  FieldValidator<T> and(FieldValidator<T> other) => compose([this, other]);

  /// Succeeds when this validator or [other] succeeds.
  FieldValidator<T> or(
    FieldValidator<T> other, {
    String errorMessage = 'Value does not match any allowed format',
  }) {
    return any([this, other], errorMessage: errorMessage);
  }

  /// Runs this validator only when [predicate] returns `true`.
  FieldValidator<T> when(bool Function(T? value) predicate) {
    return conditional(predicate, this);
  }

  /// Runs this validator unless [predicate] returns `true`.
  FieldValidator<T> unless(bool Function(T? value) predicate) {
    return conditional((value) => !predicate(value), this);
  }

  /// Skips this validator when [predicate] returns `true`.
  FieldValidator<T> skipWhen(bool Function(T? value) predicate) {
    return unless(predicate);
  }

  /// Replaces any error from this validator with [errorMessage].
  FieldValidator<T> withMessage(String errorMessage) {
    return (value) => this(value) == null ? null : errorMessage;
  }
}
