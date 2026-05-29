<?php

use App\Domains\Country\Models\Country;

it('returns a list of active countries', function () {
    // Arrange: Seed data
    Country::create([
        'name' => 'Egypt',
        'code' => 'EG',
        'currency' => 'EGP',
        'is_active' => true,
    ]);

    Country::create([
        'name' => 'Saudi Arabia',
        'code' => 'SA',
        'currency' => 'SAR',
        'is_active' => false,
    ]);

    // Act
    $response = $this->getJson('/api/v1/countries');

    // Assert
    $response->assertStatus(200)
        ->assertJsonCount(1) // Only Egypt should be returned
        ->assertJsonFragment(['name' => 'Egypt'])
        ->assertJsonMissing(['name' => 'Saudi Arabia']);
});
