<?php

namespace App\Domains\Alert\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Domains\Alert\Repositories\Interfaces\AlertRepositoryInterface;
use Illuminate\Http\Request;

class AlertController extends Controller
{
    protected $alertRepository;

    public function __construct(AlertRepositoryInterface $alertRepository)
    {
        $this->alertRepository = $alertRepository;
    }

    public function index(Request $request)
    {
        return response()->json($this->alertRepository->getAllForUser($request->user()->id));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'country_id' => 'required|exists:countries,id',
            'karat' => 'required|integer',
            'target_price' => 'required|numeric',
        ]);
        
        $data['user_id'] = $request->user()->id;
        return response()->json($this->alertRepository->create($data), 201);
    }

    public function destroy(int $id, Request $request)
    {
        $deleted = $this->alertRepository->delete($id, $request->user()->id);
        return $deleted ? response()->json(['message' => 'Deleted']) : response()->json(['message' => 'Not Found'], 404);
    }
}
