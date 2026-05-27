<?php

namespace App\Domains\Price\Providers;

use App\Domains\Price\Contracts\ExternalPriceProviderInterface;

class MockGoldPriceProvider implements ExternalPriceProviderInterface
{
    public function fetchLatestPrices(): array
    {
        // Mock data
        return [
            '24k' => 2500.00,
            '21k' => 2187.50,
        ];
    }
}
