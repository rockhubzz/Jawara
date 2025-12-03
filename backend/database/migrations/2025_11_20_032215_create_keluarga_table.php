<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateKeluargaTable extends Migration
{
    public function up()
    {
        Schema::create('keluarga', function (Blueprint $table) {
            $table->id();
            $table->string('nama_keluarga');
            $table->string('kepala_keluarga');
            $table->string('alamat');
            $table->string('kepemilikan'); // contoh: kontrak, pribadi, dinas
            $table->string('status'); // contoh: aktif / tidak aktif
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('keluarga');
    }
}
