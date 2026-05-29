<?php

namespace App\Domains\Bullion\Repositories\Implementations;

use App\Domains\Bullion\Models\Bullion;
use App\Domains\Bullion\Repositories\Interfaces\BullionRepositoryInterface;

class EloquentBullionRepository implements BullionRepositoryInterface
{
    public function getAll(int $countryId)
    {
        // Simple mock for now
        return Bullion::all();
    }
}
