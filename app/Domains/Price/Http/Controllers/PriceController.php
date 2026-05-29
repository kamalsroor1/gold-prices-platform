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
        
        $prices = $this->priceService->getLatestPrice((int)$countryId);
        
        if ($prices->isEmpty()) {
            return response()->json(['message' => 'Price not found'], 404);
        }

        return PriceResource::collection($prices);
    }

    public function history(Request $request)
    {
        $countryId = $request->query('country_id', 1);
        $karat = $request->query('karat');
        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');
        $perPage = $request->query('per_page', 15);

        $karatVal = ($karat && $karat !== 'all') ? (int)$karat : null;

        $history = $this->priceService->getHistory((int)$countryId, $karatVal, $startDate, $endDate, (int)$perPage);

        return response()->json($history);
    }
}
