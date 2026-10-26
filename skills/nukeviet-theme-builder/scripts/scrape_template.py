#!/usr/bin/env python3
"""Scrape real articles/pages from an official site. Adjust BASE, LISTS, regexes to the site's HTML.
Downloads images to SITE/uploads/news/SLUG/ and rewrites src. Outputs articles.json, pages.json.
Usage: BASE=https://example.edu.vn SITE=/path/site SLUG=example python3 scrape_template.py"""
import os, re, json, html, subprocess, urllib.parse
from concurrent.futures import ThreadPoolExecutor
BASE = os.environ['BASE'].rstrip('/'); SITE = os.environ['SITE']; SLUG = os.environ.get('SLUG', 'site')
PER_CAT = int(os.environ.get('PER_CAT', '5'))
LISTS = {'tin-tuc': '/tin-tuc', 'thong-bao': '/thong-bao'}     # category key -> listing path (EDIT)
PAGES = {'gioi-thieu-chung': '/gioi-thieu'}                     # alias -> about page path (EDIT)
LINK_RE = r'<a href="(/[^"]+)"[^>]*>.*?\((\d\d/\d\d/\d{4})\)'   # article link + date in listing (EDIT)
TITLE_RE = r'<h1[^>]*>(.*?)</h1>'
BODY_MARK = 'field-name-body'                                    # class/id near the article body (EDIT)
UP = f'{SITE}/uploads/news/{SLUG}'; os.makedirs(UP, exist_ok=True)

def get(u): return subprocess.run(['curl', '-skL', '--max-time', '40', '-A', 'Mozilla/5.0', u], capture_output=True).stdout.decode('utf-8', 'ignore')
def body_of(a):
    i = a.find(BODY_MARK)
    if i < 0: return ''
    s = a.find('>', a.find('<div', i)) + 1; d = 1; p = s
    while d > 0:                      # balance nested divs
        m = re.search(r'<(/?)div\b', a[p:])
        if not m: break
        p += m.end(); d += -1 if m.group(1) else 1
    return re.sub(r'(src|href)="/(?!/)', r'\1="' + BASE + '/', a[s:p - 5].strip())
def text(b): return html.unescape(re.sub(r'\s+', ' ', re.sub(r'<[^>]+>', ' ', b))).strip()

jobs = {}
def localize(body, prefix):
    k = [0]; first = []
    def rep(m):
        u = m.group(1)
        if not u.startswith('http'): return m.group(0)
        k[0] += 1; ext = os.path.splitext(urllib.parse.urlparse(u).path)[1].lower()
        fn = f'{prefix}-{k[0]}' + (ext if ext in ('.jpg', '.jpeg', '.png', '.gif', '.webp') else '.jpg')
        jobs[fn] = u; first.append(fn)
        return f'src="/uploads/news/{SLUG}/{fn}"'
    return re.sub(r'src="([^"]+)"', rep, body), (first[0] if first else '')

items = {}
for key, path in LISTS.items():
    for m in re.finditer(LINK_RE, get(BASE + path), re.S):
        u = m.group(1)
        if u in items: items[u]['cats'].append(key); continue
        if sum(1 for x in items.values() if x['cats'][0] == key) >= PER_CAT: continue
        items[u] = {'url': BASE + u, 'date': m.group(2), 'cats': [key]}
arts = []
for i, it in enumerate(items.values(), 1):
    a = get(it['url']); t = re.search(TITLE_RE, a, re.S); b = body_of(a)
    if not t or not b: print('skip', it['url']); continue
    it['title'] = html.unescape(re.sub(r'<[^>]+>', '', t.group(1))).strip()
    it['summary'] = re.split(r'(?<=[.!?])\s', text(b))[0][:400]
    it['body'], img = localize(b, f'a{i:02d}')
    if img: it['homeimg'] = f'{SLUG}/{img}'
    arts.append(it)
pages = {}
for alias, path in PAGES.items():
    a = get(BASE + path); t = re.search(TITLE_RE, a, re.S)
    body, _ = localize(body_of(a), f'p-{alias}')
    pages[alias] = {'url': BASE + path, 'title': text(t.group(1)) if t else alias, 'body': body}
def fetch(kv):
    fn, u = kv
    r = subprocess.run(['curl', '-skL', '--max-time', '60', '-A', 'Mozilla/5.0', '-o', f'{UP}/{fn}', '-w', '%{http_code}', u.replace(' ', '%20')], capture_output=True, text=True)
    return fn, r.stdout
with ThreadPoolExecutor(8) as ex:
    for fn, code in ex.map(fetch, jobs.items()):
        if code != '200': print('FAIL', fn, code)
json.dump(arts, open('articles.json', 'w'), ensure_ascii=False, indent=1)
json.dump(pages, open('pages.json', 'w'), ensure_ascii=False, indent=1)
print(len(arts), 'articles,', len(pages), 'pages,', len(jobs), 'images')
