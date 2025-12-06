<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBroadcastsTable extends Migration
{
    public function up()
    {
        Schema::create('broadcasts', function (Blueprint $table) {
            $table->id();
            $table->string('sender')->nullable();          // pengirim
            $table->string('title');
            $table->text('body')->nullable();
            $table->date('date')->nullable();             // tanggal broadcast
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('broadcasts');
    }
}
