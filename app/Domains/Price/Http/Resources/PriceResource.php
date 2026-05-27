<?php

namespace App\Domains\Price\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

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
