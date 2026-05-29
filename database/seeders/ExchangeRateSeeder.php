<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Country\Models\Country;
use App\Domains\Price\Models\ExchangeRate;

class ExchangeRateSeeder extends Seeder
{
    public function run(): void
    {
        $countries = Country::all();

        foreach ($countries as $country) {
            $rate = 1.0;
            if ($country->currency === 'EGP') {
                $rate = 47.50;
            } elseif ($country->currency === 'SAR') {
                $rate = 3.75;
            } elseif ($country->currency === 'AED') {
                $rate = 3.67;
            } elseif ($country->currency === 'KWD') {
                $rate = 0.31;
            }

            ExchangeRate::create([
                'country_id' => $country->id,
                'rate' => $rate,
            ]);
        }
    }
}
