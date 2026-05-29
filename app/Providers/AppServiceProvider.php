<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(
            \App\Domains\Country\Repositories\Interfaces\CountryRepositoryInterface::class,
            \App\Domains\Country\Repositories\Implementations\EloquentCountryRepository::class
        );

        $this->app->bind(
            \App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface::class,
            \App\Domains\Price\Repositories\Implementations\EloquentPriceRepository::class
        );

        $this->app->bind(
            \App\Domains\Price\Contracts\ExternalPriceProviderInterface::class,
            \App\Domains\Price\Providers\MockGoldPriceProvider::class
        );

        $this->app->bind(
            \App\Domains\Bullion\Repositories\Interfaces\BullionRepositoryInterface::class,
            \App\Domains\Bullion\Repositories\Implementations\EloquentBullionRepository::class
        );

        $this->app->bind(
            \App\Domains\Alert\Repositories\Interfaces\AlertRepositoryInterface::class,
            \App\Domains\Alert\Repositories\Implementations\EloquentAlertRepository::class
        );
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
