<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Country\Models\Country;

class CountrySeeder extends Seeder
{
    public function run(): void
    {
        $countries = [
            ['name' => 'Egypt', 'code' => 'EG', 'currency' => 'EGP'],
            ['name' => 'Saudi Arabia', 'code' => 'SA', 'currency' => 'SAR'],
            ['name' => 'United Arab Emirates', 'code' => 'AE', 'currency' => 'AED'],
            ['name' => 'Kuwait', 'code' => 'KW', 'currency' => 'KWD'],
        ];

        foreach ($countries as $countryData) {
            \App\Domains\Country\Models\Country::factory()->create($countryData);
        }
    }
}
