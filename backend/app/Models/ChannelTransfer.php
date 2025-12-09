<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ChannelTransfer extends Model
{
    protected $table = 'channel_transfer';

    protected $fillable = [
        'nama',
        'tipe',
        'an',
        'nomor',
        'thumbnail',
        'notes',
    ];
}
