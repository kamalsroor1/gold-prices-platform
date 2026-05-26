<?php

namespace App\Domains\Country\Repositories\Implementations;

use App\Domains\Country\Models\Country;
use App\Domains\Country\Repositories\Interfaces\CountryRepositoryInterface;

class EloquentCountryRepository implements CountryRepositoryInterface
{
    public function getAllActive()
    {
        return Country::where('is_active', true)->get();
    }
}