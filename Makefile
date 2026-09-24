.PHONY: setup verify verify-flutter verify-backend

setup:
	cd flutter_app && dart pub get && dart run melos bootstrap
	cd backend && python3 -m venv .venv && .venv/bin/pip install -e ".[dev]"

verify: verify-flutter verify-backend

verify-flutter:
	cd flutter_app && dart run melos run verify

verify-backend:
	cd backend && .venv/bin/python tool/verify_architecture.py && .venv/bin/pytest
