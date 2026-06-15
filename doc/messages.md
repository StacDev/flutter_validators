# Message Resolution

`ValidationMessage` contains a stable key, an English fallback, and parameters.
The package does not depend on Flutter localization or `intl`.

```dart
Validator.messageResolver = (message) {
  if (message.key == 'range') {
    return 'Use ${message.parameters['min']} through '
        '${message.parameters['max']}';
  }
  return message.fallback;
};
```

Resolution occurs when validation fails, so an existing validator follows the
application's current locale.

An explicit `errorMessage` always wins:

```dart
final accountEmail = Validator.email(
  errorMessage: 'The account email is invalid',
);
```

Call `Validator.resetMessageResolver()` during test teardown and when returning
to fallback English.
