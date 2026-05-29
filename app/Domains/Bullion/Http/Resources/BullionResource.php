<?php

namespace App\Domains\Bullion\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class BullionResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->type,
            'weight' => (float) $this->weight,
            'karat' => (string) $this->karat,
            'price' => (float) $this->price,
        ];
    }
}
