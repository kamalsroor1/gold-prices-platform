<?php

namespace App\Domains\Price\Repositories\Implementations;

use App\Domains\Price\Models\GoldPrice;
use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;

class EloquentPriceRepository implements PriceRepositoryInterface
{
    public function getLatestPrice(int $countryId)
    {
        return GoldPrice::where('country_id', $countryId)->get();
    }

    public function create(array $data)
    {
        return GoldPrice::create($data);
    }

    public function getHistory(int $countryId, ?int $karat = null, ?string $startDate = null, ?string $endDate = null, int $perPage = 15)
    {
        $query = \Illuminate\Support\Facades\DB::table('gold_price_history')
            ->where('country_id', $countryId);

        if ($karat) {
            $query->where('karat', $karat);
        }

        if ($startDate) {
            $query->whereDate('created_at', '>=', $startDate);
        }

        if ($endDate) {
            $query->whereDate('created_at', '<=', $endDate);
        }

        return $query->orderBy('created_at', 'desc')->paginate($perPage);
    }
}
