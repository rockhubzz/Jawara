<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Keluarga extends Model
{
    protected $table = 'keluarga';

    protected $fillable = [
        'nama_keluarga',
        'kepala_keluarga',
        'alamat',
        'kepemilikan',
        'status',
    ];
}
