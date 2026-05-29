<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Country\Models\Country;
use App\Domains\Price\Models\GoldPrice;

class GoldPricesSeeder extends Seeder
{
    public function run(): void
    {
        $countries = Country::all();

        foreach ($countries as $country) {
            GoldPrice::factory()->create([
                'country_id' => $country->id,
                'karat' => 24,
                'price' => 3500.50,
            ]);
            
            GoldPrice::factory()->create([
                'country_id' => $country->id,
                'karat' => 21,
                'price' => 3060.00,
            ]);
        }
    }
}
