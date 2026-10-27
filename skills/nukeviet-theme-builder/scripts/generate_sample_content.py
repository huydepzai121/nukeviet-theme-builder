#!/usr/bin/env python3
"""Generate sample articles/pages JSON for Mode B (design from scratch).
Usage:
  ORG_NAME="Trường ABC" SECTOR=university SLUG=abc OUT=./data python3 generate_sample_content.py
Writes articles.json + pages.json ready for seed_template.php.
Never invents real addresses/phones/stats — uses [Địa chỉ] style placeholders.
"""
import json, os, datetime as dt
from pathlib import Path

ORG = os.environ.get('ORG_NAME', 'Tổ chức mẫu')
SECTOR = os.environ.get('SECTOR', 'university')
SLUG = os.environ.get('SLUG', 'sample')
OUT = Path(os.environ.get('OUT', '.')); OUT.mkdir(parents=True, exist_ok=True)
NOTICE = '<p><strong>Đây là nội dung mẫu phục vụ demo giao diện.</strong></p>'

SECTOR_CATS = {
    'university': [
        (1, 'Tin tức', 'Tin-tuc', 'tin-tuc'),
        (2, 'Thông báo', 'Thong-bao', 'thong-bao'),
        (3, 'Sự kiện', 'Su-kien', 'su-kien'),
        (4, 'Tuyển sinh', 'Tuyen-sinh', 'tuyen-sinh'),
        (5, 'Nghiên cứu', 'Nghien-cuu', 'nghien-cuu'),
    ],
    'hospital': [
        (1, 'Tin tức', 'Tin-tuc', 'tin-tuc'),
        (2, 'Thông báo', 'Thong-bao', 'thong-bao'),
        (3, 'Dịch vụ', 'Dich-vu', 'dich-vu'),
        (4, 'Lịch khám', 'Lich-kham', 'lich-kham'),
    ],
    'company': [
        (1, 'Tin tức', 'Tin-tuc', 'tin-tuc'),
        (2, 'Thông báo', 'Thong-bao', 'thong-bao'),
        (3, 'Sản phẩm', 'San-pham', 'san-pham'),
        (4, 'Tuyển dụng', 'Tuyen-dung', 'tuyen-dung'),
    ],
    'agency': [
        (1, 'Tin tức', 'Tin-tuc', 'tin-tuc'),
        (2, 'Thông báo', 'Thong-bao', 'thong-bao'),
        (3, 'Văn bản', 'Van-ban', 'van-ban'),
        (4, 'Thủ tục', 'Thu-tuc', 'thu-tuc'),
    ],
}
cats = SECTOR_CATS.get(SECTOR, SECTOR_CATS['university'])

def day(n_ago):
    d = dt.date.today() - dt.timedelta(days=n_ago)
    return d.strftime('%d/%m/%Y')

