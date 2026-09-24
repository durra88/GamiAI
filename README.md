# GamiAI

Recruitment platform monorepo. Phase 0 contains the workspace tooling, the `core` package, and a runnable app shell.

## Requirements

- Flutter 3.47.5 (stable) or newer on the 3.47 line
- Dart 3.13.4, bundled with that Flutter SDK

```sh
flutter channel stable
flutter upgrade
```

## Workspace

| Path | Role |
| --- | --- |
| `packages/core` | Shared kernel: failures, HTTP, tokens, l10n, design system |
| `app/` | Flutter app shell |
| `docs/architecture` | Dependency rules |
| `tool/verify_architecture.dart` | Fails if a package imports another package's `src/` |

Melos 8 keeps scripts in the root `pubspec.yaml` under `melos:`.

## Scripts

```sh
dart run melos bootstrap
dart run melos run analyze
dart run melos run test
dart run melos run format
dart run melos run generate
dart run melos run verify
```

`verify` runs a format check, analyzer, tests, and the architecture script, and stops at the first failure.

## API configuration

`EnvironmentConfig.fromDefines()` reads compile-time defines:

- `APP_ENV` — `dev` (default), `staging`, or `prod`
- `API_BASE_URL` — default `http://localhost:8080`

```sh
flutter run \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://api.example.com
```

Logging is enabled only when `APP_ENV` is not `prod`, and `Authorization` values are redacted.

## Dependency rules

See [docs/architecture/dependency-rules.md](docs/architecture/dependency-rules.md). Import `package:core/core.dart` only. Do not import `package:core/src/...`.
