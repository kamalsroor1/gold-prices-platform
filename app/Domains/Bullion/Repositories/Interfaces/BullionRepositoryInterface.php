<?php

namespace App\Domains\Bullion\Repositories\Interfaces;

interface BullionRepositoryInterface
{
    public function getAll(int $countryId);
}
