<?php

namespace App\Domains\Country\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @OA\Schema(
 *     schema="CountryResource",
 *     title="Country Resource",
 *     description="Country resource representation",
 *     @OA\Property(property="id", type="integer", example=1),
 *     @OA\Property(property="name", type="string", example="Saudi Arabia"),
 *     @OA\Property(property="code", type="string", example="SA"),
 *     @OA\Property(property="currency", type="string", example="SAR"),
 *     @OA\Property(property="flag_url", type="string", example="https://example.com/flags/sa.png")
 * )
 */
class CountryResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'code' => $this->code,
            'currency' => $this->currency,
            'flag_url' => $this->flag_url,
        ];
    }
}
