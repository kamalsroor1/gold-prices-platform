<?php

namespace App\Domains\Bullion\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Domains\Country\Models\Country;

class Bullion extends Model
{
    use HasFactory;

    protected $table = 'gold_products';

    protected $fillable = [
        'type', 'weight', 'karat', 'price'
    ];
}
