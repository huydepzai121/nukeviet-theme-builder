---
name: nukeviet-theme-builder
description: Install NukeViet 4.6 locally (PHP 8 + MariaDB) and build or restyle a custom NukeViet theme from a design or an organization's existing website, filled with real scraped content (articles, images, about pages, menus). Use when the user asks for a NukeViet site, a NukeViet theme, or to rebuild a school/company/agency portal on NukeViet.
---

# NukeViet 4.6 theme builder

Goal: a running NukeViet 4.6 site with a custom theme `<theme>` and **real** content from the organization's official site, plus a theme zip, DB dump and screenshots.

Ask (or infer) first: organization name, official URL, theme machine name (lowercase, `[a-z0-9_]`), brand colors/logo, target pages/menu.

## 1. Install
1. Install PHP 8.x (cli, mysql/pdo_mysql, gd, curl, mbstring, xml, zip, intl) and MariaDB. Start MariaDB.
2. Create DB + user with a generated random password (`openssl rand -base64 18`).
3. Download the NukeViet 4.6 release zip from the official GitHub releases (`https://github.com/nukeviet/nukeviet/releases`), unzip into `<work>/site`.
4. Run the installer: `scripts/install_nukeviet.sh` (curl-scripted web installer). If the form fields changed, open `install/index.php` steps in a browser/curl and adapt.
5. Delete `site/install/` afterwards.
6. Save admin + DB credentials to `<work>/credentials.txt`, `chmod 600`. **Never print passwords in chat or logs; never commit them.**

## 2. Serve
`php -S 0.0.0.0:<port> scripts/router.php` (set `NV_ROOT` env to the site dir), run detached (`nohup ... &`). The router sends folder URLs to their own `index.php` (so `/admin/` works) and everything else to root `index.php`. Real deployment: Apache/nginx with NukeViet's rewrite rules.

## 3. Theme
1. `cp -r site/themes/default site/themes/<theme>`. **Never edit `themes/default`** (it is the fallback for every missing template).
2. Edit `config.ini` (info, `<layoutdefault>`, `<positions>`, `<setlayout>`, `<setblocks>`). See `references/theme-structure.md`.
3. Rewrite `layout/header_extended.tpl` / `footer_extended.tpl` (XTemplate, see `references/xtemplate-cheatsheet.md`), add `css/custom.css`, `js/custom.js`.
4. Homepage sections: in `theme.php` → `nv_site_theme()`, before `$xtpl->parse('main')`, query modules (news rows, menu rows, about…) with `$db` and parse `main.home.*` blocks only when `$home` is true. Example: `examples/vimaru/theme-home-snippet.php`.
5. Override module templates by copying from `themes/default/modules/<mod>/` into `themes/<theme>/modules/<mod>/` only when needed.
6. Activate: admin → Giao diện → set theme, or `UPDATE nv4_config SET config_value='<theme>' WHERE config_name='site_theme'`. Copy `nv4_<lang>_modthemes` layouts and the needed `nv4_<lang>_blocks_groups/_weight` rows from `default` to `<theme>` (see seed template).

## 4. Real content (never invent facts)
1. Scrape the official site with `scripts/scrape_template.py` (adjust selectors): categories, latest N articles per category (title, date, body, images), about pages, contact data, logo, banners.
2. Download every image into `site/uploads/news/<slug>/`, rewrite `src` to local paths, set the first image as article `homeimgfile` (path relative to `uploads/news/`, `homeimgthumb=2`).
3. Append a source link (`Nguồn: <a href="original">domain</a>`) to every article/page.
4. Import with `scripts/seed_template.php` (credentials read from env, not hard-coded). Text, dates, names, phone numbers, addresses must come from the source; if unknown leave blank and tell the user.
5. Clear cache: `rm -rf site/data/cache/*` (keep `index.html`).

## 5. Verify & deliver
1. `mysqldump` backup before each big change and at the end (`<work>/<db>.sql`).
2. `curl -o /dev/null -w '%{http_code}'` for `/`, a category, an article, an about page, `/admin/` → all 200.
3. Screenshots: `node scripts/shot.js` desktop 1440 and mobile 390; look at them and fix layout issues.
4. `cd site/themes && zip -r <work>/theme-<theme>.zip <theme>`. Tell the user that `uploads/<slug>/` (images, logo, banners) and the DB dump must ship too, or deliver the whole site + dump.
5. Report: URLs (localhost only works on the machine running it), what is real vs. approximated (e.g. publish times), credential file path (not its contents).

Gotchas: `references/gotchas.md`.
