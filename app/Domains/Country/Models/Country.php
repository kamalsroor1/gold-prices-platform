<?php

namespace App\Domains\Country\Models;

use Illuminate\Database\Eloquent\Model;

use Illuminate\Database\Eloquent\Factories\HasFactory;

class Country extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'name', 'code', 'currency', 'flag_url', 'is_active'
    ];

    public function goldPrices()
    {
        return $this->hasMany(GoldPrice::class);
    }

    protected static function newFactory()
    {
        return \Database\Factories\Domains\Country\CountryFactory::new();
    }
}
