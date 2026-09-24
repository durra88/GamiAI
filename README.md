# GamiAI

Phase 0 is the architecture skeleton: a Flutter workspace, a FastAPI app with `GET /health`, and checks that packages and modules do not import each other's internals.

## Requirements

- Flutter 3.47.5 (stable), Dart 3.13.4
- Python 3.14

## Layout

| Path | Role |
| --- | --- |
| `flutter_app/` | Melos workspace: `app` shell and `packages/core` |
| `backend/` | FastAPI application |
| `infrastructure/docker-compose.yml` | Postgres and Redis |
| `docs/architecture/` | Overview and dependency rules |

## Commands

```sh
make setup
make verify
make verify-flutter
make verify-backend
```

`make setup` runs `dart pub get` in `flutter_app/` and installs the backend into `backend/.venv`. `make verify` runs the Flutter format check, analyzer, and architecture script, then the backend architecture script and pytest.
