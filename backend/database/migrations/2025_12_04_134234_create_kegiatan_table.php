<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateKegiatanTable extends Migration
{
    public function up()
    {
        Schema::create('kegiatan', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->string('kategori')->nullable();
            $table->string('penanggung_jawab')->nullable();
            $table->integer('biaya')->nullable();
            $table->date('tanggal')->nullable();
            $table->text('lokasi')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('kegiatan');
    }
}
