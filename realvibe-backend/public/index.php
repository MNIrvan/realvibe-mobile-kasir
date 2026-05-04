<?php

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Mengecek apakah aplikasi sedang dalam mode perbaikan (maintenance mode)
// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}
// 2. Memanggil Autoloader Composer (Agar class Laravel bisa terbaca)
require __DIR__.'/../vendor/autoload.php';

// 3. Menjalankan Bootstrap Laravel (Menyalakan mesin utama)
/** @var Application $app */
$app = require_once __DIR__.'/../bootstrap/app.php';

$app->handleRequest(Request::capture());
