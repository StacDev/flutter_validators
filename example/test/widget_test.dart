import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_validators/flutter_validators.dart';

void main() {
  tearDown(Validator.resetMessageResolver);

  testWidgets('registration demonstrates composition and conditional fields', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.byKey(const Key('registration-submit')));
    await tester.tap(find.byKey(const Key('registration-submit')));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('registration-email')),
      'person@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('registration-password')),
      'Strong123!',
    );
    await tester.ensureVisible(find.byKey(const Key('registration-submit')));
    await tester.tap(find.byKey(const Key('registration-submit')));
    await tester.pump();
    expect(find.text('Registration is valid'), findsOneWidget);
  });

  testWidgets('finance validates IBAN, BIC, and ISBN', (tester) async {
    await tester.pumpWidget(const MyApp());
    await _openTab(tester, 'Finance');

    await tester.enterText(
      find.byKey(const Key('finance-iban')),
      'GB82 WEST 1234 5698 7654 32',
    );
    await tester.enterText(find.byKey(const Key('finance-bic')), 'DEUTDEFF');
    await tester.enterText(
      find.byKey(const Key('finance-isbn')),
      '978-0-306-40615-7',
    );
    await tester.ensureVisible(find.byKey(const Key('finance-submit')));
    await tester.tap(find.byKey(const Key('finance-submit')));
    await tester.pump();
    expect(find.text('Financial identifiers are valid'), findsOneWidget);
  });

  testWidgets('strict tab compares compatibility and strict results', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await _openTab(tester, 'Strict');
    expect(find.text('Accepted'), findsNWidgets(4));

    await tester.tap(find.byKey(const Key('strict-switch')));
    await tester.pump();
    expect(find.text('Rejected'), findsNWidgets(4));
  });

  testWidgets('sanitizer tab shows before and after output', (tester) async {
    await tester.pumpWidget(const MyApp());
    await _openTab(tester, 'Sanitizers');

    await tester.tap(find.byKey(const Key('sanitizer-run')));
    await tester.pump();
    expect(find.text('After: testuser@gmail.com'), findsOneWidget);
  });

  testWidgets('message tab switches locale through the resolver', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await _openTab(tester, 'Messages');

    await tester.enterText(
      find.byKey(const Key('message-email')),
      'not-an-email',
    );
    await tester.tap(find.byKey(const Key('message-locale')));
    await tester.tap(find.byKey(const Key('message-submit')));
    await tester.pump();
    expect(find.text('Introduce un correo válido'), findsOneWidget);
  });
}

Future<void> _openTab(WidgetTester tester, String label) async {
  final tab = find.text(label);
  await tester.ensureVisible(tab);
  await tester.tap(tab);
  await tester.pumpAndSettle();
}
