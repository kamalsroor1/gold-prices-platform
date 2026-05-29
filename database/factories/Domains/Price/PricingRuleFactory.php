<?php

namespace Database\Factories\Domains\Price;

use App\Domains\Price\Models\PricingRule;
use App\Domains\Brand\Models\Brand;
use App\Domains\Bullion\Models\Bullion;
use Illuminate\Database\Eloquent\Factories\Factory;

class PricingRuleFactory extends Factory
{
    protected $model = PricingRule::class;

    public function definition(): array
    {
        return [
            'brand_id' => Brand::first()?->id ?? Brand::factory(),
            'product_id' => Bullion::first()?->id ?? Bullion::factory(),
            'premium_per_gram' => $this->faker->randomFloat(2, 5, 20),
            'cashback_per_gram' => $this->faker->randomFloat(2, 1, 5),
            'tax_percentage' => $this->faker->randomFloat(2, 0.05, 5.0),
            'fixed_fees' => $this->faker->randomFloat(2, 0, 50),
        ];
    }
}
