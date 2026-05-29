<?php

namespace App\Domains\Price\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Domains\Country\Models\Country;

class GoldPriceCandle extends Model
{
    use HasFactory;
    protected $fillable = ['country_id', 'karat', 'price', 'open_time', 'close_time'];

    public function country()
    {
        return $this->belongsTo(Country::class);
    }
}
