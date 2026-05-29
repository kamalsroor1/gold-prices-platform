<?php

namespace App\Domains\Price\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Domains\Country\Models\Country;

class GoldPriceCandle extends Model
{
    use HasFactory;
    protected $fillable = ['country_id', 'karat', 'open', 'high', 'low', 'close', 'time_frame', 'start_at'];

    public function country()
    {
        return $this->belongsTo(Country::class);
    }
}
