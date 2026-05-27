<?php

namespace App\Domains\Price\Repositories\Implementations;

use App\Domains\Price\Models\GoldPrice;
use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;

class EloquentPriceRepository implements PriceRepositoryInterface
{
    public function getLatestPrice(int $countryId)
    {
        return GoldPrice::where('country_id', $countryId)
            ->latest()
            ->first();
    }

    public function create(array $data)
    {
        return GoldPrice::create($data);
    }
}
