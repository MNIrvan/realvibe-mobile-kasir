<?php

<<<<<<< HEAD
=======
use Illuminate\Foundation\Application;
>>>>>>> 7c57db720f0eaac1a8d7a2d80c0b0e3db15139c6
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

<<<<<<< HEAD
// 1. Mengecek apakah aplikasi sedang dalam mode perbaikan (maintenance mode)
=======
// Determine if the application is in maintenance mode...
>>>>>>> 7c57db720f0eaac1a8d7a2d80c0b0e3db15139c6
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

<<<<<<< HEAD
// 2. Memanggil Autoloader Composer (Agar class Laravel bisa terbaca)
require __DIR__.'/../vendor/autoload.php';

// 3. Menjalankan Bootstrap Laravel (Menyalakan mesin utama)
(require_once __DIR__.'/../bootstrap/app.php')
    ->handleRequest(Request::capture());
=======
// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
/** @var Application $app */
$app = require_once __DIR__.'/../bootstrap/app.php';

$app->handleRequest(Request::capture());




>>>>>>> 7c57db720f0eaac1a8d7a2d80c0b0e3db15139c6
