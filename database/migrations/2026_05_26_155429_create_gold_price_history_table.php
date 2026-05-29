<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('gold_price_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('country_id')->constrained('countries');
            $table->integer('karat');
            $table->decimal('price', 15, 2);
            $table->timestamps();

            // الفهارس المطلوبة لتحسين الأداء للرسوم البيانية وتاريخ الأسعار
            $table->index(['country_id', 'created_at'], 'idx_country_timestamp');
            $table->index('created_at', 'idx_fetched_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('gold_price_history');
    }
};
