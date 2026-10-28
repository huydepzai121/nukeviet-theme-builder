---
description: Design a NukeViet 4.6 theme from scratch via Docker (org + sector + style, sample content)
argument-hint: <organization name> <sector: university|hospital|company|agency> [theme-name] [style/colors]
---

Use the `nukeviet-theme-builder` skill in **Mode B** for: $ARGUMENTS

1. `docker compose version` — if missing, stop and ask for Docker Desktop; no host PHP / no `php -S`.
2. Bootstrap project with `scripts/docker/setup.sh` (clean layout; secrets in `.env` only).
3. Write `.work/design-brief.md` before coding.
4. Implement theme under `site/themes/<name>` (never edit `default`).
5. Generate sample content (`generate_sample_content.py`); mark as demo; placeholders `[Địa chỉ]` / `[Số điện thoại]` / `[Email]`.
6. Seed via compose exec; `./docker/backup.sh`, `./docker/shot.sh`, `./docker/theme-zip.sh`.

Never print passwords.
