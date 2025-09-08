#!/usr/bin/env bash
set -euo pipefail

echo "▶ Medusa bootstrap starting…"

# Show envs safely (optional)
REDACTED_DB_URL="${DATABASE_URL//:*@/:****@}"
echo "• NODE_ENV=${NODE_ENV:-}"
echo "• DATABASE_URL=${REDACTED_DB_URL}"
echo "• REDIS_URL=${REDIS_URL:-<unset>}"

# Wait for Postgres
host_port="$(echo "$DATABASE_URL" | sed -E 's,^.*://[^@]*@([^/:]+):?([0-9]+)?.*,\1 \2,')"
DB_HOST="$(echo "$host_port" | awk '{print $1}')"
DB_PORT="$(echo "$host_port" | awk '{print $2}')"
DB_PORT="${DB_PORT:-5432}"

echo "• Waiting for Postgres at ${DB_HOST}:${DB_PORT} ..."
for i in {1..60}; do
  if (echo >"/dev/tcp/${DB_HOST}/${DB_PORT}") >/dev/null 2>&1; then
    echo "✓ Postgres is reachable"
    break
  fi
  echo "  Postgres not up yet (${i}/60). Sleeping 1s..."
  sleep 1
done

echo "• Running migrations..."
set -x
yarn migrate
set +x
echo "✓ Migrations completed"

echo "• Starting Medusa..."
exec yarn start
