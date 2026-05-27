<?php

namespace App\Domains\Price\Repositories\Interfaces;

interface PriceRepositoryInterface
{
    public function getLatestPrice(int $countryId);
    public function create(array $data);
}
