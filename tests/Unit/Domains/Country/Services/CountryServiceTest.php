<?php

use App\Domains\Country\Repositories\Interfaces\CountryRepositoryInterface;
use App\Domains\Country\Services\CountryService;

it('gets all active countries from the repository', function () {
    // Arrange
    $mockCountries = [
        ['id' => 1, 'name' => 'Egypt'],
        ['id' => 2, 'name' => 'Saudi Arabia'],
    ];
    
    $repositoryMock = \Mockery::mock(CountryRepositoryInterface::class);
    $repositoryMock->shouldReceive('getAllActive')
        ->once()
        ->andReturn($mockCountries);
    
    $service = new CountryService($repositoryMock);

    // Act
    $result = $service->getActiveCountries();

    // Assert
    expect($result)->toBe($mockCountries);
});
