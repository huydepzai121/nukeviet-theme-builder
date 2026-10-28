#!/usr/bin/env bash
# mysqldump via docker compose → backups/<timestamp>.sql
set -euo pipefail
cd "$(dirname "$0")/.."
if docker compose version >/dev/null 2>&1; then DC=(docker compose); else DC=(docker-compose); fi
set -a; source .env; set +a
mkdir -p backups
OUT="backups/nv-$(date +%Y%m%d-%H%M%S).sql"
"${DC[@]}" exec -T db mariadb-dump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$OUT"
echo "Wrote $OUT"
