<?php

namespace Database\Factories\Domains\Alert;

use App\Domains\Alert\Models\Alert;
use App\Models\User;
use App\Domains\Country\Models\Country;
use Illuminate\Database\Eloquent\Factories\Factory;

class AlertFactory extends Factory
{
    protected $model = Alert::class;

    public function definition(): array
    {
        return [
            'user_id' => User::first()?->id ?? User::factory(),
            'country_id' => Country::first()?->id ?? Country::factory(),
            'karat' => $this->faker->randomElement([24, 21, 18]),
            'target_price' => $this->faker->randomFloat(2, 2500, 3800),
            'is_active' => $this->faker->boolean(80),
        ];
    }
}
