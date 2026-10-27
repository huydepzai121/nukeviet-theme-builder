---
description: Design a NukeViet 4.6 theme from scratch (org name + sector + style/colors, no source website) with sample content
argument-hint: <organization name> <sector: university|hospital|company|agency> [theme-name] [style/colors]
---

Use the `nukeviet-theme-builder` skill in **Mode B (design from scratch)** for: $ARGUMENTS

Steps (follow the skill):
1. Confirm org name, sector, style/colors, theme machine name.
2. Write `<work>/design-brief.md` (palette, type, homepage sections, layout) **before** coding; show the user.
3. Install NukeViet 4.6, serve with router, copy `themes/default` → `themes/<name>` (never edit default).
4. Implement the brief (header/footer tpl, custom.css with CSS variables, theme.php homepage sections). Prefer SVG/CSS illustrations; Unsplash/Pexels only with ATTRIBUTION.md.
5. Generate sample content: `ORG_NAME=… SECTOR=… SLUG=… OUT=… python3 scripts/generate_sample_content.py` (or fill `sample_content.template.json`). Every article/page must say it is sample content; contact fields use `[Địa chỉ]`, `[Số điện thoại]`, `[Email]`. Never invent stats, street addresses, or awards presented as real.
6. Seed via `seed_template.php` (env DB credentials), verify 200s, screenshots, zip theme + note uploads/ + DB dump + design-brief.md.

Never print passwords.
