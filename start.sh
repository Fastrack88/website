#!/usr/bin/env bash
set -euo pipefail

echo "▶ Medusa bootstrap starting…"

# (wait-for-Postgres block you already have)

echo "• Running migrations..."
set -x
yarn migrate
set +x
echo "✓ Migrations completed"

echo "• Starting Medusa..."
exec yarn start
