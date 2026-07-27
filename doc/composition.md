# Composition Recipes

`FieldValidator<T>` is `String? Function(T? value)`: `null` means valid and a
string is the validation error.

## First Error Or All Errors

```dart
final firstError = compose<String>([
  Validator.required(),
  Validator.email(),
]);

final allErrors = aggregate<String>([
  Validator.length(12),
  Validator.strongPassword(),
]);
```

## Alternatives

```dart
final contact = any<String>([
  Validator.email(),
  Validator.url(),
], errorMessage: 'Enter an email or URL');
```

## Conditional Rules

```dart
final teamName = Validator.required().when((_) => createTeam);
final nickname = Validator.length(3).unless((value) => value == 'anonymous');
final optionalCode = Validator.uuid().skipWhen((value) => value == 'later');
```

## Model And Collection Rules

```dart
final itemCount = transform<List<String>, int>(
  (items) => items?.length,
  (count) => count != null && count > 10 ? 'Use at most 10 items' : null,
);
```

Predicates and transformers may receive `null`; decide explicitly whether to
skip or reject it.
