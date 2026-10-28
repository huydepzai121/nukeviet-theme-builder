#!/usr/bin/env bash
# Zip a theme from site/themes/<name> into backups/theme-<name>.zip
set -euo pipefail
NAME=${1:?usage: theme-zip.sh <theme-name>}
cd "$(dirname "$0")/.."
[ -d "site/themes/$NAME" ] || { echo "missing site/themes/$NAME"; exit 1; }
mkdir -p backups
if docker compose version >/dev/null 2>&1; then DC=(docker compose); else DC=(docker-compose); fi
# zip inside php container (has no zip by default) — use tar via php image or host
if command -v zip >/dev/null 2>&1; then
  (cd site/themes && zip -qr "../../backups/theme-${NAME}.zip" "$NAME")
else
  "${DC[@]}" exec -T php sh -c "cd /var/www/html/themes && tar cf - $NAME" | gzip > "backups/theme-${NAME}.tar.gz"
  echo "(zip not on host — wrote backups/theme-${NAME}.tar.gz)"
  exit 0
fi
echo "Wrote backups/theme-${NAME}.zip"
echo "NOTE: also ship uploads/ and a SQL backup; theme zip alone has no images/DB."
