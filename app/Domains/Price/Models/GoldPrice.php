<?php

namespace App\Domains\Price\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Domains\Country\Models\Country;

class GoldPrice extends Model
{
    use HasFactory;

    protected $fillable = [
        'country_id', 'karat', 'price'
    ];

    protected static function newFactory()
    {
        return \Database\Factories\Domains\Price\GoldPriceFactory::new();
    }

    public function country()
    {
        return $this->belongsTo(Country::class);
    }
}