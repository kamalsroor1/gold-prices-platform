<?php

namespace App\Domains\Country\Models;

use Illuminate\Database\Eloquent\Model;

class Country extends Model
{
    protected $fillable = [
        'name', 'code', 'currency', 'flag_url', 'is_active'
    ];

    public function goldPrices()
    {
        return $this->hasMany(GoldPrice::class);
    }
}
