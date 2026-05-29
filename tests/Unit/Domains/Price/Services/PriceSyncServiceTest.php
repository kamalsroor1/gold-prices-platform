<?php

use App\Domains\Price\Contracts\ExternalPriceProviderInterface;
use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;
use App\Domains\Price\Services\PriceSyncService;

it('syncs prices from external provider to repository', function () {
    // Arrange
    $countryId = 1;
    $mockPrices = [
        '24k' => 100.0,
        '21k' => 90.0,
    ];
    
    $providerMock = \Mockery::mock(ExternalPriceProviderInterface::class);
    $providerMock->shouldReceive('fetchLatestPrices')
        ->once()
        ->andReturn($mockPrices);
        
    $repositoryMock = \Mockery::mock(PriceRepositoryInterface::class);
    
    // Expect repository to be called for each price
    $repositoryMock->shouldReceive('create')
        ->twice()
        ->with(\Mockery::on(function ($argument) use ($countryId, $mockPrices) {
            return $argument['country_id'] === $countryId &&
                   in_array($argument['karat'], array_keys($mockPrices)) &&
                   $argument['price'] === $mockPrices[$argument['karat']];
        }));
    
    $service = new PriceSyncService($repositoryMock, $providerMock);

    // Act
    $service->syncPrices($countryId);

    // Assert
    // Expectations are handled by Mockery's count and constraints
    expect(true)->toBeTrue();
});
