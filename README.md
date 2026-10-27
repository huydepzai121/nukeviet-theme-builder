# nukeviet-theme-builder (Claude Code plugin)

**Tiếng Việt** · [English](#english)

Plugin cho Claude Code (v1.1.0): cài NukeViet 4.6 (PHP 8 + MariaDB), dựng giao diện riêng theo **ba chế độ**:

| Chế độ | Khi nào | Nội dung |
|--------|---------|----------|
| **A. Scrape** | Có URL website chính thức | Bài viết / ảnh / trang **thật**, kèm link nguồn |
| **B. Scratch** | Chỉ có tên tổ chức + lĩnh vực + style/màu | Brief thiết kế trước, rồi **nội dung mẫu** (ghi rõ demo, placeholder `[Địa chỉ]`) |
| **C. From design** | Có ảnh chụp / Figma / Base44 | Bám đúng copy & màu trong thiết kế |

Kèm sao lưu DB, kiểm tra HTTP 200, ảnh chụp desktop/mobile và file zip theme.

## Cài đặt
```
/plugin marketplace add huydepzai121/nukeviet-theme-builder
/plugin install nukeviet-theme-builder@nukeviet-tools
```
Terminal: `claude plugin marketplace add huydepzai121/nukeviet-theme-builder` rồi `claude plugin install nukeviet-theme-builder@nukeviet-tools`.
Chạy thử: `claude --plugin-dir <đường-dẫn>`.

## Sử dụng

**Scrape (dữ liệu thật):**
```
/nukeviet-theme Trường Đại học X https://x.edu.vn tenx
```

**Thiết kế từ đầu (không có website nguồn):**
```
/nukeviet-design "Phòng khám ABC" hospital pkabc "hiện đại, xanh teal #0d7377"
```
hoặc:
```
/nukeviet-theme --scratch "Công ty XYZ" company xyz "tối giản, indigo"
```

**Theo file thiết kế / ảnh chụp:**
```
/nukeviet-theme --from-design "Trường Y" truongy
```
(đính kèm screenshot hoặc Figma)

Cũng có thể chỉ nhắn tự nhiên: *"dựng website NukeViet cho … với dữ liệu thật"* hoặc *"thiết kế từ đầu portal bệnh viện màu xanh"* — skill tự chọn mode.

## Thành phần
- `skills/nukeviet-theme-builder/SKILL.md` — quy trình 3 mode
- `references/` — theme-structure, XTemplate, gotchas, **design-system**
- `scripts/` — install, router, scrape, **generate_sample_content.py**, sample_content.template.json, seed, shot, verify
- `examples/vimaru/` — ví dụ scrape (ĐH Hàng hải Việt Nam)
- `commands/` — `/nukeviet-theme`, `/nukeviet-design`

## Lưu ý
- Mật khẩu chỉ trong `credentials.txt` (chmod 600), không in ra.
- Mode B/C: không bịa địa chỉ, SĐT, số liệu thống kê như thể thật; dùng placeholder và ghi "nội dung mẫu".
- Triển khai: chép cả `uploads/` + dump DB, không chỉ zip theme. Mode B kèm `design-brief.md` (+ `ATTRIBUTION.md` nếu dùng Unsplash/Pexels).

---
## English

Claude Code plugin **v1.1.0**: install NukeViet 4.6 and build a custom theme in three modes — **scrape** real content from an official site, **design from scratch** (org + sector + style only) with a design brief and clearly marked sample content, or **from design files** (screenshots / Figma / Base44).

### Install
```
/plugin marketplace add huydepzai121/nukeviet-theme-builder
/plugin install nukeviet-theme-builder@nukeviet-tools
```
CLI: `claude plugin marketplace add huydepzai121/nukeviet-theme-builder` then `claude plugin install nukeviet-theme-builder@nukeviet-tools`. Quick test: `claude --plugin-dir /path/...`.

### Use
```
# Scrape
/nukeviet-theme University X https://x.edu.vn tenx

# From scratch
/nukeviet-design "ABC Clinic" hospital pkabc "modern teal #0d7377"
/nukeviet-theme --scratch "XYZ Corp" company xyz "minimal indigo"

# From design assets
/nukeviet-theme --from-design "School Y" schooly
```

### Notes
Passwords only in chmod 600 `credentials.txt`. Scratch mode never invents real addresses/phones/stats — use `[Địa chỉ]`-style placeholders and a visible “sample content” label. Ship `uploads/` + DB dump with the theme zip; include `design-brief.md` for Mode B.
