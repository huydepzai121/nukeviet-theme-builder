#!/usr/bin/env bash
# Bootstrap a clean NukeViet 4.6 Docker project.
# Run from an empty (or new) project directory, OR pass PROJECT_DIR=.
# Requires: docker compose (Docker Desktop / Docker Engine + Compose v2).
# NEVER runs host php -S. NEVER installs PHP on the host.
set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
need_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    die "Docker not found. Install Docker Desktop (Windows/macOS) or Docker Engine + Compose (Linux), then re-run.
  Windows: https://docs.docker.com/desktop/setup/install/windows-install/
  macOS:   https://docs.docker.com/desktop/setup/install/mac-install/
  Linux:   https://docs.docker.com/engine/install/"
  fi
  if docker compose version >/dev/null 2>&1; then
    DC=(docker compose)
  elif command -v docker-compose >/dev/null 2>&1; then
    DC=(docker-compose)
  else
    die "Docker Compose not found. Install Docker Desktop (includes Compose) or the compose plugin, then re-run.
  Check with: docker compose version"
  fi
}

PROJECT_DIR=${PROJECT_DIR:-.}
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PLUGIN_DOCKER="$SCRIPT_DIR"   # this file lives in scripts/docker/
HTTP_PORT=${HTTP_PORT:-8080}
NV_ZIP_URL=${NV_ZIP_URL:-https://github.com/nukeviet/nukeviet/releases/download/4.6.02/nukeviet4.6.02setup.zip}

need_docker
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
PROJECT_DIR=$(pwd)

# Clean layout
mkdir -p docker site backups .work/{scratch,scrape,shots}
cp -f "$PLUGIN_DOCKER/Dockerfile" docker/Dockerfile
cp -f "$PLUGIN_DOCKER/nginx.conf" docker/nginx.conf
cp -f "$PLUGIN_DOCKER"/backup.sh "$PLUGIN_DOCKER"/restore.sh "$PLUGIN_DOCKER"/cache-clear.sh "$PLUGIN_DOCKER"/theme-zip.sh "$PLUGIN_DOCKER"/shot.sh "$PLUGIN_DOCKER"/setup.sh docker/
chmod +x docker/*.sh
cp -f "$PLUGIN_DOCKER/docker-compose.yml" docker-compose.yml
# merge gitignore
if [ -f "$PLUGIN_DOCKER/gitignore.fragment" ]; then
  touch .gitignore
  while IFS= read -r line; do
    grep -qxF "$line" .gitignore 2>/dev/null || echo "$line" >> .gitignore
  done < "$PLUGIN_DOCKER/gitignore.fragment"
fi

# Generate .env once (never print secrets)
if [ ! -f .env ]; then
  umask 077
  rand() { openssl rand -base64 24 | tr -dc 'A-Za-z0-9' | head -c 20; }
  ADMIN_PASS="$(rand)Aa1!"
  cat > .env <<EOF
HTTP_PORT=${HTTP_PORT}
ADMINER_PORT=8081
DB_NAME=nukeviet
DB_USER=nukeviet
DB_PASS=$(rand)
DB_ROOT_PASS=$(rand)
NV_SITE_NAME=${NV_SITE_NAME:-NukeViet Site}
NV_ADMIN_USER=${NV_ADMIN_USER:-admin}
NV_ADMIN_EMAIL=${NV_ADMIN_EMAIL:-admin@example.com}
NV_ADMIN_PASS=${ADMIN_PASS}
NV_LANG=${NV_LANG:-vi}
EOF
  chmod 600 .env
  umask 022
  echo "Wrote .env (chmod 600). Passwords are NOT printed — open .env locally if needed."
else
  echo ".env already exists — keeping it."
fi
# shellcheck disable=SC1091
set -a; source .env; set +a

# Download NukeViet into ./site if missing
if [ ! -f site/index.php ]; then
  echo "Downloading NukeViet 4.6 …"
  curl -fsSL -o .work/nukeviet.zip "$NV_ZIP_URL"
  rm -rf .work/nvzip; mkdir -p .work/nvzip
  unzip -qo .work/nukeviet.zip -d .work/nvzip
  SRC=$(dirname "$(find .work/nvzip -name mainfile.php | head -1)")
  [ -n "$SRC" ] || die "mainfile.php not found in zip"
  # clear any leftover index.html from empty mount
  rm -rf site/* site/.[!.]* 2>/dev/null || true
  cp -a "$SRC"/. site/
  echo "NukeViet extracted to ./site"
fi

# Permissions: www-data in php image is usually uid 33
if command -v id >/dev/null && [ "$(id -u)" -eq 0 ]; then
  chown -R 33:33 site || true
else
  # Make writable for container uid (Windows bind mounts ignore chmod; Linux needs it)
  chmod -R u+rwX,go+rX site 2>/dev/null || true
  chmod -R a+rwX site/data site/uploads site/assets/css 2>/dev/null || true
fi

echo "Starting docker compose …"
"${DC[@]}" --env-file .env up -d --build
echo "Waiting for db healthy …"
for i in $(seq 1 60); do
  st=$("${DC[@]}" ps --format json 2>/dev/null | grep -o '"Health":"[^"]*"' | head -1 || true)
  "${DC[@]}" exec -T db healthcheck.sh --connect --innodb_initialized >/dev/null 2>&1 && break
  sleep 2
done

BASE="http://localhost:${HTTP_PORT}"
echo "Stack up. Site: $BASE  Admin later: $BASE/admin/"

# Optional curl-scripted installer (set AUTO_INSTALL=1)
if [ "${AUTO_INSTALL:-0}" = "1" ]; then
  echo "Running curl installer …"
  J=.work/cookies.txt; rm -f "$J"
  c(){ curl -s -b "$J" -c "$J" "$@" -o /dev/null -w '%{http_code} '; }
  B="$BASE/install/index.php"
  # Wait for nginx/php
  for i in $(seq 1 30); do curl -fsS "$BASE/install/" >/dev/null 2>&1 && break; sleep 2; done
  c "$B?lang=${NV_LANG}"; c "$B?step=1"; c -d "step=2&lang=${NV_LANG}" "$B?step=2"
  c "$B?step=3"; c "$B?step=4"
  c -d "dbhost=db&dbport=&dbname=${DB_NAME}&dbuname=${DB_USER}&dbpass=${DB_PASS}&prefix=nv4&db_detete=1&lang_multi=0" "$B?step=5"
  c --data-urlencode "site_name=${NV_SITE_NAME}" \
    --data-urlencode "nv_login=${NV_ADMIN_USER}" \
    --data-urlencode "nv_email=${NV_ADMIN_EMAIL}" \
    --data-urlencode "nv_password=${NV_ADMIN_PASS}" \
    --data-urlencode "re_password=${NV_ADMIN_PASS}" \
    -d "question=q&answer_question=a&lang_multi=0&dev_mode=0&submit=1" "$B?step=6"
  c "$B?step=7"; echo
  if [ -f site/config.php ] || [ -f site/data/config/config_global.php ]; then
    rm -rf site/install
    # Ensure rewrite flag for nginx
    if [ -f site/data/config/config_global.php ]; then
      sed -i "s/\$sys_info\['supports_rewrite'\] *= *false/\$sys_info['supports_rewrite']='rewrite_mode_apache'/" site/data/config/config_global.php 2>/dev/null || true
    fi
    echo "Installed. Deleted site/install/. Credentials are in .env only."
  else
    echo "AUTO_INSTALL did not finish. Open $BASE/install/ in a browser, then:"
    echo "  rm -rf site/install"
  fi
else
  echo "Open $BASE/install/ in a browser to finish setup."
  echo "DB host inside Docker: db   |  DB name/user/pass: see .env"
  echo "When done:  rm -rf site/install"
  echo "Or re-run with AUTO_INSTALL=1 $0"
fi

echo "Helpers:  ./docker/backup.sh | ./docker/restore.sh FILE | ./docker/cache-clear.sh | ./docker/theme-zip.sh NAME"
