<?php

uses(Tests\TestCase::class);
use Illuminate\Support\Facades\Log;
use App\Domains\Price\Contracts\ExternalPriceProviderInterface;
use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;
use App\Domains\Price\Services\PriceSyncService;

it('logs an error when price synchronization fails', function () {
    // Arrange
    $countryId = 1;
    
    $providerMock = Mockery::mock(ExternalPriceProviderInterface::class);
    $providerMock->shouldReceive('fetchLatestPrices')
        ->once()
        ->andThrow(new \Exception('API connection failed'));
        
    $repositoryMock = Mockery::mock(PriceRepositoryInterface::class);
    
    $service = new PriceSyncService($repositoryMock, $providerMock);

    // Assert that the error is logged
    Log::shouldReceive('error')
        ->once()
        ->with(Mockery::on(function ($message) use ($countryId) {
            return str_contains($message, "Failed to sync prices for country {$countryId}");
        }));

    // Act
    expect(fn() => $service->syncPrices($countryId))->toThrow(Exception::class);
});
