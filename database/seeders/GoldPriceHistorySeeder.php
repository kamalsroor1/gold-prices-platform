<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Country\Models\Country;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class GoldPriceHistorySeeder extends Seeder
{
    public function run(): void
    {
        $countries = Country::all();
        $karats = [24, 21, 18];

        foreach ($countries as $country) {
            foreach ($karats as $karat) {
                // توليد أسعار تاريخية لآخر 30 يوماً
                for ($i = 30; $i >= 0; $i--) {
                    $date = Carbon::now()->subDays($i);
                    $basePrice = 3000 + ($karat * 50);
                    
                    DB::table('gold_price_history')->insert([
                        'country_id' => $country->id,
                        'karat' => $karat,
                        'price' => $basePrice + rand(-100, 100),
                        'created_at' => $date,
                        'updated_at' => $date,
                    ]);
                }
            }
        }
    }
}
