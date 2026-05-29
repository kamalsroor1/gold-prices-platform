<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Country\Models\Country;
use App\Domains\Brand\Models\Brand;

class BrandSeeder extends Seeder
{
    public function run(): void
    {
        $countries = Country::all();
        $brandNames = ['BTC', 'SAM', 'PAMP', 'Valcambi'];

        foreach ($countries as $country) {
            foreach ($brandNames as $name) {
                Brand::create([
                    'country_id' => $country->id,
                    'name' => $name,
                    'logo_url' => 'assets/logos/' . strtolower($name) . '.png',
                ]);
            }
        }
    }
}
