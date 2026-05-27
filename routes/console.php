<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;
use App\Domains\Country\Services\CountryService;
use App\Domains\Price\Jobs\SyncGoldPricesJob;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Schedule::call(function () {
    $countryService = app(CountryService::class);
    $countries = $countryService->getActiveCountries();
    foreach ($countries as $country) {
        SyncGoldPricesJob::dispatch($country->id);
    }
})->hourly();
