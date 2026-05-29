<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Create specific user
        User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'phone_number' => '01012316954',
            'password' => Hash::make('password'),
        ]);

        $this->call([
            CountrySeeder::class,
            BrandSeeder::class,
            GoldPricesSeeder::class,
            GoldPriceHistorySeeder::class,
            AlertSeeder::class,
            PricingRuleSeeder::class,
            ExchangeRateSeeder::class,
            GoldPriceCandleSeeder::class,
        ]);
    }
}
