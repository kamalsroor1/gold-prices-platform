<?php

namespace App\Domains\Price\Services;

use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;

class PriceService
{
    protected $priceRepository;

    public function __construct(PriceRepositoryInterface $priceRepository)
    {
        $this->priceRepository = $priceRepository;
    }

    public function getLatestPrice(int $countryId)
    {
        return $this->priceRepository->getLatestPrice($countryId);
    }

    public function getHistory(int $countryId, ?int $karat = null, ?string $startDate = null, ?string $endDate = null, int $perPage = 15)
    {
        return $this->priceRepository->getHistory($countryId, $karat, $startDate, $endDate, $perPage);
    }
}
