---
name: nukeviet-theme-builder
description: >
  Install NukeViet 4.6 via Docker Compose and build a custom theme.
  Three modes: (1) scrape real content from an official website;
  (2) design from scratch (org name + sector + style/colors) with a design
  brief then sample content marked as placeholder; (3) restyle from
  screenshots/Figma/Base44. ALWAYS use Docker — never host php -S unless
  the user explicitly asks for native PHP. Use when asked for a NukeViet
  site/theme, university/company portal, or to design a NukeViet site.
---

# NukeViet 4.6 theme builder (Docker)

Goal: a running NukeViet 4.6 site with custom theme `<theme>`, content, backups, screenshots.

## 0. Runtime — Docker only (do this before anything else)

1. Run `docker compose version` (or `docker-compose version`).
2. **If missing or Docker daemon unreachable:** STOP. Tell the user to install **Docker Desktop** (Windows/macOS, enable WSL2 backend on Windows) or Docker Engine + Compose plugin (Linux). Do **not** install PHP/MariaDB on the host. Do **not** run `php -S`. Do **not** create a messy mix of `nvzip/`, `server.txt`, host `credentials.txt`.
3. Native `php -S` / host PHP is allowed **only** if the user explicitly asks for a non-Docker fallback.

Windows (Claude Code / PowerShell): prefer `docker compose …` commands; run shell helpers via `bash docker/setup.sh` inside WSL or Git Bash. Line endings: keep scripts LF (`git config core.autocrlf false` in the project). Bind mounts work with Docker Desktop; if `site/data` is not writable, run once:
`docker compose exec php chown -R www-data:www-data /var/www/html/data /var/www/html/uploads`

## 0b. Mode selection

| Mode | Trigger | Content |
|------|---------|---------|
| **A. Scrape** | Official URL / “dữ liệu thật” | Real articles/images/pages; never invent facts |
| **B. Scratch** | Org + sector + style; `/nukeviet-design` or `--scratch` | Sample content marked demo; placeholders `[Địa chỉ]`, `[Số điện thoại]`, `[Email]` |
| **C. From design** | Screenshots / Figma / Base44 | Match design; gaps → Mode B rules |

Ask: org name, theme machine name (`[a-z0-9_]`), colors/logo (or style for B), target pages. Mode B also: sector, style keywords / hex.

## 1. Project layout (keep it clean)

Create **one** project directory. Do not dump installer zips, php logs, or scratch JSON at the root beyond this tree:

```
<project>/
  docker-compose.yml
  .env                 # secrets ONLY here (chmod 600, gitignored) — never credentials.txt
  .gitignore
  docker/
    Dockerfile         # php 8.2-fpm + mysqli pdo_mysql gd zip intl mbstring curl opcache
    nginx.conf         # NukeViet rewrites so /admin/ works
    setup.sh backup.sh restore.sh cache-clear.sh theme-zip.sh shot.sh
  site/                # NukeViet webroot (bind mount) — do not commit
  backups/             # *.sql + theme-*.zip
  .work/               # scratch, scrape JSON, screenshots — do not commit
    scratch/ scrape/ shots/
```

Bootstrap from the plugin:
```bash
PROJECT_DIR=/path/to/project AUTO_INSTALL=1 bash <plugin>/skills/nukeviet-theme-builder/scripts/docker/setup.sh
```
Or copy `scripts/docker/*` into the project and run `./docker/setup.sh`.

`setup.sh` will: check Docker → write layout → generate `.env` (random passwords, **never printed**) → download NukeViet 4.6.02 official zip into `site/` → `docker compose up -d --build` → optional curl installer (`AUTO_INSTALL=1`) → delete `site/install/`.

Browser install alternative: open `http://localhost:8080/install/` (DB host = `db`, user/pass from `.env`), then `rm -rf site/install`.

## 2. Day-to-day Docker commands

```bash
docker compose --env-file .env up -d          # start
docker compose ps
docker compose logs -f nginx php
./docker/backup.sh                            # → backups/nv-*.sql
./docker/restore.sh backups/nv-….sql
./docker/cache-clear.sh
./docker/theme-zip.sh <theme>
./docker/shot.sh                              # Playwright container → .work/shots/
docker compose --profile tools up -d          # optional Adminer on :8081
docker compose down                           # stop
docker compose down -v                        # stop + delete DB volume (destructive)
```

Seed / PHP one-offs: `docker compose exec -T php php /var/www/html/../` is wrong — put scripts in `.work/` and run:
`docker compose exec -T -e DB_NAME -e DB_USER -e DB_PASS php php /var/www/html/../` — better: mount is only `site/`, so copy `seed_template.php` into `.work/` and:
`docker compose exec -T php php -r '…'` or run seed **from host Python/PHP talking to `localhost:HTTP` only for HTTP**; for DB seeding use:
`docker compose exec -T db mariadb -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < …`  
or copy seed into `site/` temporarily:
`docker compose cp .work/seed_template.php php:/var/www/html/_seed.php && docker compose exec -T -e DB_NAME=… php php /var/www/html/_seed.php && docker compose exec php rm /var/www/html/_seed.php`

DB host **inside** the network is `db` (not `localhost`). HTTP from host: `http://localhost:${HTTP_PORT}`.

## 3. Theme
1. `cp -r site/themes/default site/themes/<theme>`. **Never edit `themes/default`.**
2. Edit `config.ini`, `layout/header_extended.tpl` / `footer_extended.tpl`, `css/custom.css`, `js/custom.js`. See `references/theme-structure.md`, `xtemplate-cheatsheet.md`, `design-system.md`.
3. Homepage: in `theme.php` → `nv_site_theme()`, before `$xtpl->parse('main')`, query modules when `$home`. Example: `examples/vimaru/theme-home-snippet.php`.
4. Activate: set `site_theme` in DB; copy `modthemes` + `blocks_groups/_weight` from `default` (seed template).

## 4. Content

### Mode A — Scrape
Use `scripts/scrape_template.py` → write JSON under `.work/scrape/`. Download images to `site/uploads/news/<slug>/`. Source links on every article. Seed with `scripts/seed_template.php` (env from `.env`; DB host=`db` when run inside compose). Clear cache via `./docker/cache-clear.sh`.

### Mode B — Scratch
1. Write `.work/design-brief.md` (palette, type, sections) **before** coding.
2. Build theme from the brief (CSS variables, SVG/CSS heroes preferred).
3. `ORG_NAME=… SECTOR=… SLUG=… OUT=.work/scrape python3 scripts/generate_sample_content.py`
4. Seed; visible “nội dung mẫu”; placeholders for contact; `ATTRIBUTION.md` if using Unsplash/Pexels.
5. Deliver brief + zip + SQL.

### Mode C — From design files
Match design assets; gaps follow Mode B rules.

## 5. Verify & deliver
1. `./docker/backup.sh` before big changes and at the end.
2. `curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/` and `/admin/` → 200.
3. Screenshots: `./docker/shot.sh` (Playwright image) or host browser if available.
4. `./docker/theme-zip.sh <theme>`; remind user to ship `site/uploads/` + SQL (or whole `site/` + dump).
5. Report URL, real vs sample, that secrets live in `.env` (do not print them).

Gotchas: `references/gotchas.md`.
