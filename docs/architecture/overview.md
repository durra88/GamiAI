# Architecture overview

Phase 0 is a skeleton. It wires the Flutter workspace, the FastAPI process, and the dependency checks. Authentication, organizations, jobs, interceptors, and design-system components come later.

## Flutter

```text
app (composition root, later)
  -> feature packages (later)
    -> package:core/core.dart
         domain/   Failure, Result
         network/  DioClient
         storage/  TokenStorage
         l10n/     sample ARB keys
         design/   AppTheme
```

`core` is the shared kernel. Feature packages may depend on it. It must not depend on them. Import `package:core/core.dart`. Do not import another package's `src/` libraries.

## Backend

```text
app/main.py
  -> app/core/          config, database, security, exceptions
  -> app/modules/*      one folder per module; identity is empty
  -> app/ai/providers/  empty
  -> app/infrastructure/ empty
```

`GET /health` is the only route. Modules do not exist yet beyond `identity/__init__.py`. When they do, they call each other through public service functions, not through another module's models or repositories.

## Infrastructure

`infrastructure/docker-compose.yml` starts Postgres and Redis. The API does not connect to them in this phase.
