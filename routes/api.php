<?php

use Illuminate\Support\Facades\Route;
use App\Domains\Country\Http\Controllers\CountryController;

Route::prefix('v1')->group(function () {
    Route::get('/countries', [CountryController::class, 'index']);
});
