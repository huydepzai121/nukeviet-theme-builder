# XTemplate cheatsheet (NukeViet)

```html
<!-- BEGIN: main -->
  {SITE_NAME} {LANG.key} {GCONFIG.site_email} {NEWS.title}
  {FILE "header_only.tpl"}                 include another tpl from same dir
  <!-- BEGIN: home -->
    <!-- BEGIN: news --><a href="{NEWS.link}">{NEWS.title}</a><!-- END: news -->
  <!-- END: home -->
<!-- END: main -->
```

PHP:
```php
$xtpl = new XTemplate('file.tpl', NV_ROOTDIR . '/themes/' . $theme . '/layout');
$xtpl->assign('NEWS', ['title' => 'x', 'link' => '...']);   // {NEWS.title}
$xtpl->parse('main.home.news');      // parse inner blocks first, repeat for loops
$xtpl->parse('main.home');           // then parents
$xtpl->parse('main');
echo $xtpl->text('main');
```
Rules
- A block not parsed is not output (use this for conditionals).
- Parse children before the parent; parsing a child N times = loop of N.
- Unassigned `{VAR}` renders empty. Values are NOT escaped: escape yourself (`htmlspecialchars`, `nv_htmlspecialchars`).
- `&` in URLs in templates must be `&amp;`.
- Block names are path-like: `main.vmenu.sub.item`.
- Header/footer tpls are included via `{FILE}` into the layout, so their blocks live under `main.*` of the layout's xtpl in `nv_site_theme()`.
