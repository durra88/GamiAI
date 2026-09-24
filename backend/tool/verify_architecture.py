"""Fail when one module imports another module's internals.

A module's public surface is ``app.modules.<name>`` and
``app.modules.<name>.service``. Anything deeper is internal.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULES = ROOT / "app" / "modules"

_FROM_IMPORT = re.compile(
    r"^\s*from\s+(app\.modules\.([A-Za-z0-9_]+)(?:\.([A-Za-z0-9_.]+))?)\s+import\b"
)
_IMPORT = re.compile(
    r"^\s*import\s+(app\.modules\.([A-Za-z0-9_]+)(?:\.([A-Za-z0-9_.]+))?)\b"
)


def main() -> None:
    violations: list[str] = []
    if not MODULES.is_dir():
        print("Architecture checks passed.")
        return

    for module_dir in sorted(path for path in MODULES.iterdir() if path.is_dir()):
        module_name = module_dir.name
        for source in module_dir.rglob("*.py"):
            for line_number, line in enumerate(
                source.read_text(encoding="utf-8").splitlines(),
                start=1,
            ):
                match = _FROM_IMPORT.match(line) or _IMPORT.match(line)
                if match is None:
                    continue
                imported_module = match.group(2)
                remainder = match.group(3)
                if imported_module == module_name:
                    continue
                if remainder is None or remainder == "service" or remainder.startswith(
                    "service."
                ):
                    continue
                relative = source.relative_to(ROOT)
                violations.append(
                    f"{relative}:{line_number} imports {match.group(1)}. "
                    f"Use app.modules.{imported_module}.service instead."
                )

    if violations:
        print("Architecture check failed:", file=sys.stderr)
        for violation in violations:
            print(f"- {violation}", file=sys.stderr)
        sys.exit(1)

    print("Architecture checks passed.")


if __name__ == "__main__":
    main()
