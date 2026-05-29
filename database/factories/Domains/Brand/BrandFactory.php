<?php

namespace Database\Factories\Domains\Brand;

use App\Domains\Brand\Models\Brand;
use App\Domains\Country\Models\Country;
use Illuminate\Database\Eloquent\Factories\Factory;

class BrandFactory extends Factory
{
    protected $model = Brand::class;

    public function definition(): array
    {
        return [
            'country_id' => Country::first()?->id ?? Country::factory(),
            'name' => $this->faker->unique()->randomElement(['BTC', 'SAM', 'PAMP', 'Valcambi']),
        ];
    }
}
