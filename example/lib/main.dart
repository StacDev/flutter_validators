import 'package:flutter/material.dart';
import 'package:flutter_validators/flutter_validators.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Validators 1.3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const DefaultTabController(length: 5, child: ExampleHome()),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Validators 1.3'),
        bottom: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'Registration'),
            Tab(text: 'Finance'),
            Tab(text: 'Strict'),
            Tab(text: 'Sanitizers'),
            Tab(text: 'Messages'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          RegistrationDemo(),
          FinanceDemo(),
          StrictDemo(),
          SanitizerDemo(),
          MessageDemo(),
        ],
      ),
    );
  }
}

class RegistrationDemo extends StatefulWidget {
  const RegistrationDemo({super.key});

  @override
  State<RegistrationDemo> createState() => _RegistrationDemoState();
}

class _RegistrationDemoState extends State<RegistrationDemo> {
  final _formKey = GlobalKey<FormState>();
  bool _createTeam = false;
  String _result = 'Complete the form to see composition in action.';

  @override
  Widget build(BuildContext context) {
    return _DemoPage(
      title: 'Registration and profile',
      description:
          'Required fields are composed with format rules. Optional validators '
          'accept empty values until required is added.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('registration-email'),
                decoration: const InputDecoration(labelText: 'Email'),
                // Composition returns the first useful error.
                validator: Validator.required(
                  errorMessage: 'Email is required',
                ).and(Validator.email(errorMessage: 'Enter a valid email')),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('registration-password'),
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: Validator.required().and(
                  Validator.strongPassword(
                    errorMessage:
                        'Use upper, lower, number, symbol, and 8 characters',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('registration-profile'),
                decoration: const InputDecoration(
                  labelText: 'Profile summary (optional)',
                ),
                // Empty is valid because this field is not required.
                validator: Validator.wordCount(
                  max: 20,
                  errorMessage: 'Keep the profile to 20 words',
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Create a team'),
                value: _createTeam,
                onChanged: (value) => setState(() => _createTeam = value),
              ),
              TextFormField(
                key: const Key('registration-team'),
                decoration: const InputDecoration(labelText: 'Team name'),
                validator: Validator.required(
                  errorMessage: 'Team name is required',
                ).when((_) => _createTeam),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('registration-submit'),
                onPressed: () {
                  final valid = _formKey.currentState!.validate();
                  setState(() {
                    _result =
                        valid ? 'Registration is valid' : 'Fix the form errors';
                  });
                },
                child: const Text('Validate registration'),
              ),
            ],
          ),
        ),
        _ResultText(_result),
      ],
    );
  }
}

class FinanceDemo extends StatefulWidget {
  const FinanceDemo({super.key});

  @override
  State<FinanceDemo> createState() => _FinanceDemoState();
}

class _FinanceDemoState extends State<FinanceDemo> {
  final _formKey = GlobalKey<FormState>();
  String _result = 'Validate bank and book identifiers together.';

  @override
  Widget build(BuildContext context) {
    return _DemoPage(
      title: 'Finance and identifiers',
      description: 'IBAN, BIC, card CVC, expiry, and ISBN checksum validation.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('finance-iban'),
                decoration: const InputDecoration(labelText: 'IBAN'),
                validator: Validator.required().and(Validator.iban()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('finance-bic'),
                decoration: const InputDecoration(labelText: 'BIC / SWIFT'),
                validator: Validator.required().and(Validator.bic()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('finance-isbn'),
                decoration: const InputDecoration(labelText: 'ISBN-13'),
                validator: Validator.required().and(
                  Validator.isbn(version: 13),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('finance-submit'),
                onPressed: () {
                  final valid = _formKey.currentState!.validate();
                  setState(() {
                    _result =
                        valid
                            ? 'Financial identifiers are valid'
                            : 'One or more identifiers are invalid';
                  });
                },
                child: const Text('Validate identifiers'),
              ),
            ],
          ),
        ),
        _ResultText(_result),
      ],
    );
  }
}

