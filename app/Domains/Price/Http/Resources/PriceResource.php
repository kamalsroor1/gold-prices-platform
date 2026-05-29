<?php

namespace App\Domains\Price\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @OA\Schema(
 *     schema="PriceResource",
 *     title="Price Resource",
 *     description="Gold price resource representation",
 *     @OA\Property(property="id", type="integer", example=1),
 *     @OA\Property(property="country_id", type="integer", example=1),
 *     @OA\Property(property="karat", type="string", example="24k"),
 *     @OA\Property(property="price", type="number", format="float", example=2500.00),
 *     @OA\Property(property="created_at", type="string", format="date-time", example="2026-05-27T12:00:00Z")
 * )
 */
class PriceResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'country_id' => $this->country_id,
            'karat' => $this->karat,
            'price' => $this->price,
            'created_at' => $this->created_at,
        ];
    }
}
