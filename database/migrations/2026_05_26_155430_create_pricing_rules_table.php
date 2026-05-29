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
        Schema::create('pricing_rules', function (Blueprint $table) {
            $table->id();
            $table->foreignId('brand_id')->constrained('brands');
            $table->foreignId('product_id')->constrained('gold_products');
            $table->decimal('premium_per_gram', 10, 2);
            $table->decimal('cashback_per_gram', 10, 2);
            $table->decimal('tax_percentage', 5, 2)->default(0.00);
            $table->decimal('fixed_fees', 10, 2)->default(0.00);
            $table->timestamps();

            // الفهارس المطلوبة لتحسين الأداء
            $table->index(['brand_id', 'product_id'], 'idx_brand_product');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pricing_rules');
    }
};
