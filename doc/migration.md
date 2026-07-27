# Migration Guide

## From flutter_validators 1.2

1. Change the dependency constraint to `^1.3.0`.
2. Run existing tests. Default validators retain 1.2 behavior.
3. Add strict options field by field where product requirements need them.
4. Replace local form-composition helpers with `compose` or fluent `.and()`.
5. Configure `Validator.messageResolver` if the application localizes errors.

No 1.2 public symbol was removed or renamed.

## From validators

Replace the import:

```dart
import 'package:flutter_validators/flutter_validators.dart';
```

Common calls such as `isEmail`, `isURL`, `isIP`, `isUUID`, `isJSON`/`isJson`,
and numeric checks may differ in naming or accepted edge cases. Migrate one
validator family at a time and keep representative valid and invalid fixtures.

For Flutter fields, replace handwritten closures with:

```dart
validator: Validator.required().and(Validator.email())
```

Sanitization remains a separate step. Normalize input before applying form or
domain validation.
