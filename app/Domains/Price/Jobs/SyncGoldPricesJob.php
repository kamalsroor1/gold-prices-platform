<?php

namespace App\Domains\Price\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Domains\Price\Services\PriceSyncService;

class SyncGoldPricesJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $countryId;

    public function __construct(int $countryId)
    {
        $this->countryId = $countryId;
    }

    public function handle(PriceSyncService $syncService)
    {
        $syncService->syncPrices($this->countryId);
    }
}
