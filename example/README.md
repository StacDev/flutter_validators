# Flutter Validators Example

This application is an executable guide to the 1.3 APIs.

## Run

```sh
flutter pub get
flutter run
```

## Walkthrough

- **Registration**: required/optional fields, fluent composition, conditional
  validation, strong passwords, and custom messages.
- **Finance**: IBAN, BIC, and ISBN checksum validation.
- **Strict**: side-by-side results for permissive and strict date, JWT, Base32,
  and credit-card rules.
- **Sanitizers**: before-and-after trimming and email normalization.
- **Messages**: dependency-free locale switching with `ValidationMessage`.

The source comments in `lib/main.dart` call out empty-value and composition
behavior. Run the demonstrated flows as widget tests:

```sh
flutter test
```
