#!/usr/bin/env bash
set -euo pipefail

# Migrate data from a source Postgres to Supabase Postgres using pg_dump/psql.
# Requirements:
# - pg_dump, psql installed
# - Environment variables:
#   SOURCE_DB_URL: postgresql://user:pass@host:port/dbname
#   DATABASE_URL:  Supabase connection string (must include sslmode=require or set DB_SSLMODE=require)
#
# Usage:
#   SOURCE_DB_URL=... DATABASE_URL=... ./scripts/migrate_to_supabase.sh

if ! command -v pg_dump >/dev/null 2>&1; then
  echo "pg_dump is required; please install PostgreSQL client tools." >&2
  exit 1
fi
if ! command -v psql >/dev/null 2>&1; then
  echo "psql is required; please install PostgreSQL client tools." >&2
  exit 1
fi

: "${SOURCE_DB_URL:?Set SOURCE_DB_URL}"
: "${DATABASE_URL:?Set DATABASE_URL}"

# Optional SSL override
DB_SSLMODE=${DB_SSLMODE:-}

TMP_DUMP_FILE=${TMP_DUMP_FILE:-backup_$(date +%Y%m%d_%H%M%S).dump}

echo "==> Dumping from source..."
pg_dump \
  --no-owner --no-privileges \
  --format=custom \
  --file="${TMP_DUMP_FILE}" \
  --dbname="${SOURCE_DB_URL}"

# If DB_SSLMODE is set, append it to DATABASE_URL for restore
TARGET_URL="${DATABASE_URL}"
if [[ -n "$DB_SSLMODE" && "$TARGET_URL" != *"sslmode="* ]]; then
  sep="?"
  [[ "$TARGET_URL" == *"?"* ]] && sep="&"
  TARGET_URL="${TARGET_URL}${sep}sslmode=${DB_SSLMODE}"
fi

echo "==> Restoring into Supabase..."
pg_restore \
  --no-owner --no-privileges \
  --clean --if-exists \
  --dbname="${TARGET_URL}" \
  "${TMP_DUMP_FILE}"

echo "==> Done. You can delete ${TMP_DUMP_FILE} if not needed."
