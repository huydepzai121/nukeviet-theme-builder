---
description: Install NukeViet 4.6 and build a custom theme (scrape real content, design from scratch, or from design files)
argument-hint: "[--scratch|--from-design] <organization or URL> [theme-name] [sector] [style]"
---

Use the `nukeviet-theme-builder` skill to build a NukeViet 4.6 site for: $ARGUMENTS

**Mode selection**
- If arguments include `--scratch`, or there is an org name + sector/style but **no** URL → Mode B (design from scratch): write `design-brief.md` first, then theme + sample content clearly marked as demo, placeholders `[Địa chỉ]` / `[Số điện thoại]` / `[Email]`, no fake real-world facts.
- If arguments include `--from-design` or the user attached screenshots/Figma/Base44 → Mode C.
- If a URL / "dữ liệu thật" is present → Mode A (scrape). Never invent facts; append source links.

Shared: install, serve with router, copy default theme (never edit default), seed, backups, 200 checks, desktop+mobile screenshots, theme zip. Never print passwords; store in chmod 600 file. Remind that `uploads/` + DB dump must ship with the theme zip.
