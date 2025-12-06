<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('pemasukan_lain', function (Blueprint $table) {
            $table->id();
            $table->string('nama');                       // nama pemberi
            $table->string('jenis');                      // jenis pemasukan
            $table->date('tanggal');                      // tanggal pemasukan
            $table->bigInteger('nominal');                // nominal
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('pemasukan_lain');
    }
};
