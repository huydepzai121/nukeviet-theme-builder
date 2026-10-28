# Gotchas

## Docker (default)
- First command: `docker compose version`. If it fails → stop; install Docker Desktop. Do not fall back to `php -S` unless the user explicitly asks.
- Never install PHP/MariaDB on the host for this skill. Never leave `server.txt`, host `credentials.txt`, `nvzip/`, or `nukeviet.zip` in the project root — use `.env`, `site/`, `.work/`.
- DB hostname from PHP containers is `db`, not `localhost`. From the host machine only HTTP ports are exposed (default 8080).
- Secrets only in `.env` (chmod 600, gitignored). Never print or commit them.
- After install, delete `site/install/` or NukeViet keeps warning/redirecting.
- File permissions: PHP-FPM runs as `www-data` (uid 33). If uploads/cache fail on Linux: `docker compose exec php chown -R www-data:www-data /var/www/html/data /var/www/html/uploads`. On Docker Desktop (Windows/macOS) bind mounts usually ignore Unix owners; if writes fail, check Desktop file sharing and that the project is under a shared drive.
- Windows: use PowerShell/`docker compose`; run `*.sh` via WSL or Git Bash (LF line endings). Prefer `docker compose exec` over host PHP scripts.
- `docker compose down -v` deletes the MariaDB volume — irreversible without a backup.
- Adminer: `docker compose --profile tools up -d` → port 8081.
- Screenshots: `./docker/shot.sh` uses the Playwright image and `host.docker.internal` (Linux adds `host-gateway`).

## Theme / NukeViet
- Never edit `themes/default` (fallback for missing tpls).
- New theme needs `nv4_*_modthemes` + `blocks_groups/_weight` rows copied from `default`.
- Positions in layouts must exist in `config.ini`.
- News rows must also be inserted into `nv4_*_news_<catid>` or category pages are empty.
- `homeimgfile` is relative to `uploads/news/`; `homeimgthumb=2` = original file.
- Clear `data/cache/*` after DB edits (`./docker/cache-clear.sh`).
- Theme zip excludes `uploads/` — ship uploads + SQL too.
- localhost only works on the machine publishing the port; show in browser on that machine or ship the stack.

## Mode B (scratch)
- Write `design-brief.md` before editing tpl/css.
- Sample articles must contain a visible “nội dung mẫu / sample content” line.
- Contact: `[Địa chỉ]`, `[Số điện thoại]`, `[Email]`, `[Giờ làm việc]` — never invent a real-looking address or phone.
- Do not fabricate enrollment numbers, rankings, awards, partner names, or doctor names.
- Unsplash/Pexels → `ATTRIBUTION.md`. Prefer SVG/CSS heroes.
