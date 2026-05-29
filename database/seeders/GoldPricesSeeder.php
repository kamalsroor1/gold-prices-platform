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
        $karats = [24, 21, 18];

        foreach ($countries as $country) {
            foreach ($karats as $karat) {
                GoldPrice::create([
                    'country_id' => $country->id,
                    'karat' => $karat,
                    'price' => 3000 + ($karat * 50),
                ]);
            }
        }
    }
}
