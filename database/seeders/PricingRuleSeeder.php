<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domains\Brand\Models\Brand;
use App\Domains\Bullion\Models\Bullion;
use App\Domains\Price\Models\PricingRule;

class PricingRuleSeeder extends Seeder
{
    public function run(): void
    {
        $brands = Brand::all();
        $products = Bullion::all();

        foreach ($brands as $brand) {
            foreach ($products as $product) {
                PricingRule::create([
                    'brand_id' => $brand->id,
                    'product_id' => $product->id,
                    'premium_per_gram' => rand(50, 150) / 10,
                    'cashback_per_gram' => rand(10, 40) / 10,
                    'tax_percentage' => rand(10, 50) / 10,
                    'fixed_fees' => rand(50, 200) / 10,
                ]);
            }
        }
    }
}
