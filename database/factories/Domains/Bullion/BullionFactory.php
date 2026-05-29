<?php

namespace Database\Factories\Domains\Bullion;

use App\Domains\Bullion\Models\Bullion;
use Illuminate\Database\Eloquent\Factories\Factory;

class BullionFactory extends Factory
{
    protected $model = Bullion::class;

    public function definition(): array
    {
        return [
            'type' => $this->faker->randomElement(['سبيكة ذهب', 'جنيه ذهب', 'نصف جنيه ذهب', 'سبيكة ذهب سويسري']),
            'weight' => $this->faker->randomElement([1.0, 5.0, 10.0, 20.0, 31.1, 50.0, 100.0]),
            'karat' => $this->faker->randomElement([24, 21, 18]),
        ];
    }
}
