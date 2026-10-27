# Design system for NukeViet themes

Use this when designing from scratch (Mode B) or matching a brief (Mode C).

## Palette (CSS variables)
Put in `css/custom.css` on `:root`:
```css
:root {
  --nv-primary: #0b3d5c;      /* brand */
  --nv-primary-dark: #072a40;
  --nv-secondary: #c9a227;    /* accent / gold */
  --nv-bg: #ffffff;
  --nv-bg-alt: #f4f7fa;
  --nv-text: #1a1a1a;
  --nv-text-muted: #5a6570;
  --nv-border: #e2e8f0;
  --nv-success: #2e7d32;
  --nv-warn: #ed6c02;
  --nv-error: #c62828;
  --nv-radius: 8px;
  --nv-shadow: 0 8px 24px rgba(11,61,92,.08);
  --nv-font: "Be Vietnam Pro", system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  --nv-font-display: "Be Vietnam Pro", var(--nv-font);
}
```
Sector starting points (adjust with the user):
| Sector | Primary | Accent |
|--------|---------|--------|
| University / maritime | deep navy `#0b3d5c` | gold `#c9a227` |
| Hospital / health | teal `#0d7377` | soft green `#14a3a8` |
| Tech company | indigo `#3730a3` | cyan `#06b6d4` |
| Government / agency | crimson `#8b0000` or navy | gold |
| Education K-12 | green `#1b5e20` | orange `#f57c00` |
| NGO / green | forest `#2e7d32` | leaf `#81c784` |

Contrast: body text on bg ≥ 4.5:1; large headings ≥ 3:1.

## Typography
- Load one Google Font (or system stack) in `header_only.tpl` / `header_extended.tpl`.
- Scale (rem): h1 2.25 / h2 1.75 / h3 1.35 / h4 1.15 / body 1 / small 0.875 / line-height 1.6.
- Keep NukeViet's Bootstrap 3 grid; override via `custom.css`, don't replace Bootstrap.

## Homepage section patterns (map → modules)
| Section | Implementation |
|---------|----------------|
| Top bar (phone, email, lang) | Static in `header_extended.tpl`; use `[Địa chỉ]` etc. in scratch mode |
| Logo + search + burger | Header; search → NukeViet seek module URL |
| Main menu | Block `[MENU_SITE]` or query `nv4_*_menu_rows` in `theme.php` → `main.vmenu` |
| Hero slider | Static slides in header tpl (scratch: CSS gradient / SVG / Unsplash) or banners module |
| Quick links | Static row of 4–6 cards linking to news categories / external portals |
| Featured news | `theme.php` query `news_rows` → `main.home.featured` + `main.home.news` |
| Notices list | Same, filter by notices catid → `main.home.notice` |
| Events | Filter by events catid → `main.home.event` |
| Faculties / services grid | Static cards in tpl, or freecontent / page module |
| Partners logos | Static row or freecontent |
| CTA banner | Static band before footer |
| Footer | `footer_extended.tpl`: about blurb, menu, contact placeholders, copyright |

Keep `[LEFT]` / `[RIGHT]` / `[TOP]` / `[BOTTOM]` for module pages; homepage can hide sidebars via a `layout.main.tpl` for the home function only.

## Scratch-mode content rules
- Every sample article/page: visible "nội dung mẫu / sample content" label.
- Unknown contact fields: literal placeholders `[Địa chỉ]`, `[Số điện thoại]`, `[Email]`, `[Giờ làm việc]`.
- No invented enrollment numbers, rankings, awards, or street addresses presented as fact.
- Synthetic dates OK if disclosed in the delivery note.
- Keep `ATTRIBUTION.md` for any Unsplash/Pexels photo (URL, author, license).

## File checklist for a new theme
```
themes/<theme>/
  config.ini, theme.php, default.jpg
  layout/header_extended.tpl, footer_extended.tpl, layout.main.tpl, layout.main-right.tpl
  css/custom.css, js/custom.js
  (optional) modules/news/*.tpl overrides
uploads/news/<slug>/   # images + ATTRIBUTION.md
design-brief.md        # Mode B/C
```
