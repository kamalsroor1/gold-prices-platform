<?php

namespace Database\Factories\Domains\Price;

use App\Domains\Price\Models\GoldPriceCandle;
use App\Domains\Country\Models\Country;
use Illuminate\Database\Eloquent\Factories\Factory;

class GoldPriceCandleFactory extends Factory
{
    protected $model = GoldPriceCandle::class;

    public function definition(): array
    {
        return [
            'country_id' => Country::first()?->id ?? Country::factory(),
            'karat' => 24,
            'price' => $this->faker->randomFloat(2, 3000, 3500),
            'open_time' => now()->subMinutes(10),
            'close_time' => now(),
        ];
    }
}
