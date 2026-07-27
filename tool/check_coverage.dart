import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 2) {
    stderr.writeln('Usage: check_coverage.dart <lcov-file> <minimum-percent>');
    exitCode = 64;
    return;
  }

  final file = File(arguments[0]);
  final minimum = double.tryParse(arguments[1]);
  if (!file.existsSync() || minimum == null) {
    stderr.writeln('Coverage file or minimum percentage is invalid.');
    exitCode = 64;
    return;
  }

  var found = 0;
  var hit = 0;
  for (final line in file.readAsLinesSync()) {
    if (!line.startsWith('DA:')) continue;
    final parts = line.substring(3).split(',');
    if (parts.length != 2) continue;
    found++;
    if (int.parse(parts[1]) > 0) hit++;
  }

  final percentage = found == 0 ? 0.0 : hit * 100 / found;
  stdout.writeln(
    'Line coverage: ${percentage.toStringAsFixed(2)}% ($hit/$found)',
  );
  if (percentage < minimum) {
    stderr.writeln('Required line coverage: ${minimum.toStringAsFixed(2)}%');
    exitCode = 1;
  }
}
