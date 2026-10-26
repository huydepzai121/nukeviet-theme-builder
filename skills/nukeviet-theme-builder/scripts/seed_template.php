<?php
// Generic content importer template. Run: DB_NAME=x DB_USER=x DB_PASS=x THEME=x SLUG=x php seed_template.php
// Input: articles.json [{url,title,date:"dd/mm/YYYY",summary,body,homeimg?,cats:[key]}], pages.json {alias:{title,url,body}}
// Credentials come from env (or credentials.txt) - never hard-code them.
$env = fn($k, $d = null) => getenv($k) ?: $d;
$db = new PDO('mysql:host=localhost;dbname=' . $env('DB_NAME') . ';charset=utf8mb4', $env('DB_USER'), $env('DB_PASS'));
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$P = $env('PREFIX', 'nv4'); $L = $env('LANG_DATA', 'vi'); $T = "{$P}_{$L}";
$theme = $env('THEME'); $org = $env('ORG_NAME', '');
$dir = $env('DATA_DIR', __DIR__);
$arts = json_decode(file_get_contents("$dir/articles.json"), true);
$pages = json_decode(file_get_contents("$dir/pages.json"), true) ?: [];

// 1) Categories: catid => [title, alias]; map scraped category keys -> catid. EDIT THESE from the real site.
$cats = [1 => ['Tin tức', 'Tin-tuc'], 2 => ['Thông báo', 'Thong-bao']];
$map  = ['tin-tuc' => 1, 'thong-bao' => 2];
$st = $db->prepare("UPDATE {$T}_news_cat SET title=?, alias=?, titlesite=?, description=?, parentid=0, weight=?, sort=?, status=1 WHERE catid=?");
foreach ($cats as $id => $c) $st->execute([$c[0], $c[1], $c[0], $c[0], $id, $id, $id]); // add INSERTs if more cats than the sample data

// 2) Wipe sample news
foreach (['rows', 'detail', 'tags_id', 'block', 'tags'] as $t) $db->exec("DELETE FROM {$T}_news_$t");
foreach ($db->query("SELECT catid FROM {$T}_news_cat")->fetchAll(PDO::FETCH_COLUMN) as $c) $db->exec("DELETE FROM {$T}_news_$c");

// 3) Articles (newest first => highest weight). Real date; time is synthetic - tell the user.
$key = fn($d) => implode('', array_reverse(explode('/', $d)));
usort($arts, fn($a, $b) => strcmp($key($b['date']), $key($a['date'])));
$ins = $db->prepare("INSERT INTO {$T}_news_rows (id,catid,listcatid,topicid,admin_id,author,sourceid,addtime,edittime,status,weight,publtime,exptime,archive,title,alias,hometext,homeimgfile,homeimgalt,homeimgthumb,inhome,allowed_comm,allowed_rating,external_link,hitstotal,hitscm,total_rating,click_rating) VALUES (?,?,?,0,1,?,0,?,?,1,?,?,0,0,?,?,?,?,?,?,1,'4',1,0,0,0,0,0)");
$insd = $db->prepare("INSERT INTO {$T}_news_detail (id,titlesite,description,bodyhtml,voicedata,keywords,sourcetext,files,reject_reason,imgposition,layout_func,copyright,allowed_send,allowed_print,allowed_save) VALUES (?,?,?,?,'','',?,'','',2,'',0,1,1,1)");
$n = count($arts);
foreach ($arts as $i => $a) {
    $id = $i + 1;
    $list = array_values(array_unique(array_map(fn($c) => $map[$c], $a['cats'])));
    [$d, $m, $y] = explode('/', $a['date']);
    $tm = mktime(8, 0, 0, (int)$m, (int)$d, (int)$y) + ($n - $i) * 60;
    $alias = substr(preg_replace('/[^A-Za-z0-9-]/', '', basename(parse_url($a['url'], PHP_URL_PATH))), 0, 240);
    $body = $a['body'];
    if (strpos($body, 'Nguồn:') === false) $body .= '<p><em>Nguồn: <a href="' . htmlspecialchars($a['url']) . '" target="_blank" rel="noopener">' . parse_url($a['url'], PHP_URL_HOST) . '</a></em></p>';
    $img = $a['homeimg'] ?? '';   // relative to uploads/news/
    $ins->execute([$id, $list[0], implode(',', $list), $org, $tm, $tm, $n - $i, $tm, $a['title'], $alias, $a['summary'], $img, $a['title'], $img ? 2 : 0]);
    $insd->execute([$id, $a['title'], $a['summary'], $body, $a['url']]);
    foreach ($list as $c) $db->exec("INSERT INTO {$T}_news_$c SELECT * FROM {$T}_news_rows WHERE id=$id");
}

// 4) About pages (module "about" = page module)
if ($pages) {
    $db->exec("DELETE FROM {$T}_about");
    $pi = $db->prepare("INSERT INTO {$T}_about (title,alias,image,imagealt,imageposition,description,bodytext,keywords,socialbutton,activecomm,layout_func,weight,admin_id,add_time,edit_time,status,hitstotal,hot_post) VALUES (?,?,'','',0,?,?,'',1,'','',?,1,?,?,1,0,0)");
    $w = 0;
    foreach ($pages as $alias => $p) {
        $b = $p['body'] . '<p><em>Nguồn: <a href="' . htmlspecialchars($p['url']) . '" target="_blank" rel="noopener">' . parse_url($p['url'], PHP_URL_HOST) . '</a></em></p>';
        $desc = mb_substr(trim(preg_replace('/\s+/u', ' ', html_entity_decode(strip_tags($p['body'])))), 0, 250);
        $pi->execute([$p['title'], $alias, $desc, $b, ++$w, time(), time()]);
    }
}

// 5) Site config (values must come from the real site)
$u = fn($k, $v, $lang) => $db->prepare("UPDATE {$P}_config SET config_value=? WHERE config_name=? AND lang=?")->execute([$v, $k, $lang]);
if ($org) $u('site_name', $org, $L);
if ($theme) $u('site_theme', $theme, $L);

// 6) Layouts + blocks for the new theme copied from default
if ($theme) {
    $db->prepare("DELETE FROM {$T}_modthemes WHERE theme=?")->execute([$theme]);
    $db->prepare("INSERT INTO {$T}_modthemes (func_id,layout,theme) SELECT func_id,layout,? FROM {$T}_modthemes WHERE theme='default'")->execute([$theme]);
    $db->prepare("DELETE w FROM {$T}_blocks_weight w JOIN {$T}_blocks_groups g ON g.bid=w.bid WHERE g.theme=?")->execute([$theme]);
    $db->prepare("DELETE FROM {$T}_blocks_groups WHERE theme=?")->execute([$theme]);
    foreach ($db->query("SELECT * FROM {$T}_blocks_groups WHERE theme='default'")->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $old = $r['bid']; unset($r['bid']); $r['theme'] = $theme;   // filter / move positions here
        $db->prepare("INSERT INTO {$T}_blocks_groups (" . implode(',', array_keys($r)) . ") VALUES (" . implode(',', array_fill(0, count($r), '?')) . ")")->execute(array_values($r));
        $nb = $db->lastInsertId();
        $db->exec("INSERT INTO {$T}_blocks_weight (bid,func_id,weight) SELECT $nb,func_id,weight FROM {$T}_blocks_weight WHERE bid=$old");
    }
}
echo "articles: $n, pages: " . count($pages) . "\n";
