<?php

namespace App\Domains\Country\Services;

use App\Domains\Country\Repositories\Interfaces\CountryRepositoryInterface;

class CountryService
{
    protected $countryRepository;

    public function __construct(CountryRepositoryInterface $countryRepository)
    {
        $this->countryRepository = $countryRepository;
    }

    public function getActiveCountries()
    {
        return $this->countryRepository->getAllActive();
    }
}
