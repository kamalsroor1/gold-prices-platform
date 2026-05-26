<?php

namespace App\Domains\Country\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Domains\Country\Services\CountryService;
use App\Domains\Country\Http\Resources\CountryResource;

class CountryController extends Controller
{
    protected $countryService;

    public function __construct(CountryService $countryService)
    {
        $this->countryService = $countryService;
    }

    public function index()
    {
        return CountryResource::collection($this->countryService->getActiveCountries());
    }
}
