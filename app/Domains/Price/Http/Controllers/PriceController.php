<?php

namespace App\Domains\Price\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Domains\Price\Services\PriceService;
use App\Domains\Price\Http\Resources\PriceResource;
use Illuminate\Http\Request;

class PriceController extends Controller
{
    protected $priceService;

    public function __construct(PriceService $priceService)
    {
        $this->priceService = $priceService;
    }

    /**
     * @OA\Get(
     *     path="/prices/latest",
     *     summary="Get latest gold price by country",
     *     description="Returns the latest gold price record for a specified country id",
     *     operationId="getLatestPrice",
     *     tags={"Prices"},
     *     @OA\Parameter(
     *         name="country_id",
     *         in="query",
     *         description="ID of the country to fetch latest gold price for",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successful operation",
     *         @OA\JsonContent(ref="#/components/schemas/PriceResource")
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Country ID is required"
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Price not found"
     *     )
     * )
     */
    public function latest(Request $request)
    {
        $countryId = $request->query('country_id');
        if (!$countryId) {
            return response()->json(['message' => 'Country ID is required'], 400);
        }
        
        $price = $this->priceService->getLatestPrice((int)$countryId);
        
        if (!$price) {
            return response()->json(['message' => 'Price not found'], 404);
        }

        return new PriceResource($price);
    }
}
