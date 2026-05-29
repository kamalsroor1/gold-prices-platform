<?php

namespace Database\Factories\Domains\Price;

use App\Domains\Price\Models\GoldPrice;
use App\Domains\Country\Models\Country;
use Illuminate\Database\Eloquent\Factories\Factory;

class GoldPriceFactory extends Factory
{
    protected $model = GoldPrice::class;

    public function definition(): array
    {
        return [
            'country_id' => Country::factory(),
            'karat' => $this->faker->randomElement([24, 21, 18]),
            'price' => $this->faker->randomFloat(2, 2000, 4000),
            'updated_at' => now(),
        ];
    }
}
