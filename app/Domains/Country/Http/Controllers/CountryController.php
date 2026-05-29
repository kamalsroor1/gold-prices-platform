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

    /**
     * @OA\Get(
     *     path="/countries",
     *     summary="Get list of active countries",
     *     description="Returns a list of all active countries in the system",
     *     operationId="getCountriesList",
     *     tags={"Countries"},
     *     @OA\Response(
     *         response=200,
     *         description="Successful operation",
     *         @OA\JsonContent(
     *             type="array",
     *             @OA\Items(ref="#/components/schemas/CountryResource")
     *         )
     *     )
     * )
     */
    public function index()
    {
        return CountryResource::collection($this->countryService->getActiveCountries());
    }
}
