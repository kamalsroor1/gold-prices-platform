<?php

namespace App\Domains\Brand\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Domains\Country\Models\Country;

class Brand extends Model
{
    use HasFactory;

    protected $fillable = ['country_id', 'name', 'logo_url'];

    public function country()
    {
        return $this->belongsTo(Country::class);
    }
}
