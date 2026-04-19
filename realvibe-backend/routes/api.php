<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\KeretaController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/


Route::controller(AuthController::class)->group(function () {
    Route::post('/login', 'login');
    Route::post('/register', 'register');
    Route::post('/logout', 'logout')->middleware('auth:sanctum');
});

// Menu CRUD Routes
Route::apiResource('menu', MenuController::class);

// Kereta Routes
Route::prefix('kereta')->group(function () {
    Route::get('/', [KeretaController::class, 'index']);
    Route::post('/', [KeretaController::class, 'store']);
    Route::get('/{id}', [KeretaController::class, 'show']);
    Route::post('/{id}/upload-foto', [KeretaController::class, 'uploadFoto']);
});
