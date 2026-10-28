# nukeviet-theme-builder (Claude Code plugin)

**Tiếng Việt** · [English](#english)

Plugin cho Claude Code (**v1.2.0**): cài **NukeViet 4.6 bằng Docker Compose** (PHP 8.2-FPM + nginx + MariaDB), dựng giao diện theo ba chế độ (scrape / thiết kế từ đầu / theo file thiết kế).

> **Bắt buộc Docker.** Skill không cài PHP lên máy host và không dùng `php -S`, trừ khi bạn yêu cầu rõ fallback native.

## Yêu cầu
- [Docker Desktop](https://docs.docker.com/desktop/) (Windows / macOS) — trên Windows bật **WSL2**
- hoặc Docker Engine + plugin Compose (Linux)
- Kiểm tra: `docker compose version`

## Cài đặt plugin
```
/plugin marketplace add huydepzai121/nukeviet-theme-builder
/plugin install nukeviet-theme-builder@nukeviet-tools
```

## Cập nhật
```
/plugin marketplace update nukeviet-tools
/plugin uninstall nukeviet-theme-builder@nukeviet-tools
/plugin install nukeviet-theme-builder@nukeviet-tools
```
Khởi động lại Claude Code; kiểm tra `/plugin` (bản **1.2.0**).

## Cấu trúc project (sạch)
```
project/
  docker-compose.yml   .env          # mật khẩu chỉ ở đây
  docker/              # Dockerfile, nginx.conf, setup/backup/…
  site/                # mã NukeViet (volume)
  backups/             # .sql + theme zip
  .work/               # scrape, screenshots, scratch
```
Không để `nvzip/`, `nukeviet.zip`, `server.txt`, `credentials.txt` ở root.

## Chạy stack
```bash
# từ thư mục project (sau khi skill/bootstrap chạy setup.sh)
docker compose --env-file .env up -d --build
# Cài đặt: http://localhost:8080/install/  (DB host = db)
# hoặc AUTO_INSTALL=1 khi chạy setup.sh
rm -rf site/install    # sau khi cài xong

./docker/backup.sh
./docker/cache-clear.sh
./docker/theme-zip.sh mytheme
./docker/shot.sh
docker compose --profile tools up -d   # Adminer :8081
```

## Sử dụng trong Claude Code
```
/nukeviet-theme Trường X https://x.edu.vn tenx
/nukeviet-design "Phòng khám ABC" hospital pkabc "teal #0d7377"
/nukeviet-theme --scratch "Công ty XYZ" company xyz "minimal indigo"
/nukeviet-theme --from-design "Trường Y" truongy
```

## Thành phần
- `skills/…/SKILL.md` — Docker-first, 3 mode
- `scripts/docker/` — Compose, Dockerfile, nginx, setup/backup/restore/cache/theme-zip/shot
- `scripts/` — scrape, seed, generate_sample_content (chạy với DB qua compose)
- `references/` — theme-structure, XTemplate, design-system, gotchas
- `commands/` — `/nukeviet-theme`, `/nukeviet-design`

## Lưu ý
- Mật khẩu chỉ trong `.env` (chmod 600), không in ra chat.
- Mode B/C: không bịa địa chỉ/SĐT/số liệu; dùng placeholder và “nội dung mẫu”.
- Zip theme không gồm `uploads/` — cần kèm SQL + uploads.

---
## English

Claude Code plugin **v1.2.0**: run **NukeViet 4.6 on Docker Compose** (PHP 8.2-FPM + nginx + MariaDB) and build custom themes (scrape / from-scratch / from design files).

**Docker is required.** The skill will not install host PHP or use `php -S` unless you explicitly ask for a native fallback. Prerequisite: Docker Desktop (Windows/macOS + WSL2) or Engine + Compose — verify with `docker compose version`.

### Install / update plugin
```
/plugin marketplace add huydepzai121/nukeviet-theme-builder
/plugin install nukeviet-theme-builder@nukeviet-tools
# update:
/plugin marketplace update nukeviet-tools
/plugin uninstall nukeviet-theme-builder@nukeviet-tools
/plugin install nukeviet-theme-builder@nukeviet-tools
```

### Project layout
`docker-compose.yml`, `.env` (secrets only), `docker/`, `site/`, `backups/`, `.work/`. No host `credentials.txt` / `php -S` logs in the root.

### Stack
`docker compose --env-file .env up -d --build` → http://localhost:8080 — DB host inside the network is `db`. Helpers: `./docker/backup.sh`, `restore.sh`, `cache-clear.sh`, `theme-zip.sh`, `shot.sh` (Playwright container).

### Commands
`/nukeviet-theme`, `/nukeviet-design` — see Vietnamese section for examples.
