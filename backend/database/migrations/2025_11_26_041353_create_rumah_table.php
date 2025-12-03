<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('rumah', function (Blueprint $table) {
            $table->id();
            $table->string('alamat');
            $table->string('kode', 50)->nullable(); // optional code/identifier
            $table->enum('status', ['Tersedia', 'Ditempati', 'Nonaktif'])->default('Tersedia');
            $table->string('keterangan')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rumah');
    }
};
