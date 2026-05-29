<?php

namespace Database\Factories\Domains\Price;

use App\Domains\Price\Models\PricingRule;
use Illuminate\Database\Eloquent\Factories\Factory;

class PricingRuleFactory extends Factory
{
    protected $model = PricingRule::class;

    public function definition(): array
    {
        return [
            'type' => $this->faker->randomElement(['tax', 'making_charge', 'cashback']),
            'value' => $this->faker->randomFloat(2, 5, 100),
        ];
    }
}
