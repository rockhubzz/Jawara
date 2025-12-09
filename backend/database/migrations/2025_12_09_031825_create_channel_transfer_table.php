<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateChannelTransferTable extends Migration
{
    public function up()
    {
        Schema::create('channel_transfer', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->string('tipe'); // e.g. bank, ewallet, qris
            $table->string('an')->nullable(); // account name
            $table->string('nomor')->nullable(); // account number (optional)
            $table->string('thumbnail')->nullable(); // stored path/URL
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('payment_channels');
    }
}
