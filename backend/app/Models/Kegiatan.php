<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kegiatan extends Model
{
    protected $table = 'kegiatan';

    protected $fillable = [
        'nama',
        'kategori',
        'penanggung_jawab',
        'biaya',
        'tanggal',
        'lokasi',
    ];

    protected $casts = [
        'tanggal' => 'date:Y-m-d',
    ];
}
