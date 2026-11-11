"""Run with: python3 scripts/test_pgservicedburi.py /path/to/bin/pgservicedburi."""

import subprocess
import sys
import tempfile
from pathlib import Path

with tempfile.TemporaryDirectory() as directory:
    config = Path(directory) / "pg_service.conf"
    config.write_text(
        "[example]\n"
        "dbname=app/db\n"
        "user=alice@example\n"
        "password=p@ss\n"
        "host=::1\n"
        "port=5432\n"
        "sslmode=require\n"
        "[invalid]\n"
        "host=localhost\n"
    )

    def run(service, path=config):
        return subprocess.run(
            [sys.argv[1], service, "--config-file", str(path)],
            capture_output=True,
            text=True,
            check=False,
        )

    result = run("example")
    assert result.returncode == 0, result.stderr
    assert result.stdout.strip() == (
        "postgresql://alice%40example:p%40ss@[::1]:5432/app%2Fdb?sslmode=require"
    ), result.stdout
    assert run("missing").returncode == 2
    assert run("example", Path(directory) / "missing.conf").returncode == 3
    assert run("invalid").returncode == 4

print("pgservicedburi checks passed")
