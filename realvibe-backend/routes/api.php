<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\KeretaController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\InformasiController;
use App\Http\Controllers\Api\FeedbackController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\CashierSessionController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/


Route::controller(AuthController::class)->group(function () {
    Route::get('/user', function () {
        return response()->json([
            'status' => 'success',
            'message' => 'Backend is running',
        ]);
    });
    Route::post('/login', 'login');
    Route::post('/register', 'register');
    Route::post('/logout', 'logout')->middleware('auth:sanctum');
});

// Menu CRUD Routes
Route::get('/kategori-menu', [MenuController::class, 'getCategories']);
Route::apiResource('menu', MenuController::class);

// Kereta Routes
Route::prefix('kereta')->group(function () {
    Route::get('/', [KeretaController::class, 'index']);
    Route::post('/', [KeretaController::class, 'store']);
    Route::get('/{id}', [KeretaController::class, 'show']);
    Route::post('/{id}/upload-foto', [KeretaController::class, 'uploadFoto']);
    Route::put('/{id}', [KeretaController::class, 'update']);
    Route::delete('/{id}', [KeretaController::class, 'destroy']);
});

// Admin Dashboard Routes
Route::prefix('admin')->group(function () {
    Route::get('/dashboard/summary', [DashboardController::class, 'summary']);
    Route::get('/dashboard/chart', [DashboardController::class, 'chart']);

    Route::get('/laporan', [TransactionController::class, 'index']);
    Route::get('/laporan/export', [TransactionController::class, 'export']);

    Route::apiResource('informasi', InformasiController::class);
    Route::put('/informasi/{id}/toggle', [InformasiController::class, 'toggle']);

    Route::get('/masukan', [FeedbackController::class, 'index']);
    Route::put('/masukan/{id}/read', [FeedbackController::class, 'markAsRead']);

    Route::apiResource('users', UserController::class);
});

// Cashier Session Routes
Route::prefix('cashier-sessions')->group(function () {
    Route::get('/active', [CashierSessionController::class, 'active']);
    Route::post('/open', [CashierSessionController::class, 'open']);
    Route::post('/{sessionId}/close', [CashierSessionController::class, 'close']);
    Route::post('/{sessionId}/entries', [CashierSessionController::class, 'addEntry']);
    Route::put('/{sessionId}/entries/{entryId}', [CashierSessionController::class, 'updateEntry']);
    Route::delete('/{sessionId}/entries/{entryId}', [CashierSessionController::class, 'deleteEntry']);
});
