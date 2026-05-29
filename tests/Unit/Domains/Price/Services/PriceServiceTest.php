<?php

use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;
use App\Domains\Price\Services\PriceService;

it('gets the latest price from the repository', function () {
    // Arrange
    $countryId = 1;
    $mockPrice = ['price' => 100];
    
    $repositoryMock = \Mockery::mock(PriceRepositoryInterface::class);
    $repositoryMock->shouldReceive('getLatestPrice')
        ->once()
        ->with($countryId)
        ->andReturn($mockPrice);
    
    $service = new PriceService($repositoryMock);

    // Act
    $result = $service->getLatestPrice($countryId);

    // Assert
    expect($result)->toBe($mockPrice);
});
