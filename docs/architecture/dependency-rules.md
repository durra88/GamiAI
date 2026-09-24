# Dependency rules

These rules apply to every package in the workspace, including packages added after phase 0.

## Public API

- A package's public API is its barrel file. For this phase that is `package:core/core.dart`.
- No package may import or export another package's implementation library. This pattern is forbidden:

```dart
import 'package:core/src/domain/failure.dart';
```

- Imports of `package:<same-package>/src/...` from inside that package are allowed. Imports of `package:<other-package>/src/...` are not.
- `tool/verify_architecture.dart` fails the build when it finds a cross-package `src/` import. `dart run melos run verify` runs that script last.

## Layering inside `core`

| Layer | May depend on | Must not depend on |
| --- | --- | --- |
| Domain (`lib/src/domain/`) | Dart core libraries, `equatable` | Flutter, Dio, `json_annotation`, `flutter_secure_storage`, widgets, ARB generated code |
| Network | Domain, Dio | Feature packages, the app |
| Storage | Domain | Feature packages, the app |
| Localization and design system | Domain, Flutter | Feature packages, the app |

The architecture script enforces the domain import ban for `package:flutter`, `package:dio`, and `package:json_annotation`.

Domain types expose `FailureCode`, not English sentences. The presentation layer localizes with `failureMessage`.

## Package graph

- `core` must not depend on feature packages (`auth`, `organizations`, or similar) or on the app.
- Feature packages may depend on `core`.
- Dependencies are one-way. Cycles are not allowed.
- The app shell is the only composition root. It constructs `SecureTokenStorage`, reads `EnvironmentConfig.fromDefines()`, and passes token and organization callbacks into `createDio`. Feature packages do not create their own `Dio` instances with a different base URL or interceptor stack.

## Other constraints

- Do not add `dartz` or another `Either` type. Use `Result<T>`.
- `technicalDetails` is for logs and diagnostics. Do not render it in widgets.
- New shared types that every feature needs belong in `core` and must be exported from `core.dart`. Feature-specific types stay in that feature.
