# nukeviet-theme-builder (Claude Code plugin)

**Tiếng Việt** · [English](#english)

Plugin cho Claude Code: cài NukeViet 4.6 (PHP 8 + MariaDB), dựng giao diện (theme) riêng và nạp **dữ liệu thật** lấy từ website chính thức của tổ chức (bài viết, ảnh, trang giới thiệu, menu), kèm sao lưu DB, kiểm tra HTTP 200, ảnh chụp desktop/mobile và file zip theme.

## Cài đặt
Giải nén `nukeviet-theme-builder.zip` (ví dụ vào `~/claude-plugins/nukeviet-theme-builder`), rồi trong Claude Code:
```
/plugin marketplace add huydepzai121/nukeviet-theme-builder
/plugin install nukeviet-theme-builder@nukeviet-tools
```
Hoặc từ terminal: `claude plugin marketplace add huydepzai121/nukeviet-theme-builder` rồi `claude plugin install nukeviet-theme-builder@nukeviet-tools`.
Chạy thử không cần cài: `claude --plugin-dir <đường-dẫn>`.

## Sử dụng
```
/nukeviet-theme Trường Đại học X https://x.edu.vn tenx
```
hoặc chỉ cần yêu cầu "dựng website NukeViet cho ... với dữ liệu thật" – skill `nukeviet-theme-builder` sẽ tự kích hoạt.

## Thành phần
- `skills/nukeviet-theme-builder/SKILL.md` – quy trình
- `references/` – cấu trúc theme, XTemplate, các lỗi hay gặp
- `scripts/` – `install_nukeviet.sh`, `router.php`, `scrape_template.py`, `seed_template.php`, `shot.js`, `verify.sh`
- `examples/vimaru/` – ví dụ thật (ĐH Hàng hải Việt Nam)
- `commands/nukeviet-theme.md` – lệnh `/nukeviet-theme`

Lưu ý: mật khẩu chỉ lưu trong `credentials.txt` (chmod 600), không in ra. Khi triển khai phải chép cả `uploads/` và file dump DB, không chỉ zip theme.

---
## English
Claude Code plugin that installs NukeViet 4.6 (PHP 8 + MariaDB), builds a custom theme and fills it with **real** content scraped from the organization's official website, then backs up the DB, checks HTTP 200s, takes desktop/mobile screenshots and zips the theme.

### Install
Unzip, then inside Claude Code:
```
/plugin marketplace add huydepzai121/nukeviet-theme-builder
/plugin install nukeviet-theme-builder@nukeviet-tools
```
CLI: `claude plugin marketplace add huydepzai121/nukeviet-theme-builder` and `claude plugin install nukeviet-theme-builder@nukeviet-tools`. Quick test: `claude --plugin-dir /path/...`.

### Use
`/nukeviet-theme <organization or URL> [theme-name]`, or just ask for a NukeViet site with real content.

Passwords are stored only in a chmod 600 `credentials.txt`, never printed. Deploy `uploads/` and the DB dump together with the theme zip.
