<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('warga', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->string('nik')->unique();
            $table->unsignedBigInteger('keluarga_id'); // FK

            $table->enum('jenis_kelamin', ['Laki-laki', 'Perempuan']);
            $table->enum('status_domisili', ['Aktif', 'Tidak Aktif']);
            $table->enum('status_hidup', ['Hidup', 'Wafat']);

            $table->timestamps();

            // FK Constraint
            $table->foreign('keluarga_id')
                  ->references('id')
                  ->on('keluarga')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('warga');
    }
};
