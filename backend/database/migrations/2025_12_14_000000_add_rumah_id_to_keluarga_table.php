<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('keluarga', function (Blueprint $table) {
            $table->unsignedBigInteger('rumah_id')->nullable()->unique();
            $table->foreign('rumah_id')->references('id')->on('rumah')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::table('keluarga', function (Blueprint $table) {
            $table->dropForeign(['rumah_id']);
            $table->dropColumn('rumah_id');
        });
    }
};