import 'package:flutter_validators/flutter_validators.dart';
import 'package:test/test.dart';

void main() {
  tearDown(Validator.resetMessageResolver);

  group('generic composition', () {
    final required = Validator.required(errorMessage: 'required');
    final email = Validator.email(errorMessage: 'email');

    test('compose returns the first error', () {
      final validator = compose<String>([required, email]);
      expect(validator(null), 'required');
      expect(validator('bad'), 'email');
      expect(validator('a@example.com'), isNull);
    });

    test('aggregate returns every error', () {
      final validator = aggregate<String>([
        (_) => 'first',
        (_) => null,
        (_) => 'second',
      ], separator: ', ');
      expect(validator('value'), 'first, second');
    });

    test('any succeeds when one validator succeeds', () {
      final validator = any<String>([
        Validator.email(),
        Validator.url(),
      ], errorMessage: 'email or URL');
      expect(validator('person@example.com'), isNull);
      expect(validator('https://example.com'), isNull);
      expect(validator('neither'), 'email or URL');
      expect(() => any<String>([]), throwsArgumentError);
    });

    test('conditions and transform work with generic values', () {
      final positiveInt = when<int>(
        (value) => value != null,
        (value) => value! > 0 ? null : 'positive',
      );
      expect(positiveInt(null), isNull);
      expect(positiveInt(-1), 'positive');

      final evenLength = transform<List<int>, int>(
        (value) => value?.length,
        (value) => value == null || value.isEven ? null : 'even length',
      );
      expect(evenLength([1, 2]), isNull);
      expect(evenLength([1]), 'even length');

      final trueOnly = unless<bool>(
        (value) => value == null,
        (value) => value == true ? null : 'must be true',
      );
      expect(trueOnly(null), isNull);
      expect(trueOnly(false), 'must be true');

      final skipped = skipWhen<Set<String>>(
        (value) => value == null,
        (value) => value!.isEmpty ? 'empty' : null,
      );
      expect(skipped(null), isNull);
      expect(skipped(<String>{}), 'empty');
    });

    test('fluent composition supports and, or, conditions, and messages', () {
      final combined = required
          .and(email)
          .when((value) => value != 'skip')
          .withMessage('invalid');
      expect(combined('skip'), isNull);
      expect(combined('bad'), 'invalid');

      final alternative = email.or(
        Validator.url(),
        errorMessage: 'email or URL',
      );
      expect(alternative('https://dart.dev'), isNull);
      expect(alternative('bad'), 'email or URL');
      expect(email.unless((value) => value == 'skip')('skip'), isNull);
      expect(email.skipWhen((value) => value == 'skip')('skip'), isNull);
    });

    test('Validator exposes the complete generic composition facade', () {
      String? fail<T>(T? _) => 'fail';
      String? pass<T>(T? _) => null;

      expect(Validator.compose<int>([pass, fail])(1), 'fail');
      expect(
        Validator.aggregate<int>([fail, fail], separator: ',')(1),
        'fail,fail',
      );
      expect(Validator.any<int>([fail, pass])(1), isNull);
      expect(Validator.any<int>([fail], errorMessage: 'none')(1), 'none');
      expect(() => Validator.any<int>([]), throwsArgumentError);
      expect(Validator.conditional<int>((_) => false, fail)(1), isNull);
      expect(Validator.when<int>((_) => true, fail)(1), 'fail');
      expect(Validator.unless<int>((_) => true, fail)(1), isNull);
      expect(Validator.skipWhen<int>((_) => false, fail)(1), 'fail');
      expect(
        Validator.transform<String, int>(
          (value) => value == null ? null : int.tryParse(value),
          fail,
        )('1'),
        'fail',
      );
    });
  });

  group('validation messages', () {
    test('uses fallback English without a resolver', () {
      expect(Validator.email()('bad'), 'Please enter a valid email address');
    });

    test('resolves keys and parameters at validation time', () {
      final validator = Validator.range(1, 10);
      Validator.messageResolver =
          (message) => 'es:${message.key}:${message.parameters['min']}';
      expect(Validator.messageResolver, isNotNull);
      expect(validator('20'), 'es:range:1');

      Validator.messageResolver = (message) => 'fr:${message.key}';
      expect(validator('20'), 'fr:range');
    });

    test('explicit error messages override the resolver', () {
      Validator.messageResolver = (message) => 'resolved:${message.key}';
      expect(
        Validator.email(errorMessage: 'Custom email')('bad'),
        'Custom email',
      );
    });
  });
}
