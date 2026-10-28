#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Prefer clearing inside container (correct ownership)
if docker compose version >/dev/null 2>&1; then DC=(docker compose); else DC=(docker-compose); fi
"${DC[@]}" exec -T php sh -c 'find /var/www/html/data/cache -type f ! -name index.html -delete 2>/dev/null; echo cache cleared'
