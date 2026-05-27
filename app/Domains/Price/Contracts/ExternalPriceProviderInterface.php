<?php

namespace App\Domains\Price\Contracts;

interface ExternalPriceProviderInterface
{
    /**
     * @return array<string, float>
     */
    public function fetchLatestPrices(): array;
}
