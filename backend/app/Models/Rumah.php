<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rumah extends Model
{
    protected $table = 'rumah';

    protected $fillable = [
        'alamat',
        'kode',
        'status',
        'keterangan',
    ];
}
