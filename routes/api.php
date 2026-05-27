<?php

use Illuminate\Support\Facades\Route;
use App\Domains\Country\Http\Controllers\CountryController;
use App\Domains\Price\Http\Controllers\PriceController;

Route::prefix('v1')->group(function () {
    Route::get('/countries', [CountryController::class, 'index']);
    Route::get('/prices/latest', [PriceController::class, 'latest']);
});
