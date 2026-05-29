<?php

namespace Database\Factories\Domains\Price;

use App\Domains\Price\Models\ExchangeRate;
use App\Domains\Country\Models\Country;
use Illuminate\Database\Eloquent\Factories\Factory;

class ExchangeRateFactory extends Factory
{
    protected $model = ExchangeRate::class;

    public function definition(): array
    {
        return [
            'country_id' => Country::first()?->id ?? Country::factory(),
            'rate' => $this->faker->randomFloat(6, 1.0, 50.0),
        ];
    }
}
