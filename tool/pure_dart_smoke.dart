import 'package:flutter_validators/flutter_validators.dart';

void main() {
  final rule = Validator.required().and(Validator.email());
  final normalized = normalizeEmail(trim('  User@Example.COM  '));

  if (normalized != 'User@example.com' || rule(normalized) != null) {
    throw StateError('Pure Dart validation smoke test failed');
  }
}
