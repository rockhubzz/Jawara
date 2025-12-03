<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    // other protected API endpoints here
});

Route::get('/discover', function () {
    return response()->json(['server' => request()->ip()]);
});


use App\Http\Controllers\Api\UserController;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/users', [UserController::class, 'index']);
    Route::get('/users/{id}', [UserController::class, 'show']);
    Route::post('/users', [UserController::class, 'store']);
    Route::put('/users/{id}', [UserController::class, 'update']);
    Route::delete('/users/{id}', [UserController::class, 'destroy']);
});

use App\Http\Controllers\Api\KeluargaController;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/keluarga', [KeluargaController::class, 'index']);
    Route::get('/keluarga/{id}', [KeluargaController::class, 'show']);
    Route::post('/keluarga', [KeluargaController::class, 'store']);
    Route::put('/keluarga/{id}', [KeluargaController::class, 'update']);
    Route::delete('/keluarga/{id}', [KeluargaController::class, 'destroy']);
});
use App\Http\Controllers\Api\WargaController;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/warga', [WargaController::class, 'index']);
    Route::get('/warga/{id}', [WargaController::class, 'show']);
    Route::post('/warga', [WargaController::class, 'store']);
    Route::put('/warga/{id}', [WargaController::class, 'update']);
    Route::delete('/warga/{id}', [WargaController::class, 'destroy']);
});

use App\Http\Controllers\Api\RumahController;

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('rumah', RumahController::class);
    
});

use App\Http\Controllers\Api\KategoriIuranController;

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('kategori-iuran', KategoriIuranController::class);
});

use App\Http\Controllers\Api\TagihanIuranController;
Route::get('/tagihan', [TagihanIuranController::class, 'index']);
Route::post('/tagihan', [TagihanIuranController::class, 'store']);
Route::post('/tagihan/semua', [TagihanIuranController::class, 'storeAll']);
Route::get('/tagihan/{id}', [TagihanIuranController::class, 'show']);
Route::put('/tagihan/{id}', [TagihanIuranController::class, 'update']);
Route::delete('/tagihan/{id}', [TagihanIuranController::class, 'destroy']);

use App\Http\Controllers\Api\PemasukanLainController;

Route::get('/pemasukan', [PemasukanLainController::class, 'index']);
Route::post('/pemasukan', [PemasukanLainController::class, 'store']);
Route::get('/pemasukan/{id}', [PemasukanLainController::class, 'show']);
Route::put('/pemasukan/{id}', [PemasukanLainController::class, 'update']);
Route::delete('/pemasukan/{id}', [PemasukanLainController::class, 'destroy']);
