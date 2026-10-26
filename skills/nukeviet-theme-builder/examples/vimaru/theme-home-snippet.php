<?php
// Example (Vimaru build): paste inside nv_site_theme() in theme.php, before $xtpl->parse('main').
// Category ids (5=notices, 2=events, 6=admissions, 3/4=research) are site-specific.
// ===== VIMARU theme: menu + homepage sections =====
    global $db;
    $vmu_base = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA;
    $vmu_link = function ($l) {
        return preg_match('#^https?://#', $l) ? $l : nv_url_rewrite(str_replace('&', '&amp;', $l), true);
    };
    try {
        $vmu_menu = $db->query('SELECT id, parentid, title, link FROM ' . NV_PREFIXLANG . '_menu_rows WHERE mid=1 AND status=1 ORDER BY parentid, weight')->fetchAll();
    } catch (Exception $e) {
        $vmu_menu = [];
    }
    foreach ($vmu_menu as $m) {
        if ($m['parentid'] != 0) {
            continue;
        }
        $m['link'] = $vmu_link($m['link']);
        $m['target'] = preg_match('#^https?://#', $m['link']) ? ' target="_blank" rel="noopener"' : '';
        $has = false;
        foreach ($vmu_menu as $s) {
            if ($s['parentid'] == $m['id']) {
                $s['link'] = $vmu_link($s['link']);
                $s['target'] = preg_match('#^https?://#', $s['link']) ? ' target="_blank" rel="noopener"' : '';
                $xtpl->assign('VSUB', $s);
                $xtpl->parse('main.vmenu.sub.item');
                $has = true;
            }
        }
        if ($has) {
            $xtpl->parse('main.vmenu.sub');
            $m['cls'] = 'has-sub';
            $m['caret'] = ' <i class="fa fa-angle-down"></i>';
        } else {
            $m['cls'] = '';
            $m['caret'] = '';
        }
        $xtpl->assign('VMENU', $m);
        $xtpl->parse('main.vmenu');
    }
    if ($home) {
        $vmu_cats = [];
        $result = $db->query('SELECT catid, title, alias FROM ' . NV_PREFIXLANG . '_news_cat');
        while ($c = $result->fetch()) {
            $vmu_cats[$c['catid']] = $c;
        }
        $vmu_item = function ($r) use ($vmu_cats, $vmu_base) {
            $cat = $vmu_cats[$r['catid']] ?? ['title' => '', 'alias' => ''];
            return [
                'title' => $r['title'],
                'hometext' => nv_clean60(strip_tags($r['hometext']), 170),
                'cat' => $cat['title'],
                'date' => nv_date('d/m/Y', $r['publtime']),
                'day' => nv_date('d', $r['publtime']),
                'month' => nv_date('m', $r['publtime']),
                'year' => nv_date('Y', $r['publtime']),
                'img' => !empty($r['homeimgfile']) ? NV_BASE_SITEURL . NV_UPLOADS_DIR . '/news/' . $r['homeimgfile'] : NV_BASE_SITEURL . NV_UPLOADS_DIR . '/news/vimaru/site/logo-truong-240.png',
                'noimg' => empty($r['homeimgfile']) ? ' noimg' : '',
                'link' => nv_url_rewrite($vmu_base . '&amp;' . NV_NAME_VARIABLE . '=news&amp;' . NV_OP_VARIABLE . '=' . $cat['alias'] . '/' . $r['alias'] . '-' . $r['id'] . $GLOBALS['global_config']['rewrite_exturl'], true)
            ];
        };
        $sql = 'SELECT id, catid, title, alias, hometext, homeimgfile, publtime FROM ' . NV_PREFIXLANG . '_news_rows WHERE status=1 ';
        foreach ($db->query($sql . "AND homeimgfile!='' AND NOT FIND_IN_SET(5, listcatid) ORDER BY publtime DESC LIMIT 7")->fetchAll() as $i => $r) {
            $xtpl->assign('NEWS', $vmu_item($r));
            $xtpl->parse($i == 0 ? 'main.home.featured' : 'main.home.news');
        }
        foreach ($db->query($sql . 'AND FIND_IN_SET(5, listcatid) ORDER BY publtime DESC LIMIT 6')->fetchAll() as $r) {
            $xtpl->assign('NT', $vmu_item($r));
            $xtpl->parse('main.home.notice');
        }
        foreach ($db->query($sql . 'AND FIND_IN_SET(2, listcatid) ORDER BY publtime DESC LIMIT 4')->fetchAll() as $r) {
            $xtpl->assign('EV', $vmu_item($r));
            $xtpl->parse('main.home.event');
        }
        foreach ($db->query($sql . 'AND FIND_IN_SET(6, listcatid) ORDER BY publtime DESC LIMIT 3')->fetchAll() as $r) {
            $xtpl->assign('TS', $vmu_item($r));
            $xtpl->parse('main.home.ts');
        }
        foreach ($db->query($sql . "AND (FIND_IN_SET(4, listcatid) OR FIND_IN_SET(3, listcatid)) AND homeimgfile!='' ORDER BY publtime DESC LIMIT 4")->fetchAll() as $r) {
            $xtpl->assign('KH', $vmu_item($r));
            $xtpl->parse('main.home.kh');
        }
        $xtpl->parse('main.home');
    }
    // ===== end VIMARU =====
