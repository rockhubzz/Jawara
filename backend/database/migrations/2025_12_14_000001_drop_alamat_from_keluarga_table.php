<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('keluarga', function (Blueprint $table) {
            $table->dropColumn('alamat');
        });
    }

    public function down(): void
    {
        Schema::table('keluarga', function (Blueprint $table) {
            $table->string('alamat')->nullable();
        });
    }
};