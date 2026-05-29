<?php

namespace Database\Factories\Domains\Country;

use App\Domains\Country\Models\Country;
use Illuminate\Database\Eloquent\Factories\Factory;

class CountryFactory extends Factory
{
    protected $model = Country::class;

    public function definition(): array
    {
        return [
            'name' => $this->faker->country,
            'code' => $this->faker->countryCode,
            'currency' => $this->faker->currencyCode,
            'is_active' => true,
        ];
    }
}
