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
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('country_id')->default(1)->constrained('countries')->after('api_token');
            $table->boolean('price_alerts_enabled')->default(true)->after('country_id');
            $table->boolean('periodic_alerts_enabled')->default(true)->after('price_alerts_enabled');
            $table->boolean('daily_summary_enabled')->default(true)->after('periodic_alerts_enabled');
            $table->string('app_language', 20)->default('العربية')->after('daily_summary_enabled');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropConstrainedForeignId('country_id');
            $table->dropColumn([
                'price_alerts_enabled',
                'periodic_alerts_enabled',
                'daily_summary_enabled',
                'app_language'
            ]);
        });
    }
};
