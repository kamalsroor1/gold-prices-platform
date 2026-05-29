<?php

namespace App\Domains\Alert\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Models\User;
use App\Domains\Country\Models\Country;

class Alert extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'country_id', 'karat', 'target_price', 'is_active'
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function country()
    {
        return $this->belongsTo(Country::class);
    }
}
