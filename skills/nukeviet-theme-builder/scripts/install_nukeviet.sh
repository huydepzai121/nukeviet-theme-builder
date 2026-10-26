#!/usr/bin/env bash
# Generic NukeViet 4.6 installer (Debian/Ubuntu). Usage:
#   WORK=/path/to/work DB=mysite PORT=8090 SITE_NAME="My Site" ADMIN_EMAIL=me@example.com ./install_nukeviet.sh
# Writes credentials to $WORK/credentials.txt (chmod 600). Never echoes passwords.
set -euo pipefail
WORK=${WORK:?set WORK}; DB=${DB:?set DB}; PORT=${PORT:-8090}
SITE_NAME=${SITE_NAME:-NukeViet}; ADMIN_EMAIL=${ADMIN_EMAIL:-admin@example.com}; ADMIN_USER=${ADMIN_USER:-admin}
NV_ZIP_URL=${NV_ZIP_URL:-}   # optional: exact asset URL from https://github.com/nukeviet/nukeviet/releases
HERE=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$WORK"; cd "$WORK"

if ! command -v php >/dev/null || ! command -v mariadb >/dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y php-cli php-mysql php-gd php-curl php-mbstring php-xml php-zip php-intl mariadb-server unzip curl
fi
(sudo service mariadb start || sudo mysqld_safe --user=mysql >/dev/null 2>&1 &) ; sleep 3

umask 077
DBPASS=$(openssl rand -base64 18 | tr -dc 'A-Za-z0-9' | head -c 20)
ADMINPASS="$(openssl rand -base64 18 | tr -dc 'A-Za-z0-9' | head -c 14)Aa1!"
sudo mariadb -e "CREATE DATABASE IF NOT EXISTS \`$DB\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB'@'localhost' IDENTIFIED BY '$DBPASS'; ALTER USER '$DB'@'localhost' IDENTIFIED BY '$DBPASS';
GRANT ALL ON \`$DB\`.* TO '$DB'@'localhost'; FLUSH PRIVILEGES;"
printf 'admin_user=%s\nadmin_pass=%s\ndb_name=%s\ndb_user=%s\ndb_pass=%s\n' "$ADMIN_USER" "$ADMINPASS" "$DB" "$DB" "$DBPASS" > credentials.txt
chmod 600 credentials.txt; umask 022

if [ ! -f site/index.php ]; then
  if [ -z "$NV_ZIP_URL" ]; then
    NV_ZIP_URL=$(curl -s https://api.github.com/repos/nukeviet/nukeviet/releases | grep -o 'https://[^"]*4\.6[^"]*\.zip' | head -1)
  fi
  curl -L -o nukeviet.zip "$NV_ZIP_URL"; mkdir -p nvzip site; unzip -qo nukeviet.zip -d nvzip
  SRC=$(dirname "$(find nvzip -name mainfile.php | head -1)"); cp -a "$SRC"/. site/
fi
chmod -R u+rwX site
nohup env NV_ROOT="$WORK/site" php -S 0.0.0.0:$PORT "$HERE/router.php" > server.log 2>&1 &
sleep 2
B="http://localhost:$PORT/install/index.php"; J=cookies.txt
c(){ curl -s -b $J -c $J "$@" -o /dev/null -w '%{http_code} '; }
# Steps of the NukeViet web installer. Field names verified on 4.6; if a step fails,
# fetch it with `curl -b $J "$B?step=N"` and adjust the -d fields.
c "$B?lang=vi"; c "$B?step=1"; c -d "step=2&lang=vi" "$B?step=2"; c "$B?step=3"; c "$B?step=4"
c -d "dbhost=localhost&dbport=&dbname=$DB&dbuname=$DB&dbpass=$DBPASS&prefix=nv4&db_detete=1&lang_multi=0&tetx=1" "$B?step=5"
c -d "site_name=$SITE_NAME&nv_login=$ADMIN_USER&nv_email=$ADMIN_EMAIL&nv_password=$ADMINPASS&re_password=$ADMINPASS&question=q&answer_question=a&lang_multi=0&dev_mode=0&submit=1" "$B?step=6"
c "$B?step=7"; echo
if [ -f site/config.php ]; then rm -rf site/install; echo "Installed. Credentials in $WORK/credentials.txt (chmod 600)."; else echo "Installer did not finish: complete it at $B, then delete site/install."; fi
