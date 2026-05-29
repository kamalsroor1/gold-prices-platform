<?php

use Illuminate\Support\Facades\Route;
use App\Domains\Auth\Http\Controllers\AuthController;
use App\Domains\Country\Http\Controllers\CountryController;
use App\Domains\Price\Http\Controllers\PriceController;
use App\Domains\Bullion\Http\Controllers\BullionController;
use App\Domains\Alert\Http\Controllers\AlertController;

Route::prefix('v1')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::middleware('auth.token')->post('/logout', [AuthController::class, 'logout']);

    Route::get('/countries', [CountryController::class, 'index']);
    Route::get('/prices/latest', [PriceController::class, 'latest']);
    Route::get('/bullions', [BullionController::class, 'index']);
    
    Route::middleware('auth.token')->group(function () {
        Route::get('/alerts', [AlertController::class, 'index']);
        Route::post('/alerts', [AlertController::class, 'store']);
        Route::delete('/alerts/{id}', [AlertController::class, 'destroy']);
    });
});
