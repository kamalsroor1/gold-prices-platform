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
}
