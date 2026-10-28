---
description: Install NukeViet 4.6 with Docker Compose and build a custom theme (scrape, scratch, or from design)
argument-hint: "[--scratch|--from-design] <organization or URL> [theme-name] [sector] [style]"
---

Use the `nukeviet-theme-builder` skill for: $ARGUMENTS

**Runtime (mandatory)**
1. Run `docker compose version`. If Docker/Compose is missing, STOP and tell the user to install Docker Desktop (Windows/macOS + WSL2) or Docker Engine + Compose. Do **not** install PHP on the host. Do **not** run `php -S` unless the user explicitly demands a native fallback.
2. Use the clean layout: `docker-compose.yml`, `.env`, `docker/`, `site/`, `backups/`, `.work/`. Secrets only in `.env`. Bootstrap with `scripts/docker/setup.sh` (`AUTO_INSTALL=1` when appropriate).

**Mode**
- URL / “dữ liệu thật” → Mode A (scrape; never invent facts; source links).
- `--scratch` or org+sector/style without URL → Mode B (design brief first, sample content + placeholders).
- `--from-design` or attached Figma/screenshots → Mode C.

Backup/restore/cache/theme-zip/screenshots via `./docker/*.sh`. Verify `/` and `/admin/` return 200. Never print passwords.
