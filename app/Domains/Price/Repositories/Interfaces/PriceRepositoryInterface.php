<?php

namespace App\Domains\Price\Repositories\Interfaces;

interface PriceRepositoryInterface
{
    public function getLatestPrice(int $countryId);
    public function create(array $data);
    public function getHistory(int $countryId, ?int $karat = null, ?string $startDate = null, ?string $endDate = null, int $perPage = 15);
}
