#!/usr/bin/env bash
# Restore SQL dump: ./docker/restore.sh backups/foo.sql
set -euo pipefail
FILE=${1:?usage: restore.sh backups/file.sql}
cd "$(dirname "$0")/.."
if docker compose version >/dev/null 2>&1; then DC=(docker compose); else DC=(docker-compose); fi
set -a; source .env; set +a
"${DC[@]}" exec -T db mariadb -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$FILE"
echo "Restored $FILE"
