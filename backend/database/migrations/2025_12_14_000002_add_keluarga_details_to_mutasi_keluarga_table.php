<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('mutasi_keluarga', function (Blueprint $table) {
            $table->string('nama_keluarga')->nullable();
            $table->string('kepala_keluarga')->nullable();
            $table->string('alamat')->nullable();
            $table->string('kepemilikan')->nullable();
            $table->string('status_keluarga')->nullable();
            $table->unsignedBigInteger('rumah_id')->nullable();
            $table->foreign('rumah_id')->references('id')->on('rumah')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::table('mutasi_keluarga', function (Blueprint $table) {
            $table->dropForeign(['rumah_id']);
            $table->dropColumn(['nama_keluarga', 'kepala_keluarga', 'alamat', 'kepemilikan', 'status_keluarga', 'rumah_id']);
        });
    }
};