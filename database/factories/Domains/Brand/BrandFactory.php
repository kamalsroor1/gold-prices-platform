<?php

namespace Database\Factories\Domains\Brand;

use App\Domains\Brand\Models\Brand;
use Illuminate\Database\Eloquent\Factories\Factory;

class BrandFactory extends Factory
{
    protected $model = Brand::class;

    public function definition(): array
    {
        return [
            'name' => $this->faker->unique()->randomElement(['BTC', 'SAM', 'PAMP', 'Valcambi']),
        ];
    }
}
