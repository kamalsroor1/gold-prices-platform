<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Country\Models\Country;
use App\Domains\Price\Models\GoldPriceCandle;
use Carbon\Carbon;

class GoldPriceCandleSeeder extends Seeder
{
    public function run(): void
    {
        $countries = Country::all();
        $karats = [24, 21, 18];

        foreach ($countries as $country) {
            foreach ($karats as $karat) {
                // توليد شموع سعرية لآخر 5 ساعات
                for ($i = 5; $i >= 0; $i--) {
                    $openTime = Carbon::now()->subHours($i)->startOfHour();
                    $closeTime = $openTime->copy()->endOfHour();
                    $basePrice = 3000 + ($karat * 50);

                    GoldPriceCandle::create([
                        'country_id' => $country->id,
                        'karat' => $karat,
                        'price' => $basePrice + rand(-50, 50),
                        'open_time' => $openTime,
                        'close_time' => $closeTime,
                    ]);
                }
            }
        }
    }
}