class StrictDemo extends StatefulWidget {
  const StrictDemo({super.key});

  @override
  State<StrictDemo> createState() => _StrictDemoState();
}

class _StrictDemoState extends State<StrictDemo> {
  bool _strict = false;

  @override
  Widget build(BuildContext context) {
    final checks = <(String, String, bool)>[
      (
        'Date',
        '2023-13-01',
        _strict ? isISO8601Date('2023-13-01') : isDate('2023-13-01'),
      ),
      ('JWT', 'aaa.bbb.', isJWT('aaa.bbb.', strict: _strict)),
      ('Base32', 'ABC', isBase32('ABC', strict: _strict)),
      (
        'Credit card',
        '0000000000000000',
        isCreditCard('0000000000000000', strict: _strict),
      ),
    ];

    return _DemoPage(
      title: 'Strict versus permissive',
      description:
          'Compatibility mode preserves 1.2 behavior. Strict checks are opt-in.',
      children: [
        SwitchListTile(
          key: const Key('strict-switch'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Strict validation'),
          value: _strict,
          onChanged: (value) => setState(() => _strict = value),
        ),
        for (final check in checks)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(check.$1),
            subtitle: Text(check.$2),
            trailing: Text(check.$3 ? 'Accepted' : 'Rejected'),
          ),
      ],
    );
  }
}

class SanitizerDemo extends StatefulWidget {
  const SanitizerDemo({super.key});

  @override
  State<SanitizerDemo> createState() => _SanitizerDemoState();
}

class _SanitizerDemoState extends State<SanitizerDemo> {
  final _controller = TextEditingController(
    text: '  Test.User+news@GMAIL.com  ',
  );
  String _before = '';
  String _after = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoPage(
      title: 'Sanitization pipeline',
      description:
          'Sanitizers transform input. Validate the transformed value afterward.',
      children: [
        TextField(
          key: const Key('sanitizer-input'),
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Raw email'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('sanitizer-run'),
          onPressed: () {
            final before = _controller.text;
            final after = normalizeEmail(trim(before)) ?? 'Invalid email';
            setState(() {
              _before = before;
              _after = after;
            });
          },
          child: const Text('Run sanitizer'),
        ),
        const SizedBox(height: 16),
        SelectableText('Before: $_before'),
        SelectableText('After: $_after'),
      ],
    );
  }
}

class MessageDemo extends StatefulWidget {
  const MessageDemo({super.key});

  @override
  State<MessageDemo> createState() => _MessageDemoState();
}

class _MessageDemoState extends State<MessageDemo> {
  final _formKey = GlobalKey<FormState>();
  bool _spanish = false;
  String _result = 'Switch locale, then validate the same field.';

  @override
  void dispose() {
    Validator.resetMessageResolver();
    super.dispose();
  }

  void _configureResolver() {
    Validator.messageResolver = (message) {
      if (!_spanish) return message.fallback;
      const spanish = {
        'required': 'Este campo es obligatorio',
        'email': 'Introduce un correo válido',
      };
      return spanish[message.key] ?? message.fallback;
    };
  }

  @override
  Widget build(BuildContext context) {
    return _DemoPage(
      title: 'Message resolver',
      description:
          'Applications own localization. Explicit errorMessage values still win.',
      children: [
        SwitchListTile(
          key: const Key('message-locale'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Spanish messages'),
          value: _spanish,
          onChanged: (value) => setState(() => _spanish = value),
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            key: const Key('message-email'),
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validator.required().and(Validator.email()),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('message-submit'),
          onPressed: () {
            _configureResolver();
            final valid = _formKey.currentState!.validate();
            setState(() {
              _result = valid ? 'Email is valid' : 'Resolver returned an error';
            });
          },
          child: const Text('Validate message'),
        ),
        _ResultText(_result),
      ],
    );
  }
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _ResultText extends StatelessWidget {
  const _ResultText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        value,
        key: ValueKey(value),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
