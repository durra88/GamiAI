# Dependency rules

These rules apply to the Flutter workspace and the FastAPI app. `flutter_app/tool/verify_architecture.dart` and `backend/tool/verify_architecture.py` enforce the import rules below.

## Flutter packages

- A package's public API is its barrel file. For this phase that is `package:core/core.dart`.
- No package may import or export another package's `src/` library. This is forbidden:

```dart
import 'package:core/src/domain/failure.dart';
```

- A package may import its own `package:<same-package>/src/...` files. That is how `core.dart` re-exports its implementation.
- `core` must not depend on feature packages or on the app. Feature packages may depend on `core`. Dependencies are one-way.
- The Flutter domain layer (`packages/core/lib/src/domain/`) may use the Dart core libraries only. It must not import Flutter or Dio.

## Backend modules

- Each module under `backend/app/modules/<name>/` owns its models, repositories, and routers.
- Another module may import only that module's package root (`app.modules.<name>`) or its public service module (`app.modules.<name>.service`).
- Importing another module's models, repositories, schemas, or routers is an internal import and fails the architecture check.
- `app/core` is shared infrastructure. Modules may depend on `app/core`. `app/core` must not depend on a feature module.
- Modules talk to each other by calling public service functions, not by reaching into another module's tables or private helpers.
