<?php

namespace App\Domains\Bullion\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Domains\Bullion\Services\BullionService;
use App\Domains\Bullion\Http\Resources\BullionResource;
use Illuminate\Http\Request;

class BullionController extends Controller
{
    protected $bullionService;

    public function __construct(BullionService $bullionService)
    {
        $this->bullionService = $bullionService;
    }

    public function index(Request $request)
    {
        $countryId = $request->query('country_id', 1);
        $bullions = $this->bullionService->getBullions((int)$countryId);
        
        return BullionResource::collection($bullions);
    }
}
