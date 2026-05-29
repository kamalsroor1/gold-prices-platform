<?php

namespace Database\Factories\Domains\Price;

use App\Domains\Price\Models\GoldPriceCandle;
use Illuminate\Database\Eloquent\Factories\Factory;

class GoldPriceCandleFactory extends Factory
{
    protected $model = GoldPriceCandle::class;

    public function definition(): array
    {
        return [
            'karat' => 24,
            'open' => $this->faker->randomFloat(2, 3000, 3500),
            'high' => $this->faker->randomFloat(2, 3500, 4000),
            'low' => $this->faker->randomFloat(2, 2500, 3000),
            'close' => $this->faker->randomFloat(2, 3000, 3500),
            'time_frame' => '1d',
            'start_at' => now(),
        ];
    }
}
