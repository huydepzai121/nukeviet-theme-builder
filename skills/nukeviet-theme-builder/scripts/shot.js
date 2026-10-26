// Headless screenshots. npm i puppeteer-core ; CHROME=/usr/bin/google-chrome
// node shot.js '[["http://localhost:8090/",1440,"home-desktop.png",0],["http://localhost:8090/",390,"home-mobile.png",1]]'
const p = require('puppeteer-core');
(async () => {
  const b = await p.launch({ executablePath: process.env.CHROME || '/usr/bin/google-chrome', args: ['--no-sandbox', '--disable-gpu'] });
  for (const [url, w, out, mobile] of JSON.parse(process.argv[2])) {
    const pg = await b.newPage();
    await pg.setViewport({ width: w, height: 900, deviceScaleFactor: 1, isMobile: !!mobile, hasTouch: !!mobile });
    await pg.goto(url, { waitUntil: 'networkidle0', timeout: 60000 });
    await pg.evaluate(async () => { for (let y = 0; y < document.body.scrollHeight; y += 600) { window.scrollTo(0, y); await new Promise(r => setTimeout(r, 80)); } window.scrollTo(0, 0); }); // trigger lazy images
    await new Promise(r => setTimeout(r, 800));
    await pg.screenshot({ path: out, fullPage: true }); console.log('ok', out); await pg.close();
  }
  await b.close();
})();
