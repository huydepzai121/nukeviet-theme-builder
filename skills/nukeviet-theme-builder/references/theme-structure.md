# NukeViet 4.6 theme structure

```
themes/<theme>/
  config.ini            XML: <info>, <layoutdefault>, <positions>, <setlayout>, <setblocks>
  theme.php             nv_site_theme() builds the page; nv_error_theme(); nv_mailHTML()
  config.php / config_default.php / config.json   theme config UI (admin)
  default.jpg           thumbnail in admin
  layout/
    header_only.tpl     <html><head> ... (meta, css, js)
    header_extended.tpl site header, menu, (homepage sections)
    layout.<name>.tpl   body grid: main, main-right, left-main, left-main-right, ...
    footer_extended.tpl site footer
    footer_only.tpl     scripts, </body></html>
    block.<tpl>.tpl     block wrappers: default, no_title, primary, border, simple
    simple.tpl          used when $full=false (popups)
  blocks/global.*.php|tpl|ini   theme-provided blocks
  modules/<module>/*.tpl        per-module template overrides (fallback: themes/default/modules)
  css/style.css, style.responsive.css, custom.css (yours)   js/main.js, custom.js (yours)
  language/*.php        theme strings  system/*.tpl  error/alert/info pages
```

## Layout files
A layout includes header/footer: `[HEADER]`-style positions are placeholders replaced by blocks.
`{MODULE_CONTENT}` is the module output. Typical `layout.main-right.tpl`:
```
<!-- BEGIN: main -->
{FILE "header_only.tpl"}
{FILE "header_extended.tpl"}
<div class="row"><div class="col-md-16">[TOP]{MODULE_CONTENT}[BOTTOM]</div><div class="col-md-8">[RIGHT]</div></div>
{FILE "footer_extended.tpl"}
{FILE "footer_only.tpl"}
<!-- END: main -->
```
Every position used in a tpl must be declared in `config.ini <positions>` or blocks can't be assigned.

## DB tables (prefix nv4, lang vi)
- `nv4_config` (site_name, site_theme, site_logo per lang; site_email, site_phone with lang='sys')
- `nv4_vi_modthemes` (func_id, layout, theme) - layout per module function per theme
- `nv4_vi_blocks_groups` (theme, module, file_name, position, template, all_func, config) + `nv4_vi_blocks_weight`
- `nv4_vi_menu_rows` (mid=1 main menu; parentid, subitem csv, link, target 1=self 2=blank)
- `nv4_vi_news_cat`, `nv4_vi_news_rows`, `nv4_vi_news_detail`, `nv4_vi_news_<catid>` (copy of rows per category!), `nv4_vi_news_block(_cat)`
- `nv4_vi_about` (page module "about")
- `nv4_vi_contact_department`

## Useful constants/vars in theme.php
`$home` (homepage?), `$db`, `NV_PREFIXLANG` (`nv4_vi`), `NV_BASE_SITEURL`, `NV_UPLOADS_DIR`, `NV_LANG_VARIABLE`, `NV_NAME_VARIABLE`, `NV_OP_VARIABLE`, `$global_config['rewrite_exturl']`, `nv_url_rewrite($url, true)`, `nv_date()`, `nv_clean60($s, $len)`.
News article URL: `index.php?language=vi&nv=news&op=<cat_alias>/<alias>-<id>` + rewrite_exturl.
