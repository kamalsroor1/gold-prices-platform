<?php

namespace App\Domains\Price\Models;

use Illuminate\Database\Eloquent\Model;
use App\Domains\Country\Models\Country;

class GoldPrice extends Model
{
    protected $fillable = [
        'country_id', 'karat', 'price'
    ];

    public function country()
    {
        return $this->belongsTo(Country::class);
    }
}