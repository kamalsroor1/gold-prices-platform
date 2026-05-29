<?php

namespace App\Domains\Bullion\Services;

use App\Domains\Bullion\Repositories\Interfaces\BullionRepositoryInterface;

class BullionService
{
    protected $bullionRepository;

    public function __construct(BullionRepositoryInterface $bullionRepository)
    {
        $this->bullionRepository = $bullionRepository;
    }

    public function getBullions(int $countryId)
    {
        return $this->bullionRepository->getAll($countryId);
    }
}
