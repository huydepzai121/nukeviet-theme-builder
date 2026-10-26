<?php
// Router for `php -S host:port router.php`. Set NV_ROOT to the NukeViet site dir (default ./site).
$root = rtrim(getenv('NV_ROOT') ?: __DIR__ . '/site', '/');
$p = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
if ($p !== '/' && file_exists($root . $p)) {
    if (is_dir($root . $p)) {
        if (substr($p, -1) !== '/') { header('Location: ' . $p . '/', true, 301); exit; }
        if (file_exists($root . $p . 'index.php')) {           // e.g. /admin/
            $_SERVER['SCRIPT_NAME'] = $_SERVER['PHP_SELF'] = $p . 'index.php';
            $_SERVER['SCRIPT_FILENAME'] = $root . $p . 'index.php';
            chdir($root . $p);
            require $root . $p . 'index.php';
            return true;
        }
    }
    if (preg_match('/\.php$/', $p)) { chdir(dirname($root . $p)); require $root . $p; return true; }
    return false;                                               // static file
}
$_SERVER['SCRIPT_NAME'] = $_SERVER['PHP_SELF'] = '/index.php';
$_SERVER['SCRIPT_FILENAME'] = $root . '/index.php';
chdir($root);
require $root . '/index.php';
