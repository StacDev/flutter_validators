# Releasing 1.3

## Release Candidate

1. Confirm formatting, analysis, package tests, example widget tests, 95% line
   coverage, API docs, pure Dart smoke test, and pub dry-run all pass.
2. Set the version to `1.3.0-rc.1`.
3. Publish the candidate and validate it from new pure Dart and Flutter apps.
4. Announce the candidate with links to the README, strict-validation guide,
   migration guide, and example application.
5. Keep the candidate open for seven days. Accept only correctness,
   compatibility, documentation, and release-blocking fixes.

## Stable Release

1. Set the version to `1.3.0` and rerun every release-quality check.
2. Publish to pub.dev.
3. Tag the commit as `v1.3.0`.
4. Create a GitHub release using the 1.3 changelog, migration notes, strict-mode
   warnings, and links to the runnable examples.
5. Monitor issues and documentation feedback for 14 days.

No release should remove a 1.2 symbol, enable strict behavior by default, add a
runtime dependency, or publish with broken documentation snippets.
