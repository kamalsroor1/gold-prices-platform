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
