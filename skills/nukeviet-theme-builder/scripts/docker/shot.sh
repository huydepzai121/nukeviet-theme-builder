#!/usr/bin/env bash
# Screenshots via Playwright container (no host Node required).
# Usage: ./docker/shot.sh http://localhost:8080 /
# Writes .work/shots/home-desktop.png and home-mobile.png
set -euo pipefail
cd "$(dirname "$0")/.."
BASE=${1:-http://host.docker.internal:${HTTP_PORT:-8080}}
PATHS=${2:-/}
mkdir -p .work/shots
# On Linux, host.docker.internal may need --add-host; also try host network gateway
EXTRA=()
if [ "$(uname -s)" = Linux ]; then
  EXTRA+=(--add-host=host.docker.internal:host-gateway)
fi
docker run --rm "${EXTRA[@]}" \
  -v "$(pwd)/.work/shots:/out" \
  mcr.microsoft.com/playwright:v1.49.1-jammy \
  bash -lc "
    npx --yes playwright@1.49.1 install chromium >/dev/null 2>&1 || true
    node <<'NODE'
const { chromium } = require('playwright');
(async () => {
  const base = process.env.BASE || '$BASE';
  const browser = await chromium.launch({ args: ['--no-sandbox'] });
  for (const [w, name, mobile] of [[1440,'home-desktop',false],[390,'home-mobile',true]]) {
    const page = await browser.newPage({ viewport: { width: w, height: 900 }, isMobile: mobile, hasTouch: mobile });
    await page.goto(base + '/', { waitUntil: 'networkidle', timeout: 60000 });
    await page.evaluate(async () => { for (let y=0;y<document.body.scrollHeight;y+=600){ window.scrollTo(0,y); await new Promise(r=>setTimeout(r,80)); } window.scrollTo(0,0); });
    await page.waitForTimeout(500);
    await page.screenshot({ path: '/out/' + name + '.png', fullPage: true });
    console.log('ok', name);
    await page.close();
  }
  await browser.close();
})();
NODE
  " 
echo "Screenshots in .work/shots/"
