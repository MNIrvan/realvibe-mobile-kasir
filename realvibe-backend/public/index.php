<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Mengecek apakah aplikasi sedang dalam mode perbaikan (maintenance mode)
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// 2. Memanggil Autoloader Composer (Agar class Laravel bisa terbaca)
require __DIR__.'/../vendor/autoload.php';

// 3. Menjalankan Bootstrap Laravel (Menyalakan mesin utama)
(require_once __DIR__.'/../bootstrap/app.php')
    ->handleRequest(Request::capture());