<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. يجب أولاً تشغيل CountrySeeder لتجهيز الدول (بما فيها الدولة رقم 1) لمنع خطأ الـ Foreign Key
        $this->call([
            CountrySeeder::class,
        ]);

        // 2. إنشاء المستخدم التجريبي بعد وجود الدول في قاعدة البيانات
        User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'phone_number' => '01012316954',
            'password' => Hash::make('password'),
            'country_id' => 1,
        ]);

        // 3. تشغيل باقي الـ Seeders لإكمال تهيئة قاعدة البيانات
        $this->call([
            GoldProductSeeder::class,
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
