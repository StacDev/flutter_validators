/// Describes a validation message without depending on a localization package.
class ValidationMessage {
  /// Creates a message with a stable [key], English [fallback], and parameters.
  const ValidationMessage(
    this.key,
    this.fallback, {
    this.parameters = const {},
  });

  /// Stable identifier applications can map to localized text.
  final String key;

  /// English text used when no resolver is configured.
  final String fallback;

  /// Values a resolver can interpolate into localized text.
  final Map<String, Object?> parameters;
}

/// Resolves a validation message into text for the application's locale.
typedef ValidationMessageResolver = String Function(ValidationMessage message);

/// Global, dependency-free configuration for validation messages.
abstract final class ValidationMessages {
  /// The active resolver, or `null` to use bundled English fallbacks.
  static ValidationMessageResolver? resolver;

  /// Resolves [message], with an explicit [errorMessage] taking precedence.
  static String resolve(ValidationMessage message, {String? errorMessage}) {
    return errorMessage ?? resolver?.call(message) ?? message.fallback;
  }

  /// Restores fallback English messages.
  static void reset() => resolver = null;
}
