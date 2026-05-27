<?php

namespace App\Domains\Price\Services;

use App\Domains\Price\Contracts\ExternalPriceProviderInterface;
use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;

class PriceSyncService
{
    protected $priceRepository;
    protected $priceProvider;

    public function __construct(
        PriceRepositoryInterface $priceRepository,
        ExternalPriceProviderInterface $priceProvider
    ) {
        $this->priceRepository = $priceRepository;
        $this->priceProvider = $priceProvider;
    }

    public function syncPrices(int $countryId)
    {
        $prices = $this->priceProvider->fetchLatestPrices();

        foreach ($prices as $karat => $price) {
            $this->priceRepository->create([
                'country_id' => $countryId,
                'karat' => $karat,
                'price' => $price,
            ]);
        }
    }
}
