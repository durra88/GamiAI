# Contributing

## Setup

1. Install Flutter 3.47.5 stable or a newer 3.47 patch (Dart 3.13.4).
2. From the repository root, run `dart run melos bootstrap`.

## Before opening a pull request

Run `dart run melos run verify`. It fails fast, in this order:

1. `dart format --set-exit-if-changed .`
2. `melos run analyze`
3. `melos run test`
4. `dart tool/verify_architecture.dart`

`dart run melos run format` rewrites formatting. `dart run melos run generate` regenerates localizations after ARB edits. Commit the generated files under `packages/core/lib/src/l10n/generated/`.

## Architecture

Read [docs/architecture/overview.md](docs/architecture/overview.md) and [docs/architecture/dependency-rules.md](docs/architecture/dependency-rules.md).

- Depend on `core` through `package:core/core.dart`.
- Do not import another package's `src/` directory.
- Keep domain types free of Flutter, Dio, and `json_annotation`.
- Do not add feature packages as dependencies of `core`.

Phase 0 stops at `core`. Authentication, organizations, and the app shell are later phases.
