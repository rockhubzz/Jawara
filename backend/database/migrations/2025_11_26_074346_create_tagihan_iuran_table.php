<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tagihan_iuran', function (Blueprint $table) {
            $table->id();

            // Foreign key keluarga
            $table->unsignedBigInteger('keluarga_id');

            // Foreign key jenis iuran
            $table->unsignedBigInteger('kategori_iuran_id');

            // Besaran iuran
            $table->integer('jumlah')->default(0);

            // Tanggal tagihan
            $table->date('tanggal_tagihan');

            // Status iuran
            $table->enum('status', ['belum_bayar', 'sudah_bayar'])
                  ->default('belum_bayar');

            $table->timestamps();

            // Relations
            $table->foreign('keluarga_id')
                  ->references('id')
                  ->on('keluarga')
                  ->onDelete('cascade');

            $table->foreign('kategori_iuran_id')
                  ->references('id')
                  ->on('kategori_iuran')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tagihan_iuran');
    }
};
