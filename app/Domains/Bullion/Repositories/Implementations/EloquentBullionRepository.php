<?php

namespace App\Domains\Bullion\Repositories\Implementations;

use App\Domains\Bullion\Models\Bullion;
use App\Domains\Bullion\Repositories\Interfaces\BullionRepositoryInterface;
use App\Domains\Price\Models\GoldPrice;
use App\Domains\Price\Models\PricingRule;

class EloquentBullionRepository implements BullionRepositoryInterface
{
    public function getAll(int $countryId)
    {
        $products = Bullion::all();

        foreach ($products as $product) {
            // 1. Get gold price for the karat of this product
            $goldPriceRecord = GoldPrice::where('country_id', $countryId)
                ->where('karat', $product->karat)
                ->first();

            $goldPrice = $goldPriceRecord ? (float) $goldPriceRecord->price : 3000.0; // default if not found

            // 2. Get pricing rules for this product
            $rule = PricingRule::where('product_id', $product->id)->first();

            $premiumPerGram = $rule ? (float) $rule->premium_per_gram : 50.0;
            $taxPercentage = $rule ? (float) $rule->tax_percentage : 5.0; // 5%
            $fixedFees = $rule ? (float) $rule->fixed_fees : 10.0;

            // 3. Calculate bullion price
            // Price = (weight * gold_price) + (weight * premium) + tax + fixed_fees
            $baseGoldValue = $product->weight * $goldPrice;
            $premiumValue = $product->weight * $premiumPerGram;
            $taxValue = $baseGoldValue * ($taxPercentage / 100);

            $product->price = $baseGoldValue + $premiumValue + $taxValue + $fixedFees;
        }

        return $products;
    }
}
