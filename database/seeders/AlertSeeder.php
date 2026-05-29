<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Domains\Country\Models\Country;
use App\Domains\Alert\Models\Alert;

class AlertSeeder extends Seeder
{
    public function run(): void
    {
        $users = User::all();
        $countries = Country::all();

        foreach ($users as $user) {
            foreach ($countries as $country) {
                // إنشاء تنبيهين لكل مستخدم وبلد
                Alert::create([
                    'user_id' => $user->id,
                    'country_id' => $country->id,
                    'karat' => 24,
                    'target_price' => 3600.00,
                    'is_active' => true,
                ]);

                Alert::create([
                    'user_id' => $user->id,
                    'country_id' => $country->id,
                    'karat' => 21,
                    'target_price' => 2950.00,
                    'is_active' => false,
                ]);
            }
        }
    }
}
