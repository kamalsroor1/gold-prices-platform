<?php

namespace App\Domains\Price\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PricingRule extends Model
{
    use HasFactory;
    protected $fillable = ['type', 'value'];
}
