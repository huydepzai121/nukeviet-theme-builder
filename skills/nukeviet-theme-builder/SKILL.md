---
name: nukeviet-theme-builder
description: >
  Install NukeViet 4.6 locally (PHP 8 + MariaDB) and build a custom theme.
  Three modes: (1) scrape real content from an organization's official website;
  (2) design from scratch when the user gives only org name, sector, style/colors
  (no source site) — produce a design brief first, then sample content clearly
  marked as placeholder; (3) restyle from design files/screenshots/Figma.
  Use when asked for a NukeViet site, NukeViet theme, university/company portal,
  or to design a website on NukeViet from scratch.
---

# NukeViet 4.6 theme builder

Goal: a running NukeViet 4.6 site with custom theme `<theme>`, content, theme zip, DB dump and screenshots.

## 0. Mode selection (do this first)

Pick **one** mode from what the user gave. If unclear, ask once then proceed.

| Mode | Trigger | Content source |
|------|---------|----------------|
| **A. Scrape** | Official URL / "dữ liệu thật" / "lấy từ website …" | Real articles, images, pages from that site. Never invent facts. |
| **B. Scratch** | Org name + sector + style/colors; no source URL; `/nukeviet-design` or `--scratch` | Original **sample** content, clearly marked. Placeholders `[Địa chỉ]`, `[Số điện thoại]` for unknowns. No fake stats/addresses presented as real. |
| **C. From design** | Screenshots, Figma, Base44, design files | Copy exact texts/colors/layout from the design; images from design or royalty-free. |

Ask (or infer) for every mode: organization name, theme machine name (`[a-z0-9_]`), brand colors/logo (or style keywords for B), target pages/menu.

For **mode B**, also get: sector (university, hospital, company, agency…), style (modern, classic, maritime, green…), optional color hex codes.

---

## Shared steps (all modes)

### 1. Install
1. PHP 8.x (cli, mysql/pdo_mysql, gd, curl, mbstring, xml, zip, intl) + MariaDB; start MariaDB.
2. Create DB + user with random password (`openssl rand -base64 18`).
3. Download NukeViet 4.6 release zip from GitHub (`https://github.com/nukeviet/nukeviet/releases`) → `<work>/site`.
4. Run `scripts/install_nukeviet.sh`. Adapt form fields if installer changed.
5. Delete `site/install/`.
6. Save credentials to `<work>/credentials.txt`, `chmod 600`. **Never print passwords; never commit them.**

### 2. Serve
`php -S 0.0.0.0:<port> scripts/router.php` with `NV_ROOT` = site dir, detached (`nohup … &`). Router maps folder URLs to their own `index.php` (so `/admin/` works).

### 3. Theme
1. `cp -r site/themes/default site/themes/<theme>`. **Never edit `themes/default`.**
2. Edit `config.ini` (info, layouts, positions, blocks). See `references/theme-structure.md`.
3. Rewrite `layout/header_extended.tpl` / `footer_extended.tpl` (XTemplate: `references/xtemplate-cheatsheet.md`), `css/custom.css`, `js/custom.js`.
4. Homepage sections in `theme.php` → `nv_site_theme()`, before `$xtpl->parse('main')`: query modules and parse `main.home.*` only when `$home`. Example: `examples/vimaru/theme-home-snippet.php`. Patterns: `references/design-system.md`.
5. Override module tpls only when needed (`themes/<theme>/modules/<mod>/`).
6. Activate theme in DB (`site_theme`); copy `modthemes` + `blocks_groups/_weight` from `default` (see seed template).

### 4. Content — see mode-specific sections below

### 5. Verify & deliver
1. `mysqldump` before big changes and at the end.
2. HTTP 200 for `/`, a category, an article, an about page, `/admin/` (`scripts/verify.sh`).
3. Screenshots desktop 1440 + mobile 390 (`scripts/shot.js`); fix layout issues.
4. Zip theme; remind user that `uploads/<slug>/` + DB dump must ship too.
5. Report URLs, what is real vs sample/placeholder, credential file path (not contents).

Gotchas: `references/gotchas.md`.

---

## Mode A — Scrape (real content)

1. Scrape with `scripts/scrape_template.py` (adjust selectors): categories, N articles each, about pages, contact, logo, banners.
2. Download images → `site/uploads/news/<slug>/`; rewrite `src`; set first image as `homeimgfile` (`homeimgthumb=2`).
3. Append source link (`Nguồn: <a href="…">domain</a>`) to every article/page.
4. Import with `scripts/seed_template.php` (env credentials). Dates/names/phones/addresses **must** come from the source; if unknown leave blank and tell the user.
5. Clear `site/data/cache/*` (keep `index.html`).

---

## Mode B — Design from scratch

When the user has **no** source website: invent a coherent design, then fill with clearly marked sample content.

### B1. Design brief (write this **before** coding)
Save `<work>/design-brief.md` and show the user. Include:
- **Brand**: name, sector, voice (formal / friendly / academic…)
- **Palette**: primary, secondary, accent, neutrals, semantic (success/warn/error) — hex + CSS variable names. See `references/design-system.md`.
- **Typography**: heading + body fonts (system stack or Google Fonts), type scale (h1–h6, body, small).
- **Layout**: header (logo, menu, search?), hero style (slider / single banner / video), footer columns.
- **Homepage sections** (ordered list): e.g. hero, quick links, featured news, notices, events, faculties/services grid, partners, CTA. Map each to a NukeViet module or static block.
- **Inner pages**: about, news list/detail, contact.
- **Responsive** notes and accessibility (contrast, focus states).

Wait for a short confirmation **only if** the user asked to review; otherwise proceed after writing the brief.

### B2. Build the theme
Implement the brief in `config.ini`, header/footer tpl, `custom.css` (CSS variables from the palette), `custom.js`, `theme.php` homepage sections. Prefer CSS/SVG illustrations over stock photos when possible.

### B3. Sample content (never fake real-world facts)
1. Run `scripts/generate_sample_content.py` (or write JSON by hand from `scripts/sample_content.template.json`):
   - Categories appropriate to the sector.
   - 8–15 sample articles with titles/bodies that fit the org; each body **starts or ends** with a visible notice: `Đây là nội dung mẫu.` / `This is sample content.`
   - About pages with placeholder org description (not copied from a real org).
   - Contact: use `[Địa chỉ]`, `[Số điện thoại]`, `[Email]` — never invent a street address, phone, or statistic and present it as real.
   - Dates: use relative recent dates; note they are synthetic.
2. Images:
   - Prefer **SVG/CSS** hero/illustrations generated in the theme (no attribution needed).
   - Or royalty-free from Unsplash/Pexels: download into `uploads/news/<slug>/`, keep an `ATTRIBUTION.md` with photo URL + author + license.
   - Or image-generation tools if available in the environment — still mark as illustrative.
3. Seed with `scripts/seed_template.php` pointing at the generated JSON (`DATA_DIR`, `ORG_NAME`, `THEME`, env DB creds).
4. In footer or about page, add a site-wide note: content is demo/sample until the organization replaces it.
5. Clear cache.

### B4. Deliver extras
Include `design-brief.md` and `ATTRIBUTION.md` (if any) next to the theme zip. Tell the user which strings are placeholders to replace.

---

## Mode C — From design files / screenshots / Figma

1. Read the design (screenshots, Figma export, Base44 data file, etc.): extract exact colors, fonts, section order, copy, image URLs.
2. Build the theme to match; download design images into `uploads/news/<slug>/`.
3. Content: use texts from the design as-is; for gaps follow Mode B rules (sample + placeholders, never invent facts).
4. Seed, verify, deliver as above.

