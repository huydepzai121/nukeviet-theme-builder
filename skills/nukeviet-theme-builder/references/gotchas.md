# Gotchas found in real builds

- `localhost:<port>` only works on the machine running `php -S`. Show in that machine's browser or ship site + DB dump.
- `php -S` without a router: `/admin/` serves 404 / root index. Router must map folder URLs to their own `index.php` and set SCRIPT_NAME/PHP_SELF + chdir.
- Run `php -S` detached (`nohup ... &`), otherwise it dies with the shell.
- Delete `install/` after install or NukeViet keeps redirecting/warning.
- Never edit `themes/default`; it is the fallback for any missing tpl in your theme.
- New theme has no layouts/blocks in DB: copy `nv4_vi_modthemes` and `nv4_vi_blocks_groups/_weight` rows from `default`, else pages are empty or error "layout".
- Positions used in layouts must exist in `config.ini`; blocks in removed positions disappear silently.
- News rows must also be inserted in `nv4_vi_news_<catid>` for each listed category, or category pages are empty.
- `homeimgfile` is relative to `uploads/news/`; `homeimgthumb=2` = use original file (no thumbnail generation needed); 0 = no image.
- Clear `data/cache/*` after DB edits (keep index.html), else old menu/config shows.
- Scraped bodies: rewrite relative `src`/`href` to absolute, then download images and rewrite to local `/uploads/news/<slug>/...`. URL-encode spaces. Some link texts are percent-encoded filenames - decode for display.
- Notice/announcement posts are often just a PDF link; keep the link, say so to the user.
- Scanned-image pages (e.g. official decisions) can't be turned into text without OCR: keep the image, note it.
- Only the date is usually published; the publish time is synthetic - tell the user.
- Lazy-loaded images: scroll the page before full-page screenshots.
- Theme zip excludes `uploads/`; logo/banners/article images live there. Ship uploads + DB dump (or whole site).
- Cloudflare quick tunnels may be blocked on some networks (port 7844).
- Never put DB/admin passwords in scripts, theme files, chat or zip. Read from env / a chmod 600 file.
