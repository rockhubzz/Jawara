<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMutasiTable extends Migration
{
    public function up()
    {
        Schema::create('mutasi_keluarga', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('keluarga_id')->nullable();
            $table->string('jenis_mutasi')->nullable();
            $table->date('tanggal')->nullable();
            $table->text('alasan')->nullable();
            $table->timestamps();

            // foreign key (optional cascade behavior - adjust to your policies)
            $table->foreign('keluarga_id')
                  ->references('id')
                  ->on('keluarga')
                  ->onDelete('set null');
        });
    }

    public function down()
    {
        Schema::dropIfExists('mutasi_keluarga');
    }
}