ARTICLES_BY_SECTOR = {
    'university': [
        ('tin-tuc', 'Chào mừng đến với cổng thông tin {org}',
         'Bài viết mẫu giới thiệu cổng thông tin điện tử của {org}.',
         '<p>{org} xây dựng cổng thông tin để cung cấp tin tức, thông báo và dịch vụ trực tuyến cho sinh viên và người học. Nội dung thật sẽ được cập nhật bởi quản trị viên.</p>'),
        ('tin-tuc', 'Hoạt động học thuật mẫu tại {org}',
         'Tóm tắt hoạt động học thuật mẫu.',
         '<p>Đây là mô tả hoạt động mẫu (hội thảo, seminar). Không phải sự kiện có thật. Địa điểm: [Địa chỉ].</p>'),
        ('thong-bao', 'Thông báo lịch làm việc mẫu',
         'Thông báo mẫu về lịch làm việc.',
         '<p>Thời gian làm việc: [Giờ làm việc]. Liên hệ: [Email] — [Số điện thoại].</p>'),
        ('thong-bao', 'Thông báo bảo trì hệ thống mẫu',
         'Thông báo kỹ thuật mẫu.',
         '<p>Hệ thống có thể bảo trì theo lịch do quản trị viên công bố. Đây là nội dung placeholder.</p>'),
        ('su-kien', 'Sự kiện khai giảng / ngày hội mẫu',
         'Sự kiện mẫu trên trang chủ.',
         '<p>Sự kiện minh họa giao diện. Thời gian và địa điểm thật: [Địa chỉ], [Giờ làm việc].</p>'),
        ('su-kien', 'Hội thảo chuyên đề mẫu',
         'Hội thảo mẫu.',
         '<p>Chủ đề và diễn giả sẽ do {org} cập nhật. Hiện tại đây chỉ là bài viết demo.</p>'),
        ('tuyen-sinh', 'Thông tin tuyển sinh mẫu',
         'Trang tuyển sinh demo.',
         '<p>Chỉ tiêu, ngành và học phí sẽ do {org} công bố chính thức. Không sử dụng số liệu trong bài này.</p>'),
        ('tuyen-sinh', 'Hướng dẫn hồ sơ tuyển sinh mẫu',
         'Hướng dẫn mẫu.',
         '<p>Các bước nộp hồ sơ mang tính minh họa. Liên hệ phòng tuyển sinh: [Email].</p>'),
        ('nghien-cuu', 'Định hướng nghiên cứu mẫu',
         'Giới thiệu hướng nghiên cứu demo.',
         '<p>Các nhóm nghiên cứu và công bố sẽ được liệt kê khi có dữ liệu thật từ {org}.</p>'),
        ('tin-tuc', 'Hợp tác đối ngoại mẫu',
         'Tin hợp tác demo.',
         '<p>Thông tin đối tác và biên bản ghi nhớ sẽ được đăng khi có nguồn chính thức.</p>'),
    ],
    'hospital': [
        ('tin-tuc', 'Chào mừng đến với cổng thông tin {org}', 'Giới thiệu mẫu.', '<p>{org} — nội dung demo. Địa chỉ: [Địa chỉ].</p>'),
        ('thong-bao', 'Lịch khám mẫu', 'Lịch khám placeholder.', '<p>Giờ khám: [Giờ làm việc]. Đặt lịch: [Số điện thoại].</p>'),
        ('dich-vu', 'Dịch vụ khám chữa bệnh mẫu', 'Mô tả dịch vụ demo.', '<p>Danh mục dịch vụ thật do {org} cập nhật.</p>'),
        ('lich-kham', 'Hướng dẫn đặt lịch mẫu', 'Hướng dẫn demo.', '<p>Gọi [Số điện thoại] hoặc email [Email].</p>'),
        ('tin-tuc', 'Hoạt động cộng đồng mẫu', 'Tin cộng đồng demo.', '<p>Sự kiện minh họa, không phải lịch sử thật.</p>'),
        ('thong-bao', 'Thông báo nghỉ lễ mẫu', 'Thông báo demo.', '<p>Lịch nghỉ cụ thể: do {org} công bố.</p>'),
        ('dich-vu', 'Gói khám sức khỏe mẫu', 'Gói dịch vụ demo.', '<p>Bảng giá và danh mục sẽ được cập nhật sau.</p>'),
        ('tin-tuc', 'Đội ngũ chuyên môn mẫu', 'Giới thiệu demo.', '<p>Hồ sơ bác sĩ/chuyên gia do {org} cung cấp — không liệt kê tên giả.</p>'),
    ],
    'company': [
        ('tin-tuc', 'Chào mừng đến với {org}', 'Giới thiệu công ty mẫu.', '<p>{org} — trang demo. Liên hệ: [Email].</p>'),
        ('san-pham', 'Sản phẩm / giải pháp mẫu', 'Mô tả sản phẩm demo.', '<p>Chi tiết sản phẩm sẽ do {org} cập nhật.</p>'),
        ('tuyen-dung', 'Tuyển dụng mẫu', 'JD placeholder.', '<p>Vị trí và yêu cầu thật đăng trên kênh tuyển dụng chính thức của {org}.</p>'),
        ('thong-bao', 'Thông báo nội bộ mẫu', 'Thông báo demo.', '<p>Dành cho minh họa giao diện.</p>'),
        ('tin-tuc', 'Sự kiện ra mắt mẫu', 'Sự kiện demo.', '<p>Địa điểm: [Địa chỉ]. Không phải sự kiện có thật.</p>'),
        ('san-pham', 'Tính năng nổi bật mẫu', 'Feature list demo.', '<p>Các tính năng mang tính minh họa.</p>'),
        ('tin-tuc', 'Đối tác chiến lược mẫu', 'Tin đối tác demo.', '<p>Tên đối tác thật sẽ được bổ sung khi có thỏa thuận.</p>'),
        ('tuyen-dung', 'Văn hóa doanh nghiệp mẫu', 'Culture page demo.', '<p>Nội dung văn hóa do {org} biên soạn.</p>'),
    ],
    'agency': [
        ('tin-tuc', 'Chào mừng đến với cổng {org}', 'Giới thiệu mẫu.', '<p>{org} — nội dung demo. [Địa chỉ] — [Email].</p>'),
        ('van-ban', 'Văn bản hướng dẫn mẫu', 'Văn bản demo.', '<p>Không phải văn bản quy phạm. Thay bằng file PDF chính thức khi có.</p>'),
        ('thu-tuc', 'Thủ tục hành chính mẫu', 'Quy trình demo.', '<p>Thành phần hồ sơ và phí do {org} công bố.</p>'),
        ('thong-bao', 'Thông báo công khai mẫu', 'Thông báo demo.', '<p>Nội dung placeholder.</p>'),
        ('tin-tuc', 'Hoạt động chuyên môn mẫu', 'Tin hoạt động demo.', '<p>Sự kiện minh họa tại [Địa chỉ].</p>'),
        ('thu-tuc', 'Tra cứu hồ sơ mẫu', 'Hướng dẫn demo.', '<p>Cổng tra cứu thật sẽ được liên kết sau.</p>'),
        ('van-ban', 'Biểu mẫu điện tử mẫu', 'Danh sách biểu mẫu demo.', '<p>Tải biểu mẫu chính thức từ {org}.</p>'),
        ('thong-bao', 'Lịch tiếp công dân mẫu', 'Lịch demo.', '<p>Thời gian: [Giờ làm việc].</p>'),
    ],
}

