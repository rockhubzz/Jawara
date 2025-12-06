<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('kategori_iuran', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->enum('jenis', ['Rutin','Khusus'])->default('Rutin');
            $table->bigInteger('nominal')->default(0); // store as integer (cents or full rupiah)
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kategori_iuran');
    }
};
