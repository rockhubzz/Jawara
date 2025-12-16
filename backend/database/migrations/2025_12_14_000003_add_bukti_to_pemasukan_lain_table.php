<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('pemasukan_lain', function (Blueprint $table) {
            $table->string('bukti')->nullable(); // stored path/URL for image
        });
    }

    public function down(): void
    {
        Schema::table('pemasukan_lain', function (Blueprint $table) {
            $table->dropColumn('bukti');
        });
    }
};