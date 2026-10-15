"""Apply migrations and run SQL checks on a disposable PostgreSQL database.

Requires psql on PATH and PGHOST/PGPORT/PGDATABASE/PGUSER/PGPASSWORD as needed.
Use --bootstrap-roles only for a fresh vanilla PostgreSQL database, not Supabase.
"""

import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bootstrap-roles", action="store_true")
    args = parser.parse_args()
    psql = shutil.which("psql")
    if psql is None:
        parser.error("psql is required; install the PostgreSQL client or run database CI")

    root = Path(__file__).resolve().parents[1]
    migration_dir = root / "supabase" / "migrations"
    migrations = sorted(path for path in migration_dir.iterdir() if path.suffix == ".sql")
    if not migrations:
        parser.error("No migration files found")
    for path in migrations:
        if not re.fullmatch(r"\d{14}_[a-z0-9_]+\.sql", path.name):
            parser.error(f"Invalid migration filename: {path.name}")

    def run_sql(path: Path, *, atomic: bool = True) -> None:
        print(f"Running {path.relative_to(root).as_posix()}", flush=True)
        command = [psql, "--no-psqlrc", "--set=ON_ERROR_STOP=1"]
        if atomic:
            command.append("--single-transaction")
        subprocess.run([*command, "--file", str(path)], check=True, cwd=root)

    try:
        if args.bootstrap_roles:
            run_sql(root / "supabase" / "tests" / "bootstrap_roles.sql")
        for migration in migrations:
            run_sql(migration)
        run_sql(root / "supabase" / "tests" / "schema_smoke.sql", atomic=False)
    except subprocess.CalledProcessError as error:
        return error.returncode
    print("Database migration, CRUD, constraint, and access checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
