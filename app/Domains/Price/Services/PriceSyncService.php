<?php

namespace App\Domains\Price\Services;

use App\Domains\Price\Contracts\ExternalPriceProviderInterface;
use App\Domains\Price\Repositories\Interfaces\PriceRepositoryInterface;

class PriceSyncService
{
    protected $priceRepository;
    protected $priceProvider;

    public function __construct(
        PriceRepositoryInterface $priceRepository,
        ExternalPriceProviderInterface $priceProvider
    ) {
        $this->priceRepository = $priceRepository;
        $this->priceProvider = $priceProvider;
    }

    public function syncPrices(int $countryId)
    {
        try {
            $prices = $this->priceProvider->fetchLatestPrices();

            foreach ($prices as $karat => $price) {
                // 1. Get previous price before update
                $oldPriceRecord = \App\Domains\Price\Models\GoldPrice::where('country_id', $countryId)
                    ->where('karat', $karat)
                    ->first();

                $oldPrice = $oldPriceRecord ? (float) $oldPriceRecord->price : null;

                // 2. Update price in database safely
                $this->priceRepository->create([
                    'country_id' => $countryId,
                    'karat' => $karat,
                    'price' => $price,
                ]);

                // 3. Compare and trigger automated notifications if price changed
                if ($oldPrice !== null && $oldPrice != $price) {
                    $changePercent = (($price - $oldPrice) / $oldPrice) * 100;
                    $direction = $changePercent > 0 ? 'صعود' : 'هبوط';
                    $formattedPercent = abs(round($changePercent, 2));

                    // سجل الحدث في الـ Logs لمحاكاة الإشعارات التلقائية الفورية
                    \Log::info("🔔 AUTOMATED PUSH NOTIFICATION SENT: تغير سعر الذهب عيار {$karat} في الدولة {$countryId} ({$direction} بنسبة {$formattedPercent}%). السعر الجديد: {$price}، السعر القديم: {$oldPrice}");
                }
            }
        } catch (\Exception $e) {
            // سجل الخطأ أو قم بإخطار نظام المراقبة
            \Log::error("Failed to sync prices for country {$countryId}: " . $e->getMessage());
            throw $e;
        }
    }
}
