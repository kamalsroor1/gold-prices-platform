<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Bullion\Models\Bullion;

class GoldProductSeeder extends Seeder
{
    public function run(): void
    {
        $products = [
            ['type' => 'سبيكة ذهب BTC وزن 1 جرام', 'weight' => 1.0, 'karat' => 24],
            ['type' => 'سبيكة ذهب BTC وزن 5 جرام', 'weight' => 5.0, 'karat' => 24],
            ['type' => 'سبيكة ذهب BTC وزن 10 جرام', 'weight' => 10.0, 'karat' => 24],
            ['type' => 'سبيكة ذهب BTC وزن 20 جرام', 'weight' => 20.0, 'karat' => 24],
            ['type' => 'جنيه ذهب BTC وزن 8 جرام', 'weight' => 8.0, 'karat' => 21],
            ['type' => 'نصف جنيه ذهب BTC وزن 4 جرام', 'weight' => 4.0, 'karat' => 21],
            ['type' => 'سبيكة ذهب سويسري وزن 50 جرام', 'weight' => 50.0, 'karat' => 24],
            ['type' => 'سبيكة ذهب سويسري وزن 100 جرام', 'weight' => 100.0, 'karat' => 24],
        ];

        foreach ($products as $product) {
            Bullion::create($product);
        }
    }
}