templates = ARTICLES_BY_SECTOR.get(SECTOR, ARTICLES_BY_SECTOR['university'])
key_to_id = {c[3]: c[0] for c in cats}

articles = []
for i, (key, title, summary, body) in enumerate(templates):
    articles.append({
        'url': f'https://example.invalid/sample/{i+1}',
        'title': title.format(org=ORG),
        'date': day(3 * i + 1),
        'summary': summary.format(org=ORG),
        'body': NOTICE + body.format(org=ORG),
        'cats': [key],
        'homeimg': '',
    })

pages = {
    'gioi-thieu-chung': {
        'title': f'Giới thiệu {ORG}',
        'url': 'https://example.invalid/about',
        'body': NOTICE + f'<p>{ORG} là tổ chức thuộc lĩnh vực <em>{SECTOR}</em>. Sứ mạng, tầm nhìn và lịch sử sẽ được cập nhật bởi chủ sở hữu website. Địa chỉ: [Địa chỉ].</p>',
    },
    'lien-he': {
        'title': 'Liên hệ',
        'url': 'https://example.invalid/contact',
        'body': NOTICE + '<ul><li>Địa chỉ: [Địa chỉ]</li><li>Điện thoại: [Số điện thoại]</li><li>Email: [Email]</li><li>Giờ làm việc: [Giờ làm việc]</li></ul>',
    },
}

# seed_template.php expects categories via its own $cats map — write a sidecar for humans
meta = {
    'org_name': ORG, 'sector': SECTOR, 'slug': SLUG,
    'categories': [{'id': c[0], 'title': c[1], 'alias': c[2], 'key': c[3]} for c in cats],
    'contact': {'address': '[Địa chỉ]', 'phone': '[Số điện thoại]', 'email': '[Email]', 'hours': '[Giờ làm việc]'},
    'note': 'All articles/pages are SAMPLE CONTENT. Replace before production.',
}
(OUT / 'articles.json').write_text(json.dumps(articles, ensure_ascii=False, indent=2), encoding='utf-8')
(OUT / 'pages.json').write_text(json.dumps(pages, ensure_ascii=False, indent=2), encoding='utf-8')
(OUT / 'sample_meta.json').write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding='utf-8')
print(f'{len(articles)} articles, {len(pages)} pages → {OUT}')
print('Categories keys for seed map:', [c[3] for c in cats])
